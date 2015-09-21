import Foundation

class AddToolUsageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    private let toolModel = ToolModel.sharedInstance
    private let toolUsageModel = ToolUsageModel.sharedInstance
    
    private var textFieldCustomCellIdentifier = "TextFieldCustomCell"
    private var toolId: Int64!
    private var user: String!
    private var project: String!
    private var duration: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func configure(toolId: Int64) {
        self.toolId = toolId
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
            cell.configure("User".localized, placeholder: "User".localized, editingDidEndAction: {
                (text) -> Void in
                Debug.instance.log(text)
                self.user = text
            })
            return cell
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier(textFieldCustomCellIdentifier) as! TextFieldCustomCell
            cell.configure("Projekt".localized, placeholder: "Projekt".localized, editingDidEndAction: {
                (text) -> Void in
                Debug.instance.log(text)
                self.project = text
            })
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier(textFieldCustomCellIdentifier) as! TextFieldCustomCell
            cell.configure("Dauer".localized, placeholder: "Dauer in Minuten".localized, editingDidEndAction: {
                (text) -> Void in
                Debug.instance.log(text)
                self.duration = text
            })
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
    }
    
}