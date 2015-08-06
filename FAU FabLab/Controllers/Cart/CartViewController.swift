import UIKit
import Foundation



class CartViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
    
    @IBOutlet weak var checkoutButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
   
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    private var cartModel = CartModel.sharedInstance
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "checkoutCodeScanned:", name: "CheckoutScannerNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "checkoutStatusChanged:", name: "CheckoutStatusChangedNotification", object: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
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
    
    

    //Observer -> Scanner
    func checkoutCodeScanned(notification:NSNotification) {
        cartModel.sendCartToServer(notification.object as! String)
    }
    
    //Observer -> Status changed
    func checkoutStatusChanged(notification:NSNotification) {
        if let newStatus = Cart.CartStatus(rawValue: notification.object as! String) {
            switch(newStatus){
                case Cart.CartStatus.SHOPPING:
                    //cart is still @shopping -> error happend -> Code was wrong
                    let alertView = UIAlertView(title: "Fehler", message: "Der gescannte Code wurde nicht akzeptiert. Bitte den Code vom Kassenterminal scannen.", delegate: nil, cancelButtonTitle: "OK")
                    alertView.show()
                
                case Cart.CartStatus.PENDING:
                    var popoverContent = self.storyboard?.instantiateViewControllerWithIdentifier("PayOrCancelView") as! PayOrCancelViewController
                    var nav = UINavigationController(rootViewController: popoverContent)
                    nav.modalPresentationStyle = UIModalPresentationStyle.Popover
                    var popover = nav.popoverPresentationController
                    self.presentViewController(nav, animated: true, completion: nil)
              
                case Cart.CartStatus.PAID:
                    let alertView = UIAlertView(title: "Bezahlt", message: "Ihr Warenkorb wurde erfolgreich bezahlt", delegate: nil, cancelButtonTitle: "OK")
                    alertView.show()
                
                case Cart.CartStatus.CANCELLED:
                    let alertView = UIAlertView(title: "Abgebrochen", message: "Bezahlvorgang wurde abgebrochen", delegate: nil, cancelButtonTitle: "OK")
                    alertView.show()
                
                case Cart.CartStatus.FAILED:
                    let alertView = UIAlertView(title: "Fehlgeschlagen", message: "Bezahlvorgang ist Fehlgeschlagen", delegate: nil, cancelButtonTitle: "OK")
                    alertView.show()
                
            }
        }
        disableSpinner()
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
        
        RestManager.sharedInstance.makeJsonGetRequest("/checkout/createCode", params: ["password": "dummyPassword"])
        { (code, error) -> Void in
            self.cartModel.sendCartToServer(String(code as! Int))
        }

    }

    

}