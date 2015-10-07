import Foundation

class TextFieldCustomCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet var title: UILabel!
    @IBOutlet var textField: UITextField!
    
    private var textFieldDidChangeAction: (String?) -> Void = {text in}
    private var acceptIntegersOnly: Bool = false
    
    func configure(title: String, placeholder: String, acceptIntegersOnly: Bool,
        textFieldDidChangeAction: (String?) -> Void) {
            selectionStyle = UITableViewCellSelectionStyle.None
        
            self.acceptIntegersOnly = acceptIntegersOnly
            self.textFieldDidChangeAction = textFieldDidChangeAction
            
            self.title.text = title
            
            textField.delegate = self
            textField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
            textField.placeholder = placeholder
            if acceptIntegersOnly {
                    textField.keyboardType = UIKeyboardType.NumbersAndPunctuation
            }
    }
    
    func configure(title: String, text: String) {
        selectionStyle = UITableViewCellSelectionStyle.None
        
        self.title.text = title
        self.textField.text = text
        self.textField.enabled = false
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if !acceptIntegersOnly {
            
            return true
        }
        
        let invalidCharacters = NSCharacterSet(charactersInString: "0123456789").invertedSet
        if let _ = string.rangeOfCharacterFromSet(invalidCharacters, options: [],
            range:Range<String.Index>(start: string.startIndex, end: string.endIndex)) {
                return false
        }
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChange(textField: UITextField) {
        textFieldDidChangeAction(textField.text)
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        textFieldDidChangeAction(nil)
        return true
    }

}