
import Foundation

class SettingsViewController : UIViewController{

    @IBOutlet weak var pushDoorSwitch: UISwitch!
    
    
    private var settings = Settings()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // This is kind of a workround
        //-> There is no garantie that push will be sent
        //-> so the only save way is to ask the server about the status...
        
        RestManager.sharedInstance.makeJsonGetRequest("/push/doorOpensNextTime", params: ["token": PushToken.token], onCompletion: {
            json, err in
            println(json)
            println(json as! Bool)
            self.pushDoorSwitch.on = json as! Bool
            println(self.pushDoorSwitch.on)
        })
    }
    
    
    
   
    @IBAction func pushDoorSwitchChanged(sender: AnyObject) {

        if(pushDoorSwitch.on){
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