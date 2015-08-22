import UIKit

class MalfunctionInfoController: UIViewController {

    private let doorButtonController = DoorNavigationButtonController.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doorButtonController.updateButtons(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}