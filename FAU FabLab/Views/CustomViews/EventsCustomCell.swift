
import UIKit
import Kingfisher
    
public class EventsCustomCell : UITableViewCell{
    
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var monthLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
        
    public func configure(today today: Bool, now: Bool, day: String, month: String, title: String, time: String?,dateColor: UIColor) {
        
        dayLabel.textColor = dateColor
        monthLabel.textColor = dateColor
        
        // if today, then show text "Heute"
        if today {
            dayLabel.font = dayLabel.font.fontWithSize(20)
            if now {
                dayLabel.text = "Jetzt".localized
            } else {
                dayLabel.text = "Heute".localized
            }
            monthLabel.text = "";
        } else {
            dayLabel.font = dayLabel.font.fontWithSize(33)
            dayLabel.text = day;
            monthLabel.text = month;
        }

        titleLabel.text = title;
        
        if time == nil {
            timeLabel.text = "";
        } else {
            timeLabel.text = time;
        }
    }
}