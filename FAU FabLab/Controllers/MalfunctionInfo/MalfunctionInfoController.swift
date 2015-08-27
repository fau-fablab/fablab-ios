import UIKit
import MessageUI
import CoreActionSheetPicker

class MalfunctionInfoController: UIViewController, UITextViewDelegate, MFMailComposeViewControllerDelegate {
    
    @IBOutlet var buttonSelectMachine: UIButton!
    @IBOutlet var affectedMachineLabel: UILabel!
    @IBOutlet var textfield: UITextView!
    @IBOutlet var buttonSendMail: UIButton!
    @IBOutlet var textViewBottomConstraint: NSLayoutConstraint!
    private var textViewBottomConstraintValue: CGFloat?
    
    private let model = MalfunctionInfoModel()
    private let placeholderText = "Bitte hier eine kurze Fehlerbeschreibung eintragen".localized
    private let doorButtonController = DoorNavigationButtonController.sharedInstance
    private let cartButtonController = CartNavigationButtonController.sharedInstance
    
    var selectedMachine: String = ""{
        didSet{
            self.affectedMachineLabel!.text = selectedMachine
            if(errorMessage != placeholderText){
                buttonSendMail.enabled = true
            }else{
                buttonSendMail.enabled = false
            }
        }
    }
    
    var errorMessage: String = "Bitte hier eine kurze Fehlerbeschreibung eintragen".localized {
        willSet(newText){
            if(newText != placeholderText && selectedMachine != ""){
                buttonSendMail.enabled = true
            }else{
                buttonSendMail.enabled = false
            }
        }
    }
    
    var emailBody: String{
        return "<b>Tool:</b> </br> \(selectedMachine) </br></br> <b>Error Message:</b> </br> \(errorMessage) </br></br> " + "Gesendet mit der Fablab-iOS App".localized
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        textViewBottomConstraintValue = self.textViewBottomConstraint.constant
        textfield.delegate = self
        textfield.text = placeholderText
        textfield.textColor = UIColor.lightGrayColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        doorButtonController.setViewController(self)
        cartButtonController.setViewController(self)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "changeTextFieldOnKeyboardChange:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "changeTextFieldOnKeyboardChange:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func changeTextFieldOnKeyboardChange(notification: NSNotification) {
        var info = notification.userInfo!
        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let duration = info[UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        view.setNeedsUpdateConstraints()
        
        UIView.animateWithDuration(duration, animations: { () -> Void in
            if notification.name == UIKeyboardWillShowNotification {
                self.textViewBottomConstraint.constant = keyboardFrame.height + 10
            }
            else {
                self.textViewBottomConstraint.constant = self.textViewBottomConstraintValue!
            }
        })
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textfield.text == placeholderText {
            textfield.textColor = UIColor.blackColor()
            textfield.text = ""
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textfield.text.isEmpty{
            textfield.textColor = UIColor.lightGrayColor()
            textfield.text = placeholderText
        }
        errorMessage = textfield.text
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
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
                errorMessage = placeholderText
                textfield.text = placeholderText
                selectedMachine = " "
                self.affectedMachineLabel!.text = selectedMachine
                var alert = UIAlertController(title: "Versendet".localized, message: "Störungsmeldung wurde erfolgreich versendet!".localized, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK".localized, style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)

            default:
                //TODO
                Debug.instance.log("Default")
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    @IBAction func buttonSelectMachineClicked(sender: AnyObject) {
        model.fetchAllTools { () -> Void in
            ActionSheetStringPicker.showPickerWithTitle("Betroffenes Gerät".localized, rows: model.getAllNames(), initialSelection: 0,
                doneBlock: {
                    picker, value, index in
                        self.selectedMachine = "\(index)"
                        return
                }
                , cancelBlock: { ActionStringCancelBlock in return }, origin: sender)
        }
    }
    
    @IBAction func buttonSendMailClicked(sender: AnyObject) {
        var picker = MFMailComposeViewController()
        picker.mailComposeDelegate = self
        picker.setToRecipients([model.fablabMail!])
        picker.setSubject("Störungsmeldung".localized)
        picker.setMessageBody(emailBody, isHTML: true)
        
        presentViewController(picker, animated: true, completion: nil)
    }
    
}