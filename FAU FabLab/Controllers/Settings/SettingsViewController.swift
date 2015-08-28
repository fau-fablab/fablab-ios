
import Foundation

class SettingsViewController : UIViewController{

    @IBOutlet weak var pushDoorSwitch: UISwitch!
    
    
    private var settings = Settings()
    private let pushDoorOpensKey = "pushDoorOpens3"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(settings.getValue(pushDoorOpensKey) != nil){
            pushDoorSwitch.on = settings.getValue(pushDoorOpensKey)!
        }else{
            pushDoorSwitch.on = false
        }
        
    }
    
    
    
   
    @IBAction func pushDoorSwitchChanged(sender: AnyObject) {
        settings.updateOrCreate(pushDoorOpensKey, value: pushDoorSwitch.on)
        
        if(pushDoorSwitch.on){
            RestManager.sharedInstance.makeJsonPostRequest("/push/doorOpensNextTime", params: PushToken.serialize(), onCompletion: {
                json, err in
                println("ON")
            })
           
        }else{
            RestManager.sharedInstance.makeJsonPutRequest("/push/doorOpensNextTime", params: PushToken.serialize(), onCompletion: {
                json, err in
                println("OFF")
            })
        }
    }
}