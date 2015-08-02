import Foundation
import ObjectMapper

typealias EventLoadFinished = (NSError?) -> Void;

class EventModel : NSObject{
    
    private let resource = "/ical";
    private var events = [Event]()
    private var isLoading = false;
    private var loaded = false;
    private var mapper:Mapper<Event>;
    
    override init() {
        mapper = Mapper<Event>()
        super.init()
    }
    
    func fetchEvents(#onCompletion: EventLoadFinished) {
        if (!isLoading && !loaded) {
            isLoading = true;
            
            RestManager.sharedInstance.makeJsonRequest(resource, params: nil, onCompletion: {
                json, err in
                if (err != nil) {
                    println("ERROR! ", err);
                    onCompletion(err)
                }
                
                if let eventList = self.mapper.mapArray(json) {
                    for tmp in eventList {
                        self.addEvent(tmp)
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
    
    func addEvent(entry:Event) {
        events.append(entry)
    }
    
    func getEvent(position:Int) -> Event{
        return events[position];
    }
}
