import Foundation

class TextFieldCustomCell: UITableViewCell {
    
    @IBOutlet var title: UILabel!
    @IBOutlet var textField: UITextField!
    
    private var editingDidEndAction: (String) -> Void = {text in}
    
    func configure(title: String, placeholder: String, editingDidEndAction: (String) -> Void) {
        selectionStyle = UITableViewCellSelectionStyle.None
        
        self.title.text = title
        self.textField.placeholder = title
        self.editingDidEndAction = editingDidEndAction
    }
    
    func configure(title: String, text: String) {
        selectionStyle = UITableViewCellSelectionStyle.None
        
        self.title.text = title
        self.textField.text = text
        self.textField.enabled = false
    }

    @IBAction func editingDidEnd(sender: AnyObject) {
        editingDidEndAction(textField.text)
    }

}