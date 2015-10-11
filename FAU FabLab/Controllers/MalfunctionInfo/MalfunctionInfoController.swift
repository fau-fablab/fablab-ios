import UIKit
import MessageUI
import CoreActionSheetPicker

class MalfunctionInfoController: UIViewController, MFMailComposeViewControllerDelegate {
    
    private let model = MalfunctionInfoModel.sharedInstance
    private let cartButtonController = CartNavigationButtonController.sharedInstance
    private let pickerIsVisible = false
    private var mailViewWasVisible = false
    
    var selectedMachine: String = ""{
        didSet{
            model.fetchFablabMailAddress({
                self.showMailView();
            })
        }
    }
    
    var alertViewAction: UIAlertAction {
        return UIAlertAction(title: "OK".localized, style: UIAlertActionStyle.Default, handler: { action in self.navigateBack() })
    }
    
    var emailBody: String{
        return "<b>Tool:</b> </br> \(selectedMachine) </br></br> <b>Error Message:</b> </br>  </br></br>" + "Gesendet mit der FAU FabLab-App für iOS".localized
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cartButtonController.setViewController(self)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if(!mailViewWasVisible){
            model.fetchAllTools { () -> Void in
                self.showPicker()
            }
        }
        mailViewWasVisible = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showMailView(){
        let picker = MFMailComposeViewController()
        picker.mailComposeDelegate = self
        picker.navigationBar.tintColor = UIColor.fabLabGreen()
        picker.setToRecipients([model.fablabMail!])
        picker.setSubject("Störungsmeldung".localized)
        picker.setMessageBody(emailBody, isHTML: true)
        mailViewWasVisible = true
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        dismissViewControllerAnimated(true, completion: nil)
        
        var alert: UIAlertController?

        switch result.rawValue{
            case MFMailComposeResultCancelled.rawValue:
                Debug.instance.log("Cancelled")
                alert = UIAlertController(title: "Abgebrochen".localized, message: "Störungsmeldung wurde nicht versendet!".localized, preferredStyle: UIAlertControllerStyle.Alert)

            case MFMailComposeResultSent.rawValue:
                Debug.instance.log("Sent!")
                _ = UIAlertController(title: "Versendet".localized, message: "Störungsmeldung wurde erfolgreich versendet!".localized, preferredStyle: UIAlertControllerStyle.Alert)

            default:
                Debug.instance.log("Default")
        }
        if let alert = alert {
            alert.addAction(alertViewAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    private func navigateBack(){
        navigationController?.popViewControllerAnimated(true)
    }
    
    private func showPicker(){
        let picker: ActionSheetStringPicker = ActionSheetStringPicker(title: "Betroffenes Gerät".localized, rows: self.model.getAllNames(), initialSelection: 0,
            doneBlock: {
                picker, value, index in
                    self.selectedMachine = "\(index)"
                    return
            },
            cancelBlock: {
                ActionStringCancelBlock in
                self.navigateBack()
            },
            origin: nil)
        
        let doneButton: UIBarButtonItem = UIBarButtonItem()
        doneButton.title = "Auswählen".localized
        doneButton.tintColor = UIColor.fabLabGreen()
        let cancelButton: UIBarButtonItem = UIBarButtonItem()
        cancelButton.title = "Abbrechen".localized
        cancelButton.tintColor = UIColor.fabLabGreen()
            
        picker.setDoneButton(doneButton)
        picker.setCancelButton(cancelButton)
        picker.tapDismissAction = TapAction.Cancel
        picker.showActionSheetPicker()
    }
}