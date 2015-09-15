import Foundation

class EventModel : NSObject{
    
    private let api = ICalApi()
    
    private var events = [ICal]()
    private var isLoading = false;
    
    private var clientTimestamp: Int64 = 0
    private var serverTimestamp: Int64 = -1
    
    private var loaded: Bool{
        return clientTimestamp == serverTimestamp
    };
    
    override init() {
        super.init()
    }
    
    private func updateNeeded(onCompletion: (Bool) -> Void){
        self.api.lastUpdate({ timestamp, error in
            if(error != nil){
                Debug.instance.log("Error!");
                onCompletion(false)
            }
            self.serverTimestamp = timestamp!
            onCompletion(self.loaded)
        })
    }
    
    func fetchEvents(#onCompletion: ApiResponse) {
        if(isLoading){
            return
        }
        //get the latest timestamp from server
        updateNeeded({ result in
            //if we have the latest version look if old ones can be removed and return
            if (self.loaded) {
                Debug.instance.log("Latest version of Events! Check if we could remove some")
                // check for events to remove
                let now = NSDate()
                for var index = (self.getCount()-1); index >= 0; index-- {
                    // if end-date is before now, remove it from the list
                    if now.compare(self.getEvent(index).end!) == NSComparisonResult.OrderedDescending {
                        self.removeEvent(index)
                    }
                }
                return
            }
            //else mark ourself as loading and fetch the latest events
            self.isLoading = true;
            
            self.api.findAll({  events, err in
                if(err != nil){
                    AlertView.showErrorView("Fehler beim Abrufen der Events".localized)
                    onCompletion(err)
                }
                    //if we fetched the news, set our timestamp
                else if let events = events{
                    let now = NSDate()
                    for event in events {
                        // if end-date is after now, add it to the list
                        if now.compare(event.end!) == NSComparisonResult.OrderedAscending {
                            self.addEvent(event)
                        }
                    }
                    onCompletion(nil);
                    self.isLoading = false;
                    self.clientTimestamp = self.serverTimestamp
                }
                self.isLoading = false;
            })
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
}
