
import Foundation

class SettingsViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pushDoorSwitch: UISwitch!

    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    
    private var tableViewCellIdentifier = "SettingsDoorOpensPushCell"
    private var settings = Settings()
    private var doorPushCell : SettingsDoorOpensPushCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        CartNavigationButtonController.sharedInstance.setViewController(self)
        activitySpinner.startAnimating()
        // This is kind of a workround
        //-> There is no garantie that push will be sent
        //-> so the only save way is to ask the server about the status...
        
        RestManager.sharedInstance.makeJsonGetRequest("/push/doorOpensNextTime", params: ["token": PushToken.token], onCompletion: {
            json, err in
            if json as! Bool == true{
                print(self.doorPushCell.cellSwitch.on)
                self.doorPushCell.cellSwitch.on = true
            }else{
                self.doorPushCell.cellSwitch.on = false
            }
            
            self.activitySpinner.stopAnimating()
        })
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        doorPushCell = tableView.dequeueReusableCellWithIdentifier(tableViewCellIdentifier, forIndexPath: indexPath) as! SettingsDoorOpensPushCell
        return doorPushCell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Push Einstellungen".localized
    }
    
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return 1
    }
    
    func tableView(tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }

}