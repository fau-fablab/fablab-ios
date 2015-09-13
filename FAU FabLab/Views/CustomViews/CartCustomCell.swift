import Foundation
import UIKit

class CartCustomCell: UITableViewCell {
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var statusImageView: UIImageView!
    
    func configure(date: NSDate, count: Int, status: CartStatus) {
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        dateLabel.text = dateFormatter.stringFromDate(date)

        var entries: String
        if (count == 1) {
            entries = "Eintrag".localized
        } else {
            entries = "Einträge".localized
        }
        countLabel.text = String(count) + entries
        
        if (status == CartStatus.PAID) {
            statusImageView.image = UIImage(named: "icon_done", inBundle: nil, compatibleWithTraitCollection: nil)?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            statusImageView.tintColor = UIColor.fabLabGreen()
        }
        
    }
    
}