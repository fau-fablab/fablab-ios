import UIKit
import Kingfisher

public class NewsCustomCell : UITableViewCell{
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var previewImage: UIImageView!

    public func configure(#title: String, description:String, image: String?) {
        titleLabel.text = title
        descriptionLabel.text = description;

        if let link = image{
            previewImage.kf_setImageWithURL(NSURL(string: link)!, placeholderImage: nil)
        }else{
            previewImage.image = UIImage(named:"news_nopicture.png")
        }
    }
}
