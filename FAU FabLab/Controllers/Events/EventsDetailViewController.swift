import Foundation
import UIKit
import EventKit

class EventsDetailsViewController : UIViewController {
    
    @IBOutlet var titleText: UILabel!
    @IBOutlet var startText: UILabel!
    @IBOutlet var endText: UILabel!
    @IBOutlet var locationText: UILabel!
    @IBOutlet var descText: UITextView!
    
    @IBOutlet var endDesc: UILabel!
    
    var event: Event?
    
    func configure(event: Event) {
        self.event = event
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleText.text = event!.summery
        
        var start = ""
        var ende = ""

        if event!.startTimeString == event!.endTimeString && event!.isOneDay {
            if event!.isToday {
                start = "Heute"
            } else {
                start = event!.startOnlyDateString
            }
            
            start += " ab " + event!.startTimeString
            
            endText.hidden = true
            endDesc.hidden = true
        } else {
            if event!.isToday {
                start = "Heute - " + event!.startTimeString
            } else {
                start = event!.startDateString
            }
            
            if event!.isToday {
                ende = "Heute - " + event!.endTimeString
            } else {
                ende = event!.endDateString
            }
        }
        
        start += " Uhr"
        ende += " Uhr"
        
        startText.text = start
        endText.text = ende
        
        if (event!.location != nil) {
            locationText.text = event!.location
        } else {
            locationText.hidden = true
        }
        
        if (event!.description != nil) {
            descText.text = event!.description
        } else {
            descText.text = "n/a"
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
                    
                    event.startDate = self.event!.start
                    event.endDate = self.event!.end
                    event.title = self.event!.summery
                    event.location = self.event!.location
                    event.notes = self.event!.description
                    
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
            
            let text = self.event!.summery
            
            if let url = NSURL(string: self.event!.url!) {
                let objectsToShare = [text!, url]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                
                self.presentViewController(activityVC, animated: true, completion: nil)
            }
        })
        
        let browserAction = UIAlertAction(title: "Im Browser ansehen", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            if let url = NSURL(string: self.event!.url!) {
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
