import UIKit

class StoermeldungController: UIViewController {

    private let doorButtonController = DoorNavigationButtonController.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doorButtonController.updateButtons(self)
    }
    
    func showText() {
        doorButtonController.showText(self)
    }
    
    func showButton() {
        doorButtonController.showButton(self)
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