
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
           
           
        }else{
           
        }
    }
}