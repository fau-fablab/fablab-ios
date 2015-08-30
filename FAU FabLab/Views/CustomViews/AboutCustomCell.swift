import UIKit

class AboutCustomCell: UITableViewCell {
    
    @IBOutlet var titleView: UILabel!
    @IBOutlet var textView: UITextView!
    @IBOutlet var expandView: UIImageView!
    
    func configure(title: String) {
        titleView.text = title
        textView.hidden = true
        textView.attributedText = NSAttributedString(string: "")
        expandView.image = UIImage(named: "expand_more", inBundle: nil, compatibleWithTraitCollection: nil)
        expandView.alpha = 0.2
    }
    
    func configureWithText(title: String, text: NSAttributedString) {
        titleView.text = title
        textView.hidden = false
        textView.attributedText = text
        expandView.image = UIImage(named: "expand_less", inBundle: nil, compatibleWithTraitCollection: nil)
        expandView.alpha = 0.2
    }

}