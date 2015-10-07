import Foundation

class AddToolUsageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var tableViewBottomConstraint: NSLayoutConstraint!
    
    private let model = ToolUsageModel.sharedInstance
    
    //maximum duration of a tool usage, in minutes
    private let maxDuration: Int64 = 300
    
    private var activityIndicator: UIActivityIndicatorView!
    private var textFieldCustomCellIdentifier = "TextFieldCustomCell"
    private var toolId: Int64!
    private var user: String!
    private var project: String!
    private var duration: Int64!
    
    func configure(toolId: Int64) {
        self.toolId = toolId
    }
    
    override func viewDidLoad() {
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "save")
        navigationItem.rightBarButtonItem = saveButton
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.autoresizingMask = [UIViewAutoresizing.FlexibleLeftMargin, UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleRightMargin, UIViewAutoresizing.FlexibleTopMargin, UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleBottomMargin]
        view.addSubview(activityIndicator)
        
        super.viewDidLoad()
    
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardDidShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if let tabBarSize = self.tabBarController?.tabBar.frame.size {
                UIView.animateWithDuration(1) { () -> Void in
                    self.tableViewBottomConstraint.constant = keyboardSize.height - tabBarSize.height
                    self.tableView.setNeedsUpdateConstraints()
                    self.tableView.layoutIfNeeded()
                }
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animateWithDuration(1) { () -> Void in
            self.tableViewBottomConstraint.constant = 0
            self.tableView.setNeedsUpdateConstraints()
            self.tableView.layoutIfNeeded()
        }
    }
    
    private func startLoading() {
        tableView.userInteractionEnabled = false
        navigationItem.rightBarButtonItem?.enabled = false
        activityIndicator.startAnimating()
    }
    
    private func stopLoading() {
        tableView.userInteractionEnabled = true
        navigationItem.rightBarButtonItem?.enabled = true
        activityIndicator.stopAnimating()
    }
    
    func save() {
        if toolId == nil || user == nil || user.isEmpty || project == nil || project.isEmpty ||
            duration == nil || duration == 0 {
                AlertView.showInfoView("Angaben unvollständig".localized, message: "Die Angaben zur Benutzung der Maschine sind unvollständig.".localized)
                return
        }
        
        if duration > maxDuration {
            AlertView.showInfoView("Angaben fehlerhaft".localized, message: "Die maximale Benutzungsdauer der Maschine beträgt 300 Minuten.".localized)
            return
        }
        
        startLoading()
        let toolUsage = ToolUsage(toolId: toolId, user: user, project: project, duration: duration)
        model.addToolUsage(toolUsage, user: nil, token: UIDevice.currentDevice().identifierForVendor!.UUIDString) {
            (error) -> Void in
            self.stopLoading()
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
            cell.configure("Maschine".localized, text: (model.getToolWithId(toolId)?.title)!)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier(textFieldCustomCellIdentifier) as! TextFieldCustomCell
            cell.configure("User".localized, placeholder: "User".localized, acceptIntegersOnly: false,
                textFieldDidChangeAction: {
                    (text) -> Void in
                    self.user = text
            })
            return cell
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier(textFieldCustomCellIdentifier) as! TextFieldCustomCell
            cell.configure("Projekt".localized, placeholder: "Projekt".localized, acceptIntegersOnly: false,
                textFieldDidChangeAction: {
                    (text) -> Void in
                    self.project = text
            })
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier(textFieldCustomCellIdentifier) as! TextFieldCustomCell
            cell.configure("Dauer".localized, placeholder: "Dauer in Minuten".localized, acceptIntegersOnly: true,
                textFieldDidChangeAction: {
                    (text) -> Void in
                    if let text = text {
                        self.duration = (text as NSString).longLongValue
                    }
            })
            return cell
        }
    }
    
}