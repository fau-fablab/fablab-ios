import Foundation
import UIKit

class NewsDetailsViewController : UIViewController{

    @IBOutlet var descriptionText: UITextView!
    @IBOutlet var previewImage: UIImageView!

    var newsTitle: String?
    var newsAttrDescription: NSAttributedString?
    var newsImageLink: String?
    var imageUrl: NSURL?
    var linkToNews: String?
    
    func configure(#title: String, desc: String, imageLink: String?, link: String){
        newsTitle = title
        newsImageLink = imageLink;
        linkToNews = link
        
        let htmlText = desc.dataUsingEncoding(NSUTF8StringEncoding)!
        let attributedOptions: [String:AnyObject] = [
            NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
            NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding
        ]
        newsAttrDescription = NSAttributedString(data: htmlText, options: attributedOptions, documentAttributes: nil, error: nil)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = newsTitle; // sets the title in the navigation-bar
        descriptionText.attributedText = newsAttrDescription
        descriptionText.font = UIFont(name: "Helvetica Neue", size: 14.0)
        
        if (newsImageLink != nil){
            previewImage.kf_setImageWithURL(NSURL(string: newsImageLink!)!, placeholderImage: nil)
        } else {
            previewImage.image = UIImage(named:"news_nopicture.png")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        Debug.instance.log(segue.identifier)
        if segue.identifier == "NewsImageDetailSegue" {
            let destination = segue.destinationViewController as? ImageDetailViewController
            destination!.configure(title: newsTitle!, image: previewImage.image!)
        }
    }

    @IBAction func showActionSheet(sender: AnyObject) {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let shareAction = UIAlertAction(title: "Teilen".localized, style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            let text = self.title
            
            if let url = NSURL(string: self.linkToNews!) {
                let objectsToShare = [text!, url]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                
                self.presentViewController(activityVC, animated: true, completion: nil)
            }
        })
        
        let browserAction = UIAlertAction(title: "Im Browser ansehen".localized, style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            if let url = NSURL(string: self.linkToNews!) {
                UIApplication.sharedApplication().openURL(url)
            }
        })
        
        let cancelAction = UIAlertAction(title: "Abbrechen".localized, style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        optionMenu.addAction(shareAction)
        optionMenu.addAction(browserAction)
        optionMenu.addAction(cancelAction)

        self.presentViewController(optionMenu, animated: true, completion: nil)
    }

}