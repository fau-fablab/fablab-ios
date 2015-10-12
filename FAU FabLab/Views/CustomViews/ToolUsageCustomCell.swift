import Foundation
import UIKit


class ToolUsageCustomCell: UITableViewCell {
    
    @IBOutlet var user: UILabel!
    @IBOutlet var project: UILabel!
    @IBOutlet var duration: UILabel!
    @IBOutlet var time: UILabel!
    
    func configure(toolUsage: ToolUsage, isOwnToolUsage: Bool) {
        selectionStyle = UITableViewCellSelectionStyle.None
        
        user.text = toolUsage.user
        project.text = toolUsage.project
        duration.text = "\(toolUsage.duration!) " + "Minuten".localized
        
        let timeInterval: NSTimeInterval = Double(toolUsage.startTime!/1000)
        let date = NSDate(timeIntervalSince1970: timeInterval)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        if isOwnToolUsage {
            backgroundColor = UIColor.lightTextColor()
        }
        
        time.text = "ab".localized + " \(dateFormatter.stringFromDate(date)) " + "Uhr".localized

    }
    
}