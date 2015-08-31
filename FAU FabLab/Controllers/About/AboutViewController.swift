
import Foundation
import MessageUI

class AboutViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    
    @IBOutlet var tableView: UITableView!

    private var tableViewCellIdentifier = "AboutCustomCell"
    private var titleStrings: [String]!
    private var textAttributedStrings: [NSAttributedString]!
    private var expandedTableViewCells = [Int]()
    private var unexpandedRowHeight : CGFloat = 44.0
    private var model = MalfunctionInfoModel()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTitleStrings()
        createTextAttributedStrings()
        tableView.estimatedRowHeight = unexpandedRowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        tableView.layoutIfNeeded()
    }
    
    override func viewWillAppear(animated: Bool) {
        CartNavigationButtonController.sharedInstance.setViewController(self)
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier(tableViewCellIdentifier, forIndexPath: indexPath) as? AboutCustomCell
            if let index = find(expandedTableViewCells, indexPath.row) {
                var textView = cell!.configureWithText(titleStrings[indexPath.row], text: textAttributedStrings[indexPath.row])
                textView.delegate = self
            } else {
                cell!.configure(titleStrings[indexPath.row])
            }
            return cell!
    }
    
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return titleStrings.count
    }
    
    func tableView(tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath) {
            if let index = find(expandedTableViewCells, indexPath.row) {
                expandedTableViewCells.removeAtIndex(index)
            } else {
                expandedTableViewCells.append(indexPath.row)
            }
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let index = find(expandedTableViewCells, indexPath.row) {
            return UITableViewAutomaticDimension
        } else {
            return unexpandedRowHeight
        }
    }
    
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        if (URL.absoluteString == "mail_action".localized) {
            var mailViewController = MFMailComposeViewController()
            mailViewController.mailComposeDelegate = self
            mailViewController.navigationBar.tintColor = UIColor.fabLabGreen()
            mailViewController.setToRecipients([model.fablabMail!])
            presentViewController(mailViewController, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    private func createTitleStrings() {
        titleStrings = ["license_title".localized, "code_title".localized, "libraries_title".localized]
    }
    
    private func createTextAttributedStrings() {
        var licenseAttributedString = NSMutableAttributedString(string: "license_text".localized)
        var codeAttributedString = NSMutableAttributedString(string: "code_text".localized)
        var librariesAttributedString = NSMutableAttributedString(string: "libraries_text".localized)
        //add hyperlinks
        codeAttributedString.addAttribute(NSLinkAttributeName, value: NSURL(string: "mad_url".localized)!,
            range: getNSRangeOfSubstring(codeAttributedString.string, substring: "MAD-Projektes"))
        codeAttributedString.addAttribute(NSLinkAttributeName, value: NSURL(string: "github_url".localized)!,
            range: getNSRangeOfSubstring(codeAttributedString.string, substring: "GitHub"))
        librariesAttributedString.addAttribute(NSLinkAttributeName, value: NSURL(string: "actionsheetpicker_url".localized)!,
            range: getNSRangeOfSubstring(librariesAttributedString.string, substring: "ActionSheetPicker"))
        librariesAttributedString.addAttribute(NSLinkAttributeName, value: NSURL(string: "alamofire_url".localized)!,
            range: getNSRangeOfSubstring(librariesAttributedString.string, substring: "Alamofire"))
        librariesAttributedString.addAttribute(NSLinkAttributeName, value: NSURL(string: "bbbadgebarbuttonitem_url".localized)!,
            range: getNSRangeOfSubstring(librariesAttributedString.string, substring: "BBBadgeBarButtonItem"))
        librariesAttributedString.addAttribute(NSLinkAttributeName, value: NSURL(string: "kingfisher_url".localized)!,
            range: getNSRangeOfSubstring(librariesAttributedString.string, substring: "Kingfisher"))
        librariesAttributedString.addAttribute(NSLinkAttributeName, value: NSURL(string: "objectmapper_url".localized)!,
            range: getNSRangeOfSubstring(librariesAttributedString.string, substring: "ObjectMapper"))
        librariesAttributedString.addAttribute(NSLinkAttributeName, value: NSURL(string: "rsbarcodes_url".localized)!,
            range: getNSRangeOfSubstring(librariesAttributedString.string, substring: "RSBarcodes"))
        librariesAttributedString.addAttribute(NSLinkAttributeName, value: NSURL(string: "swiftyjson_url".localized)!,
            range: getNSRangeOfSubstring(librariesAttributedString.string, substring: "SwiftyJson"))
        //add mail action
        codeAttributedString.addAttribute(NSLinkAttributeName, value: NSURL(string: "mail_action".localized)!,
            range: getNSRangeOfSubstring(codeAttributedString.string, substring: "E-Mail"))
        textAttributedStrings = [licenseAttributedString, codeAttributedString, librariesAttributedString];
    }
    
    private func getNSRangeOfSubstring(string: String, substring: String) -> NSRange{
        var nsrange = NSRange()
        nsrange.location = NSNotFound
        if let range = string.rangeOfString(substring) {
            nsrange.location = distance(string.startIndex, range.startIndex)
            nsrange.length = count(substring)
        }
        return nsrange
    }

}

extension AboutViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        dismissViewControllerAnimated(true, completion: nil)
        switch result.value{
            
        case MFMailComposeResultCancelled.value:
            var alert = UIAlertController(title: "Abgebrochen".localized, message: "Nachricht wurde abgebrochen".localized, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK".localized, style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        case MFMailComposeResultSent.value:
            var alert = UIAlertController(title: "Versendet".localized, message: "Nachricht wurde versendet".localized, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK".localized, style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        default:
            Debug.instance.log("Default")
        }
    }
    
}