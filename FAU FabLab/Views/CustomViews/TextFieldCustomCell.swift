import Foundation

class TextFieldCustomCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet var title: UILabel!
    @IBOutlet var textField: UITextField!
    
    private var editingDidEndAction: (String) -> Void = {text in}
    private var acceptIntegersOnly: Bool = false
    
    func configure(title: String, placeholder: String, acceptIntegersOnly: Bool,
        editingDidEndAction: (String) -> Void) {
            selectionStyle = UITableViewCellSelectionStyle.None
        
            self.acceptIntegersOnly = acceptIntegersOnly
            self.editingDidEndAction = editingDidEndAction
            
            self.title.text = title
            
            textField.delegate = self
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
        if let range = string.rangeOfCharacterFromSet(invalidCharacters, options: nil,
            range:Range<String.Index>(start: string.startIndex, end: string.endIndex)) {
                return false
        }
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        editingDidEndAction(textField.text)
    }

}