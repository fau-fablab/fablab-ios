import Foundation

class AddToolUsageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    private let toolModel = ToolModel.sharedInstance
    private let toolUsageModel = ToolUsageModel.sharedInstance
    
    private var textFieldCustomCellIdentifier = "TextFieldCustomCell"
    private var toolId: Int64!
    private var user: String!
    private var project: String!
    private var duration: Int64!
    
    
    func configure(toolId: Int64) {
        self.toolId = toolId
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "save")
        navigationItem.rightBarButtonItem = saveButton
    }
    
    func save() {
        if toolId == nil || user == nil || user.isEmpty || project == nil || project.isEmpty ||
            duration == nil || duration == 0 {
                AlertView.showErrorView("Angaben unvollständig".localized)
                return
        }
        
        let toolUsage = ToolUsage(toolId: toolId, user: user, project: project, duration: duration)
        toolUsageModel.addToolUsage(toolUsage, user: nil, token: UIDevice.currentDevice().identifierForVendor.UUIDString) {
            (error) -> Void in
            if error != nil {
                Debug.instance.log(error)
            }
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier(textFieldCustomCellIdentifier) as! TextFieldCustomCell
            cell.configure("Maschine".localized, text: toolModel.getToolName(Int(toolId)))
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier(textFieldCustomCellIdentifier) as! TextFieldCustomCell
            cell.configure("User".localized, placeholder: "User".localized, acceptIntegersOnly: false,
                editingDidEndAction: {
                    (text) -> Void in
                    self.user = text
            })
            return cell
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier(textFieldCustomCellIdentifier) as! TextFieldCustomCell
            cell.configure("Projekt".localized, placeholder: "Projekt".localized, acceptIntegersOnly: false,
                editingDidEndAction: {
                    (text) -> Void in
                    self.project = text
            })
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier(textFieldCustomCellIdentifier) as! TextFieldCustomCell
            cell.configure("Dauer".localized, placeholder: "Dauer in Minuten".localized, acceptIntegersOnly: true,
                editingDidEndAction: {
                    (text) -> Void in
                    if let text = text {
                        self.duration = (text as NSString).longLongValue
                    }
            })
            return cell
        }
    }
    
}