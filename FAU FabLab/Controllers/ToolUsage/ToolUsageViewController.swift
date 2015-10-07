import Foundation
import CoreActionSheetPicker

class ToolUsageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    private let model = ToolUsageModel.sharedInstance
    private let buttonCustomCellIdentifier = "ButtonCustomCell"
    private let toolUsageCustomCellIdentifier = "ToolUsageCustomCell"
    private let addToolUsageViewControllerIndentifier = "AddToolUsageViewController"
    private var activityIndicator: UIActivityIndicatorView!
    private var toolId: Int64 = 0
    private var toolSelected = false
    
    @IBAction func addToolUsage(sender: AnyObject) {
        if !toolSelected {
            AlertView.showInfoView("Keine Maschine ausgewählt".localized, message: "Es wurde noch keine Maschine ausgewählt".localized)
            return
        }
        
        let addToolUsageViewController = storyboard?.instantiateViewControllerWithIdentifier(addToolUsageViewControllerIndentifier) as! AddToolUsageViewController
        addToolUsageViewController.configure(toolId)
        navigationController?.pushViewController(addToolUsageViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.autoresizingMask = [UIViewAutoresizing.FlexibleLeftMargin, UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleRightMargin, UIViewAutoresizing.FlexibleTopMargin, UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleBottomMargin]
        view.addSubview(activityIndicator)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setTool(self.toolId)
    }

    private func startLoading() {
        tableView.userInteractionEnabled = false
        activityIndicator.startAnimating()
    }
    
    private func stopLoading() {
        tableView.userInteractionEnabled = true
        activityIndicator.stopAnimating()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Maschine".localized
        } else {
            if model.getNumberOfToolUsages() > 0 {
                return "Reservierung".localized
            }
            return ""
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return model.getNumberOfToolUsages()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            var name: String
            if model.getNumberOfTools() > 0 {
                name = model.getToolName(Int(toolId))
            } else {
                name = "Maschine wählen".localized
            }
            let cell = tableView.dequeueReusableCellWithIdentifier(buttonCustomCellIdentifier) as! ButtonCustomCell
            cell.configure(name, buttonClickedAction: toolButtonClicked)
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(toolUsageCustomCellIdentifier) as! ToolUsageCustomCell
            cell.configure(model.getToolUsage(indexPath.row), startingTime: model.getStartingTimeOfToolUsage(indexPath.row))
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            toolButtonClicked()
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.section == 0 {
            return false
        }
        
        let toolUsage = model.getToolUsage(indexPath.row)
        if model.isOwnToolUsage(toolUsage.id!) {
            return true
        }
        
        return false
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            startLoading()
            model.removeToolUsage(model.getToolUsage(indexPath.row), user: nil, token: UIDevice.currentDevice().identifierForVendor!.UUIDString,
                onCompletion: {
                    (error) -> Void in
                    self.stopLoading()
                    if error != nil {
                        Debug.instance.log(error)
                    }
                    self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
                    self.setTool(self.toolId)
                    
            })
        }
    }
    
    func toolButtonClicked() {
        startLoading()
        model.fetchTools({
            (error) -> Void in
            self.stopLoading()
            if error != nil {
                Debug.instance.log(error)
                return
            }
            self.showToolPicker()
        })
    }
    
    private func showToolPicker() {
        let picker = ActionSheetStringPicker(title: "Maschine wählen".localized, rows: model.getToolNames(), initialSelection: 0,
            doneBlock: {
                picker, index, value in
                Debug.instance.log(index)
                self.toolId = Int64(index)
                self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.None)
                self.setTool(self.toolId)
                self.toolSelected = true
                return
            },
            cancelBlock: nil, origin: nil)
        
        let doneButton: UIBarButtonItem = UIBarButtonItem()
        doneButton.title = "Auswählen".localized
        doneButton.tintColor = UIColor.fabLabGreen()
        let cancelButton: UIBarButtonItem = UIBarButtonItem()
        cancelButton.title = "Abbrechen".localized
        cancelButton.tintColor = UIColor.fabLabGreen()
        
        picker.setDoneButton(doneButton)
        picker.setCancelButton(cancelButton)
        picker.tapDismissAction = TapAction.Cancel
        picker.showActionSheetPicker()
    }
    
    private func setTool(toolId: Int64) {
        self.startLoading()
        self.model.fetchToolUsagesForTool(toolId, onCompletion: {
            (error) -> Void in
            self.stopLoading()
            if error != nil {
                Debug.instance.log(error)
                return
            }
            self.tableView.reloadData()
        })
    }
    
}