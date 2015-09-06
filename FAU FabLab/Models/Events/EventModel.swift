import Foundation
import ObjectMapper

class EventModel : NSObject{
    
    private let resource = "/ical";
    private var events = [ICal]()
    private var isLoading = false;
    private var loaded = false;
    private var mapper: Mapper<ICal>;
    
    override init() {
        mapper = Mapper<ICal>()
        super.init()
    }
    
    func fetchEvents(#onCompletion: ApiResponse) {
        if (!isLoading && !loaded) {
            isLoading = true;
            
            RestManager.sharedInstance.makeJsonGetRequest(resource, params: nil, onCompletion: {
                json, err in
                if (err != nil) {
                    AlertView.showErrorView("Fehler beim Abrufen der Events".localized)
                    onCompletion(err)
                }
                
                if let eventList = self.mapper.mapArray(json) {
                    let now = NSDate()
                    for tmp in eventList {
                        // if end-date is after now, add it to the list
                        if now.compare(tmp.end!) == NSComparisonResult.OrderedAscending {
                            self.addEvent(tmp)
                        }
                    }
                }
                
                onCompletion(nil);
                self.isLoading = false;
                self.loaded = true;
            })
        } else if (!isLoading && loaded) {
            // check for events to remove
            let now = NSDate()
            for var index = (self.getCount()-1); index >= 0; index-- {
                // if end-date is before now, remove it from the list
                if now.compare(self.getEvent(index).end!) == NSComparisonResult.OrderedDescending {
                    self.removeEvent(index)
                }
            }
        }
    }
    
    func getCount() -> Int{
        return events.count;
    }
    
    func addEvent(entry: ICal) {
        events.append(entry)
    }
    
    func removeEvent(position: Int) {
        events.removeAtIndex(position)
    }
    
    func getEvent(position: Int) -> ICal{
        return events[position];
    }
}
