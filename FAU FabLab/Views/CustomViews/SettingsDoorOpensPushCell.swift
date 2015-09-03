import UIKit

class SettingsDoorOpensPushCell: UITableViewCell, UITextViewDelegate {

    
    @IBOutlet weak var textView: UILabel!
    @IBOutlet weak var cellSwitch: UISwitch!
    
    @IBAction func cellSwitchChanged(sender: AnyObject) {
        if(cellSwitch.on){
            RestManager.sharedInstance.makeJsonPostRequest("/push/doorOpensNextTime", params: PushToken.serialize(), onCompletion: {
                json, err in
            })
            
        }else{
            RestManager.sharedInstance.makeJsonPutRequest("/push/doorOpensNextTime", params: PushToken.serialize(), onCompletion: {
                json, err in
            })
        }
    }
}