
import Foundation

class AboutViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!

    private var tableViewCellIdentifier = "AboutCustomCell"
    private var titleStrings: [String]!
    private var textAttributedStrings: [NSAttributedString]!
    private var expandedTableViewCells = [Int]()
    private var unexpandedRowHeight : CGFloat = 44.0
    
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
                cell!.configureWithText(titleStrings[indexPath.row], text: textAttributedStrings[indexPath.row])
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
    
    private func createTitleStrings() {
        titleStrings = ["license_title".localized, "code_title".localized, "libraries_title".localized]
    }
    
    private func createTextAttributedStrings() {
        var licenseAttributedString = NSMutableAttributedString(string: "license_text".localized)
        var codeAttributedString = NSMutableAttributedString(string: "code_text".localized)
        var librariesAttributedString = NSMutableAttributedString(string: "libraries_text".localized)
        //add hyperlinks
        codeAttributedString.addAttribute(NSLinkAttributeName, value: NSURL(string: "mad_url".localized)!,
            range: getNSRangeOfSubstring(codeAttributedString.string, substring: "MAD-Projekts"))
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