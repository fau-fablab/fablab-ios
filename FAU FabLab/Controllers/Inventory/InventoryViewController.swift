
import Foundation

class InventoryViewController : UIViewController {
    
    override func viewWillAppear(animated: Bool) {
        CartNavigationButtonController.sharedInstance.setViewController(self)
    }

}