import UIKit
import CoreActionSheetPicker

class MalfunctionInfoController: UIViewController {
    
    @IBOutlet var buttonSelectMachine: UIButton!
    @IBOutlet var affectedMachineLabel: UILabel!
    
    private let model = MalfunctionInfoModel()
    
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
    
    
    @IBAction func buttonSelectMachineClicked(sender: AnyObject) {
        model.fetchAllTools { () -> Void in
            ActionSheetStringPicker.showPickerWithTitle("Betroffenes Gerät", rows: model.getAllNames(), initialSelection: 0,
                doneBlock: {
                    picker, value, index in
                        self.affectedMachineLabel!.text = "\(index)"
                        return
                }
                , cancelBlock: { ActionStringCancelBlock in return }, origin: sender)
        }
    }
}