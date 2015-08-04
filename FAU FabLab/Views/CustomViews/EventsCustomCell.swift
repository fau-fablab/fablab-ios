
import UIKit
import Kingfisher
    
public class EventsCustomCell : UITableViewCell{
    
    @IBOutlet var heuteLabel: UILabel!
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var monthLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    //@IBOutlet var placeLabel: UILabel!
        
    public func configure(#today: Bool, day: String, month: String, title: String, time: String?, place: String?) {
        
        // if today, then show text "Heute"
        if today {
            heuteLabel.text = "Heute";
            dayLabel.text = "";
            monthLabel.text = "";
        } else {
            heuteLabel.text = "";
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