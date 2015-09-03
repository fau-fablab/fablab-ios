
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "FAU FabLab".localized + " " + NSBundle.mainBundle().releaseVersionString!
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
        if (URL.absoluteString == "E-Mail".localized) {
            var mailViewController = MFMailComposeViewController()
            mailViewController.mailComposeDelegate = self
            mailViewController.navigationBar.tintColor = UIColor.fabLabGreen()
            mailViewController.setToRecipients([self.model.fablabMail!])
            presentViewController(mailViewController, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    private func createTitleStrings() {
        titleStrings = ["Lizenz".localized, "Quellcode & Kontakt".localized, "Open Source Bibliotheken".localized]
    }
    
    private func createTextAttributedStrings() {
        var licenseAttributedString = NSMutableAttributedString(string: "The MIT License (MIT)\n\nCopyright (c) 2015 MAD FabLab Team\n\nPermission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\n\nThe above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\n\nTHE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.".localized)
        var codeAttributedString = NSMutableAttributedString(string: "Die App wurde im Rahmen des MAD-Projektes an der FAU Erlangen-Nürnberg entwickelt. Der Quellcode kann unter GitHub gefunden werden. Feedback jederzeit gerne per E-Mail.\n\nDie Entwickler sind:\n\nEmanuel Eimer\nStefan Herpich\nMichael Sander\nJulia Schottenhamml\nJohannes Pfann\nMax Jalowski\nSebastian Haubner\nKatharina Full\nPhilip Kranhäußer\nJulian Lorz\nDaniel Rosenmüller".localized)
        var librariesAttributedString = NSMutableAttributedString(string: "ActionSheetPicker\n(BSD License)\n\nAlamofire\n(MIT License)\n\nBBBadgeBarButtonItem\n(MIT License)\n\nKingfisher\n(MIT License)\n\nObjectMapper\n(MIT License)\n\nRSBarcodes\n(MIT License)\n\nSwiftyJson\n(MIT License)".localized)
        //add hyperlinks
        codeAttributedString.addAttribute(NSLinkAttributeName, value: NSURL(string: "https://www2.informatik.uni-erlangen.de/teaching/SS2015/MAD/index.html".localized)!,
            range: getNSRangeOfSubstring(codeAttributedString.string, substring: "MAD-Projektes"))
        codeAttributedString.addAttribute(NSLinkAttributeName, value: NSURL(string: "https://github.com/FAU-Inf2/fablab-ios".localized)!,
            range: getNSRangeOfSubstring(codeAttributedString.string, substring: "GitHub"))
        librariesAttributedString.addAttribute(NSLinkAttributeName, value: NSURL(string: "https://github.com/skywinder/ActionSheetPicker-3.0".localized)!,
            range: getNSRangeOfSubstring(librariesAttributedString.string, substring: "ActionSheetPicker"))
        librariesAttributedString.addAttribute(NSLinkAttributeName, value: NSURL(string: "https://github.com/Alamofire/Alamofire".localized)!,
            range: getNSRangeOfSubstring(librariesAttributedString.string, substring: "Alamofire"))
        librariesAttributedString.addAttribute(NSLinkAttributeName, value: NSURL(string: "https://github.com/TanguyAladenise/BBBadgeBarButtonItem".localized)!,
            range: getNSRangeOfSubstring(librariesAttributedString.string, substring: "BBBadgeBarButtonItem"))
        librariesAttributedString.addAttribute(NSLinkAttributeName, value: NSURL(string: "https://github.com/onevcat/Kingfisher".localized)!,
            range: getNSRangeOfSubstring(librariesAttributedString.string, substring: "Kingfisher"))
        librariesAttributedString.addAttribute(NSLinkAttributeName, value: NSURL(string: "https://github.com/Hearst-DD/ObjectMapper".localized)!,
            range: getNSRangeOfSubstring(librariesAttributedString.string, substring: "ObjectMapper"))
        librariesAttributedString.addAttribute(NSLinkAttributeName, value: NSURL(string: "https://github.com/yeahdongcn/RSBarcodes".localized)!,
            range: getNSRangeOfSubstring(librariesAttributedString.string, substring: "RSBarcodes"))
        librariesAttributedString.addAttribute(NSLinkAttributeName, value: NSURL(string: "https://github.com/SwiftyJSON/SwiftyJSON".localized)!,
            range: getNSRangeOfSubstring(librariesAttributedString.string, substring: "SwiftyJson"))
        //add mail action
        codeAttributedString.addAttribute(NSLinkAttributeName, value: NSURL(string: "E-Mail".localized)!,
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
            var alert = UIAlertController(title: "Abgebrochen".localized, message: "Nachricht wurde abgebrochen.".localized, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK".localized, style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        case MFMailComposeResultSent.value:
            var alert = UIAlertController(title: "Versendet".localized, message: "Nachricht wurde versendet.".localized, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK".localized, style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        default:
            Debug.instance.log("Default")
        }
    }
    
}