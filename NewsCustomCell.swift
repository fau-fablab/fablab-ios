import UIKit
import Kingfisher

public class NewsCustomCell : UITableViewCell{
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var previewImage: UIImageView!

    public func configure(text: String, description:String ,image: String?) {
        titleLabel.text = text
        descriptionLabel.text = text;

        if let link = image{
            previewImage.kf_setImageWithURL(NSURL(string: link)!, placeholderImage: nil)
        }


    }
    
}
