import Foundation
import ObjectMapper

class EventModel : NSObject{
    
    private let resource = "/ical";
    private let timestampResource = "/ical/timestamp"
    private var events = [ICal]()
    private var isLoading = false;
    private var loaded = false;
    private var mapper: Mapper<ICal>;
    
    private var clientTimestamp: Int = Int()
    private var serverTimestamp: Int = Int()
    
    override init() {
        mapper = Mapper<ICal>()
        super.init()
    }
    
    func fetchEvents(#onCompletion: ApiResponse) {
        if (!isLoading && !loaded) {
            isLoading = true;
            
            RestManager.sharedInstance.makeJSONRequest(.GET, encoding: .JSON, resource: resource, params: nil, onCompletion: {
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
                
                // set clientTimestamp to the current server-timestamp
                self.getLastUpdateTimestamp(onCompletion: { error in
                    if(error != nil){
                        Debug.instance.log("Error!");
                    }
                    self.clientTimestamp = self.getServerTimestamp()
                })
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
    
    func getLastUpdateTimestamp(#onCompletion: ApiResponse) {
        RestManager.sharedInstance.makeJSONRequest(.GET, encoding: .URL, resource: timestampResource, params: nil, onCompletion: {
            ts, err in
            if (err != nil) {
                AlertView.showErrorView("Fehler beim Abrufen der Events".localized)
                onCompletion(err)
            }
            self.serverTimestamp = Int(ts as! NSNumber)
            onCompletion(nil);
        })
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
    
    func getClientTimestamp() -> Int {
        return self.clientTimestamp
    }
    
    func getServerTimestamp() -> Int {
        return self.serverTimestamp
    }
    
    func setFlagToReloadEvents() {
        self.loaded = false
    }
}
