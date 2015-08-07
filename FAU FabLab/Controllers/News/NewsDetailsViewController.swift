import Foundation
import UIKit

class NewsDetailsViewController : UIViewController{

    @IBOutlet var descriptionText: UITextView!
    @IBOutlet var previewImage: UIImageView!

    var newsTitle: String?;
    var newsAttrDescription: NSAttributedString?;
    var newsImageLink: String?;
    var imageUrl: NSURL?;
    
    func configure(#title: String, desc: String, imageLink: String?){
        newsTitle = title
        newsImageLink = imageLink;
        
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

}