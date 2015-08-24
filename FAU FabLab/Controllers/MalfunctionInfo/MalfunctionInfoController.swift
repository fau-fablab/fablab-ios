import UIKit

class MalfunctionInfoController: UIViewController {

    private let doorButtonController = DoorNavigationButtonController.sharedInstance
    private let cartButtonController = CartNavigationButtonController.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        doorButtonController.setViewController(self)
        cartButtonController.setViewController(self)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}