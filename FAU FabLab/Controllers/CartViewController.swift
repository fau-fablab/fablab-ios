import UIKit
import Foundation



class CartViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
    
    @IBOutlet weak var checkoutButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    private var cartModel = CartModel()
    private var defaultFontColor: UIColor?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "checkoutCodeScanned:", name: "CheckoutScannerNotification", object: nil)
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
    
    
    @IBAction func checkoutCancelButtonTouched(sender: AnyObject) {
        if(cartModel.isShopping()){
            var popoverContent = self.storyboard?.instantiateViewControllerWithIdentifier("CheckoutCodeScanner") as! UIViewController
            var nav = UINavigationController(rootViewController: popoverContent)
            nav.modalPresentationStyle = UIModalPresentationStyle.Popover
            var popover = nav.popoverPresentationController
        
            self.presentViewController(nav, animated: true, completion: nil)
        }else{
            cartModel.cancelChecoutProcess({ (err) -> Void in
                println(self.cartModel.getStatus())
            })
        }

    }
    
    private func checkoutCodeScanned(notification:NSNotification) {
        println("Got Notification from Scanner, code: \(notification.object)")
        self.checkout(notification.object as! String)
    }
    
    
    private func checkout(code: String){
        cartModel.sendCartToServer(code, onCompletion: { error in
            //TODO Upate GUI / Message ...
            //Disable Bezahlen Button
            //Add button with cancel
            //Show pop up -> Bezahlen gehen 
            
            println("TODO UPDATE GUI")
        
            self.updateCheckoutButton()

        })
        
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
    
    /*                      DEV BUTTONS                 */
    
    //Just to avoid using camera... get code from Server and start checkout process :)
    @IBAction func SCAN(sender: AnyObject) {
        RestManager.sharedInstance.makeJsonGetRequest("/checkout/createCode", params: ["password": "dummyPassword"], onCompletion: {
            json, err in
            self.cartModel.createDummyData()
            self.checkout(String(json as! Int))
        })
        
    }
    
    
    //Check status (DEV BUTTON) --> //TODO Needs to be updated every 3secs if cart is pending
    @IBAction func STATUS(sender: AnyObject) {
        cartModel.checkStatus({
            error in
            //TODO Upate GUI / Message ...
            println("TODO UPDATE GUI")
            
        })
    }
    
    //Set cart to paid -> Get it for free^^ (DEV BUTTON)
    @IBAction func PAID(sender: AnyObject) {
        cartModel.triggerCartWasPaid()
    }
    
    //Set Cart to cancelled (DEV BUTTON)
    @IBAction func CANCELLED(sender: AnyObject) {
        cartModel.triggerCartWasCancelled()
    }
    
}