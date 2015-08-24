
import UIKit
import Kingfisher
    
public class EventsCustomCell : UITableViewCell{
    
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var monthLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    //@IBOutlet var placeLabel: UILabel!
        
    public func configure(#today: Bool, day: String, month: String, title: String, time: String?, place: String?) {
        
        // if today, then show text "Heute"
        if today {
            dayLabel.font = dayLabel.font.fontWithSize(20)
            dayLabel.text = "Heute"
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
        
        /*if place == nil {
            placeLabel.text = "";
        } else {
            placeLabel.text = place;
        }*/
    }
}