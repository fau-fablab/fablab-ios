import UIKit

class ButtonCustomCell: UITableViewCell {
    
    @IBOutlet var button: UIButton!
    
    private var buttonClickedAction: (Void) -> Void = {}
    
    func configure(title: String, buttonClickedAction: (Void) -> Void) {
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.button.setTitle(title, forState: .Normal)
        self.buttonClickedAction = buttonClickedAction
    }
    
    @IBAction func buttonClicked(sender: AnyObject) {
        buttonClickedAction()
    }
}