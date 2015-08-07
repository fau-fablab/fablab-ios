import Foundation
import UIKit
import EventKit

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
    var eventLink: String?
    var eventDateStart: NSDate?
    var eventDateEnd: NSDate?
    
    func configure(#title: String, start: String, end: String, location: String?, description: String?, link: String, startDate: NSDate, endDate: NSDate){
        eventTitle = title
        eventStart = start
        eventEnd = end
        eventLocation = location
        eventDesc = description
        eventLink = link
        eventDateStart = startDate
        eventDateEnd = endDate
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
    
    @IBAction func showActionSheet(sender: AnyObject) {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let calendarAction = UIAlertAction(title: "In Kalender eintragen", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            let eventStore = EKEventStore()
            
            eventStore.requestAccessToEntityType(EKEntityTypeEvent, completion: {
                (granted, error) in
                if (granted) && (error == nil) {
                    
                    var event = EKEvent(eventStore: eventStore)
                    event.calendar = eventStore.defaultCalendarForNewEvents
                    
                    event.startDate = self.eventDateStart
                    event.endDate = self.eventDateEnd
                    event.title = self.eventTitle
                    event.notes = self.eventDesc
                    
                    let result = eventStore.saveEvent(event, span: EKSpanThisEvent, error: nil)
                    
                    if result == true {
                        self.alertOK()
                    } else {
                        self.alertError()
                    }
                
                } else {
                    self.alertError()
                }
            })
        })
        
        let shareAction = UIAlertAction(title: "Teilen", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            let text = self.eventTitle
            
            if let url = NSURL(string: self.eventLink!) {
                let objectsToShare = [text!, url]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                
                self.presentViewController(activityVC, animated: true, completion: nil)
            }
        })
        
        let browserAction = UIAlertAction(title: "Im Browser ansehen", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            if let url = NSURL(string: self.eventLink!) {
                UIApplication.sharedApplication().openURL(url)
            }
        })
        
        let cancelAction = UIAlertAction(title: "Abbrechen", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        optionMenu.addAction(calendarAction)
        optionMenu.addAction(shareAction)
        optionMenu.addAction(browserAction)
        optionMenu.addAction(cancelAction)
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    func alertOK() {
        var alert = UIAlertController(title: "Termin erfolgreich dem Kalender hinzugefügt", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func alertError() {
        var alert = UIAlertController(title: "Fehler", message: "Termin konnte nicht dem Kalender hinzugefügt werden", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}
