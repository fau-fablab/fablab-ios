import Foundation
import ObjectMapper

typealias EventLoadFinished = (NSError?) -> Void;

class EventModel : NSObject{
    
    private let resource = "/ical";
    private var events = [ICal]()
    private var isLoading = false;
    private var loaded = false;
    private var mapper:Mapper<ICal>;
    
    override init() {
        mapper = Mapper<ICal>()
        super.init()
    }
    
    func fetchEvents(#onCompletion: EventLoadFinished) {
        if (!isLoading && !loaded) {
            isLoading = true;
            
            RestManager.sharedInstance.makeJsonGetRequest(resource, params: nil, onCompletion: {
                json, err in
                if (err != nil) {
                    Debug.instance.log(err);
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
        }
    }
    
    func getCount() -> Int{
        return events.count;
    }
    
    func addEvent(entry:ICal) {
        events.append(entry)
    }
    
    func getEvent(position:Int) -> ICal{
        return events[position];
    }
}
