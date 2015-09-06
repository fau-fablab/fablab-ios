import UIKit

class SwitchCustomCell: UITableViewCell {
    
    @IBOutlet var title: UILabel!
    @IBOutlet var toggleSwitch: UISwitch!
    
    private var switchValueChangedAction: (Bool) -> Void = {switchValue in }
    
    func configure(title: String, switchValueChangedAction: (Bool) -> Void) {
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.title.text = title
        self.switchValueChangedAction = switchValueChangedAction
    }
    
    func configure(titlee: String, switchValue: Bool, switchValueChangedAction: (Bool) -> Void) {
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.title.text = titlee
        self.toggleSwitch.on = switchValue
        self.switchValueChangedAction = switchValueChangedAction
    }

    @IBAction func switchValueChanged(sender: AnyObject) {
        switchValueChangedAction(toggleSwitch.on)
    }
    
}