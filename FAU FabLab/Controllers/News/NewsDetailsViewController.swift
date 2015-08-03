import Foundation
import UIKit

class NewsDetailsViewController : UIViewController{

    @IBOutlet var descriptionText: UITextView!
    @IBOutlet var previewImage: UIImageView!

    var newsTitle: String?;
    var newsDescription: String?;
    var newsImageLink: String?;
    var imageUrl: NSURL?;
    
    func configure(#title: String, desc: String, imageLink: String?){
        newsTitle = title
        newsDescription = desc
        newsImageLink = imageLink;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = newsTitle; // sets the title in the navigation-bar
        descriptionText.text = newsDescription;
        
        if(newsImageLink != nil){
            previewImage.kf_setImageWithURL(NSURL(string: newsImageLink!)!, placeholderImage: nil)
        }
        else{
            previewImage.image = UIImage(named:"news_nopicture.png")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}