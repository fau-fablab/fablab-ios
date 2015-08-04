import Foundation
import UIKit

class EventsDetailsViewController : UIViewController {
    
    @IBOutlet var titleText: UILabel!
    @IBOutlet var startText: UILabel!
    @IBOutlet var endText: UILabel!
    @IBOutlet var locationText: UILabel!
    @IBOutlet var descText: UITextView!
    
    var eventTitle: String?
    var eventStart: String?
    var eventEnd: String?
    var eventLocation: String?
    var eventDesc: String?
    
    func configure(#title: String, start: String, end: String, location: String?, description: String?){
        eventTitle = title
        eventStart = start
        eventEnd = end
        eventLocation = location
        eventDesc = description
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleText.text = eventTitle
        startText.text = eventStart
        endText.text = eventEnd
        
        if (locationText != nil) {
            locationText.text = eventLocation
        } else {
            locationText.text = "n/a"
        }
        
        if (descText != nil) {
            descText.text = eventDesc
        } else {
            descText.text = ""
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
