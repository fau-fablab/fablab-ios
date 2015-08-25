import UIKit
import CoreActionSheetPicker

class MalfunctionInfoController: UIViewController, UITextViewDelegate {
    
    @IBOutlet var buttonSelectMachine: UIButton!
    @IBOutlet var affectedMachineLabel: UILabel!
    @IBOutlet var textfield: UITextView!
    @IBOutlet var buttonSendMail: UIButton!
    @IBOutlet var textViewBottomConstraint: NSLayoutConstraint!
    private var textViewBottomConstraintValue: CGFloat?
    
    private let model = MalfunctionInfoModel()
    private let placeholderText = "Bitte hier eine kurze Fehlerbeschreibung eintragen"
    private let doorButtonController = DoorNavigationButtonController.sharedInstance
    private let cartButtonController = CartNavigationButtonController.sharedInstance

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
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
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
    
    @IBAction func buttonSendMailClicked(sender: AnyObject) {
        //TODO
    }
    
}