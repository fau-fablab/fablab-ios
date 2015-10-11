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
    
    var event: ICal?
    
    func configure(event: ICal) {
        self.event = event
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleText.text = event!.summery
        titleText.textColor = event!.getCustomColor
        
        var start = ""
        var ende = ""

        if event!.startTimeString == event!.endTimeString && event!.isOneDay {
            if event!.isToday {
                start = "Heute".localized
            } else {
                start = event!.startOnlyDateString
            }
            
            start += " " + "ab".localized + " " + event!.startTimeString
            
            endText.hidden = true
            endDesc.hidden = true
        } else {
            if event!.isToday {
                start = "Heute".localized + " - " + event!.startTimeString
            } else {
                start = event!.startDateString
            }
            
            if event!.isToday {
                ende = "Heute".localized + " - " + event!.endTimeString
            } else {
                ende = event!.endDateString
            }
        }
        
        start += " " + "Uhr".localized
        ende += " " + "Uhr".localized
        
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
        
        let calendarAction = UIAlertAction(title: "In Kalender eintragen".localized, style: .Default, handler: {
            (alert: UIAlertAction) -> Void in
            
            let eventStore = EKEventStore()
            
            eventStore.requestAccessToEntityType(EKEntityType.Event, completion: {
                (granted, error) in
                if (granted) && (error == nil) {
                    
                    let event = EKEvent(eventStore: eventStore)
                    event.calendar = eventStore.defaultCalendarForNewEvents
                    
                    event.startDate = self.event!.start!
                    event.endDate = self.event!.end!
                    event.title = self.event!.summery!
                    event.location = self.event!.location
                    event.notes = self.event!.description
                    
                    let result: Bool
                    do {
                        try eventStore.saveEvent(event, span: .ThisEvent)
                        result = true
                    } catch _ {
                        result = false
                    }
                    
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
        
        let shareAction = UIAlertAction(title: "Teilen".localized, style: .Default, handler: {
            (alert: UIAlertAction) -> Void in
            
            let text = self.event!.summery
            
            if let url = NSURL(string: self.event!.url!) {
                let objectsToShare = [text!, url]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                
                self.presentViewController(activityVC, animated: true, completion: nil)
            }
        })
        
        let browserAction = UIAlertAction(title: "Im Browser ansehen".localized, style: .Default, handler: {
            (alert: UIAlertAction) -> Void in
            if let url = NSURL(string: self.event!.url!) {
                UIApplication.sharedApplication().openURL(url)
            }
        })
        
        let cancelAction = UIAlertAction(title: "Abbrechen".localized, style: .Cancel, handler: {
            (alert: UIAlertAction) -> Void in
        })
        
        optionMenu.addAction(calendarAction)
        optionMenu.addAction(shareAction)
        optionMenu.addAction(browserAction)
        optionMenu.addAction(cancelAction)
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    func alertOK() {
        let alert = UIAlertController(title: "Termin erfolgreich dem Kalender hinzugefügt".localized, message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK".localized, style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func alertError() {
        let alert = UIAlertController(title: "Fehler".localized, message: "Termin konnte nicht dem Kalender hinzugefügt werden".localized, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK".localized, style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}
