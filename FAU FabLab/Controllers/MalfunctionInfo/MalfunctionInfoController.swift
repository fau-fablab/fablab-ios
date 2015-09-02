import UIKit
import MessageUI
import CoreActionSheetPicker

class MalfunctionInfoController: UIViewController, MFMailComposeViewControllerDelegate {
    
    private let model = MalfunctionInfoModel()
    private let cartButtonController = CartNavigationButtonController.sharedInstance
    
    var selectedMachine: String = ""{
        didSet{
            var picker = MFMailComposeViewController()
            picker.mailComposeDelegate = self
            picker.navigationBar.tintColor = UIColor.fabLabGreen()
            picker.setToRecipients([model.fablabMail!])
            picker.setSubject("Störungsmeldung".localized)
            picker.setMessageBody(emailBody, isHTML: true)
            
            presentViewController(picker, animated: true, completion: nil)
        }
    }
    
    var emailBody: String{
        return "<b>Tool:</b> </br> \(selectedMachine) </br></br> <b>Error Message:</b> </br>  </br></br> " + "Gesendet mit der Fablab-iOS App".localized
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        model.fetchAllTools { () -> Void in
            self.showPicker()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cartButtonController.setViewController(self)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        dismissViewControllerAnimated(true, completion: nil)
        switch result.value{
            case MFMailComposeResultCancelled.value:
                Debug.instance.log("Cancelled")
                var alert = UIAlertController(title: "Abgebrochen".localized, message: "Störungsmeldung wurde nicht versendet!".localized, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK".localized, style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)

            case MFMailComposeResultSent.value:
                Debug.instance.log("Sent!")
                var alert = UIAlertController(title: "Versendet".localized, message: "Störungsmeldung wurde erfolgreich versendet!".localized, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK".localized, style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)

            default:
                //TODO
                Debug.instance.log("Default")
        }
    }
    
    private func showPicker(){
        var picker: ActionSheetStringPicker = ActionSheetStringPicker(title: "Betroffenes Gerät".localized, rows: self.model.getAllNames(), initialSelection: 0, doneBlock: {
            picker, value, index in
            self.selectedMachine = "\(index)"
            return
        }, cancelBlock: { ActionStringCancelBlock in return }, origin: nil)
        
        var doneButton: UIBarButtonItem = UIBarButtonItem()
        doneButton.title = "Auswählen".localized
        doneButton.tintColor = UIColor.fabLabGreen()
        var cancelButton: UIBarButtonItem = UIBarButtonItem()
        cancelButton.title = "Abbrechen".localized
        cancelButton.tintColor = UIColor.fabLabGreen()
            
        picker.setDoneButton(doneButton)
        picker.setCancelButton(cancelButton)
        picker.tapDismissAction = TapAction.Cancel
        picker.showActionSheetPicker()
    }
}