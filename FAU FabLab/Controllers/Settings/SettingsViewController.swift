
import Foundation

class SettingsViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pushDoorSwitch: UISwitch!

    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    
    private var tableViewCellIdentifier = "SettingsDoorOpensPushCell"
    private var settings = Settings()
    private var doorPushCell : SettingsDoorOpensPushCell!
    
    private let switchCustomCellIdentifier = "SwitchCustomCell"
    private let buttonCustomCellIdentifier = "ButtonCustomCell"
    
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 1
        } else if (section == 1) {
            return 2
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            doorPushCell = tableView.dequeueReusableCellWithIdentifier(tableViewCellIdentifier, forIndexPath: indexPath) as! SettingsDoorOpensPushCell
            return doorPushCell
        } else if (indexPath.section == 1 && indexPath.row == 0) {
            let cell = tableView.dequeueReusableCellWithIdentifier(switchCustomCellIdentifier, forIndexPath: indexPath) as! SwitchCustomCell
            cell.configure("Suchverlauf speichern".localized, switchValue: true, switchValueChangedAction: historySwitchValueChanged)
            return cell
        } else if (indexPath.section == 1 && indexPath.row == 1) {
            let cell = tableView.dequeueReusableCellWithIdentifier(buttonCustomCellIdentifier, forIndexPath: indexPath) as! ButtonCustomCell
            cell.configure("Suchverlauf löschen".localized, buttonClickedAction: historyButtonClicked)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) {
            return "Push Einstellungen".localized
        } else if (section == 1) {
            return "Suchverlauf".localized
        } else {
            return ""
        }
    }
    
    func historySwitchValueChanged(switchValue: Bool) {
        settings.updateOrCreate(settings.historyKey, value: switchValue)
        if (!switchValue) {
            SearchHelpModel.sharedInstance.removeHistoryEntries()
        }
    }
    
    func historyButtonClicked() {
        SearchHelpModel.sharedInstance.removeHistoryEntries()
    }

}