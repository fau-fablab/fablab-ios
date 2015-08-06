import UIKit
import Foundation



class CartViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
    
    @IBOutlet weak var checkoutButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
   
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    private var cartModel = CartModel()
    private var defaultFontColor: UIColor?
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "checkoutCodeScanned:", name: "CheckoutScannerNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "checkoutStatusChanged:", name: "CheckoutStatusChangedNotification", object: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        defaultFontColor = checkoutButton.tintColor
        self.updateCheckoutButton()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell! = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        return cell;
    }
    
    
    /*                      Checkout process            */
    
    

    //Observeable from Scanner
    func checkoutCodeScanned(notification:NSNotification) {
        println("Got Notification from Scanner, code: \(notification.object)")
        cartModel.sendCartToServer(notification.object as! String)
    }
    
    //Observeable from Scanner
    func checkoutStatusChanged(notification:NSNotification) {
        println("Got Notification from checkoutModel \(notification.object)")
        disableSpinner()
    }
    
    @IBAction func checkoutCancelButtonTouched(sender: AnyObject) {
        if(cartModel.isShopping()){
            var popoverContent = self.storyboard?.instantiateViewControllerWithIdentifier("CheckoutCodeScanner") as! UIViewController
            var nav = UINavigationController(rootViewController: popoverContent)
            nav.modalPresentationStyle = UIModalPresentationStyle.Popover
            var popover = nav.popoverPresentationController
            
            self.presentViewController(nav, animated: true, completion: nil)
        }else{
            cartModel.cancelChecoutProcess({ (err) -> Void in
                Debug.instance.log(self.cartModel.getStatus())
            })
        }
    }

    func updateCheckoutButton(){
        if(self.cartModel.isShopping()){
            self.checkoutButton.title = "Bezahlen"
            self.checkoutButton.tintColor = defaultFontColor
        }else{
            self.checkoutButton.title = "Abbrechen"
            self.checkoutButton.tintColor = UIColor.redColor()
        }
    }
    
    func enableSpinner(){
        activityIndicatorView.startAnimating();
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
    }
    
    func disableSpinner(){
        activityIndicatorView.stopAnimating();
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
    }

    
    /*                      DEV BUTTONS                 */
    
    //Just to avoid using camera... get code from Server and start checkout process :)


    @IBAction func DummyScanButtonTouched(sender: AnyObject) {
        self.enableSpinner()
        
        RestManager.sharedInstance.makeJsonGetRequest("/checkout/createCode", params: ["password": "dummyPassword"]) { (code, error) -> Void in
            self.cartModel.sendCartToServer(String(code as! Int))
        }

    }

    @IBAction func dummyPayButtonTouched(sender: AnyObject) {
    }
    @IBAction func dummyCancelButtonTouched(sender: AnyObject) {
    }

}