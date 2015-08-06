import Foundation
import UIKit

class PayOrCancelViewController : UIViewController{
    
     override func viewDidLoad() {
            super.viewDidLoad()
        //NSNotificationCenter.defaultCenter().postNotificationName("CheckoutStatusChangedNotification", object: Cart.CartStatus.CANCELLED.rawValue)
        
    }
    @IBAction func cancelButtonTouched(sender: AnyObject) {
        CartModel.sharedInstance.cancelCheckoutProcessByUser({
            self.dismissViewControllerAnimated(true, completion:nil)
        })
    }
    
    
    @IBAction func dummyPayButtonTouched(sender: AnyObject) {
        CartModel.sharedInstance.simulatePayChecoutProcess({
            self.dismissViewControllerAnimated(true, completion:nil)
        })
    }
}
