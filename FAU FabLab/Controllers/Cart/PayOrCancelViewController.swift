import Foundation
import UIKit

class PayOrCancelViewController : UIViewController{
    
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
     override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "checkoutStatusChanged:", name: "CheckoutStatusChangedNotification", object: nil)
    }
    
    func checkoutStatusChanged(notification:NSNotification) {
        self.dismissViewControllerAnimated(true, completion:nil)
    }
    
    @IBAction func cancelButtonTouched(sender: AnyObject) {
        cancelButton.enabled = false
        CartModel.sharedInstance.cancelCheckoutProcessByUser()
    }
    
}
