import UIKit
import Foundation
import CoreActionSheetPicker


class CartViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
    
    @IBOutlet weak var checkoutButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
   
    @IBOutlet var labelTotalPrice: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    private var cartModel = CartModel.sharedInstance
    private var cartEntryCellIdentifier = "CartEntryCustomCell"
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "checkoutCodeScanned:", name: "CheckoutScannerNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "checkoutStatusChanged:", name: "CheckoutStatusChangedNotification", object: nil)
    }
    
    private func showTotalPrice(){
        labelTotalPrice.text = String(format: "%.2f€", cartModel.cart.getPrice());
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        showTotalPrice()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartModel.cart.getCount()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cartEntryCellIdentifier) as? CartEntryCustomCell
        let cartEntry = cartModel.cart.getEntry(indexPath.row)
        cell!.configure(cartEntry.product.name, unit: "\(Int(cartEntry.amount)) \(cartEntry.product.unit)", price: cartEntry.product.price * cartEntry.amount)
        cell!.selectionStyle = UITableViewCellSelectionStyle.None
        return cell!;
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        /*
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            CartModel.sharedInstance.removeProductFromCart(indexPath.row)
            tableView.reloadData()
            showTotalPrice()
        }
        */
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
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        var editAction = UITableViewRowAction(style: .Normal, title: "Ändern") { (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            var picker: ActionSheetCustomPicker = ActionSheetCustomPicker()
            var doneButton: UIBarButtonItem = UIBarButtonItem()
            doneButton.title = "Übernehmen"
            picker.setDoneButton(doneButton)
            picker.title = "Menge auswählen"
            picker.tapDismissAction = TapAction.Cancel
            picker.hideCancel = true
            let cartEntry = self.cartModel.cart.getEntry(indexPath.row)
            picker.delegate = ActionSheetPickerDelegate(unit: cartEntry.product.unit, price: cartEntry.product.price, didSucceedAction: { (amount: Int) -> Void in
                CartModel.sharedInstance.updateProductInCart(indexPath.row, amount: Double(amount))
                tableView.reloadData();
                tableView.setEditing(false, animated: true)
                }, didCancelAction:{ (Void) -> Void in tableView.setEditing(false, animated: true)} )
            picker.showActionSheetPicker()
        }
        var deleteAction = UITableViewRowAction(style: .Default, title: "Löschen") { (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            CartModel.sharedInstance.removeProductFromCart(indexPath.row)
            tableView.reloadData()
            self.showTotalPrice()
        }
        return [editAction, deleteAction]
    }
    

    
    /*                      DEV BUTTONS                 */
    
    //Just to avoid using camera... get code from Server and start checkout process :)


    @IBAction func DummyScanButtonTouched(sender: AnyObject) {
        RestManager.sharedInstance.makeJsonGetRequest("/checkout/createCode", params: ["password": "dummyPassword"])
        { (code, error) -> Void in
            self.cartModel.sendCartToServer(String(code as! Int))
        }
    }
    
}