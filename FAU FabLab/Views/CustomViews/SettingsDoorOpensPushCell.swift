import UIKit

class SettingsDoorOpensPushCell: UITableViewCell, UITextViewDelegate {

    
    @IBOutlet weak var textView: UILabel!
    @IBOutlet weak var cellSwitch: UISwitch!
    
    @IBAction func cellSwitchChanged(sender: AnyObject) {
        if(cellSwitch.on){
            RestManager.sharedInstance.makeJSONRequest(.GET, encoding: .JSON, resource: "/push/doorOpensNextTime", params: PushToken.serialize() as? [String : AnyObject], onCompletion: {
                json, err in
            })
            
        }else{
            RestManager.sharedInstance.makeJSONRequest(.PUT, encoding: .JSON, resource: "/push/doorOpensNextTime", params: PushToken.serialize() as? [String : AnyObject], onCompletion: {
                json, err in
            })
        }
    }
}