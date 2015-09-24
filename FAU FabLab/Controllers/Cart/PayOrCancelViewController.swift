import Foundation
import UIKit

class PayOrCancelViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    private var tableViewCellIdentifier = "PayOrCancelCell"
    private var cartModel = CartModel()
    
    override func viewDidLoad() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "checkoutStatusChanged:", name: "CheckoutStatusChangedNotification", object: nil)
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        spinner.startAnimating()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartModel.getNumberOfProductsInCart()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(tableViewCellIdentifier, forIndexPath: indexPath) as! PayOrCancelCell
        cell.configure(cartModel.getProductInCart(indexPath.row))
        return cell
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Produkte".localized
    }
    
    func setCartModel(cartModel : CartModel){
        self.cartModel = cartModel
    }
    
    func checkoutStatusChanged(notification:NSNotification) {
        self.dismissViewControllerAnimated(true, completion:nil)
    }
    
    @IBAction func cancelButtonTouched(sender: AnyObject) {
        cancelButton.enabled = false
        CartModel.sharedInstance.cancelCheckoutProcessByUser()
    }
    
}



