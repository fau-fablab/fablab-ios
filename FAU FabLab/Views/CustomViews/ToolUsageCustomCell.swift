import Foundation
import UIKit


class ToolUsageCustomCell: UITableViewCell {
    
    @IBOutlet var user: UILabel!
    @IBOutlet var project: UILabel!
    @IBOutlet var duration: UILabel!
    @IBOutlet var time: UILabel!
    
    func configure(toolUsage: ToolUsage, startingTime: Int64) {
        selectionStyle = UITableViewCellSelectionStyle.None
        
        user.text = toolUsage.user
        project.text = toolUsage.project
        duration.text = "\(toolUsage.duration!) " + "Minuten".localized
        
        let timeInterval: NSTimeInterval = Double(startingTime)
        let date = NSDate(timeIntervalSince1970: timeInterval)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        time.text = "ab".localized + " \(dateFormatter.stringFromDate(date)) " + "Uhr".localized

    }
    
}