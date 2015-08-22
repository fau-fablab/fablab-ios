import Foundation
import ObjectMapper

class DoorStateModel : NSObject {

    private let resource = "/spaceapi";
    private let space = "FAU+FabLab";
    private let mapper = Mapper<DoorState>()

    private var doorState: DoorState?

    var isOpen : Bool{
        if let state = doorState{
            return state.open!
        }
        return false;
    }

    var lastChangeAsString : String {
        let lastChangeAsDate = NSDate(timeIntervalSince1970: doorState!.lastchange!)
        let flags = NSCalendarUnit.CalendarUnitMinute | NSCalendarUnit.CalendarUnitHour
        let components = NSCalendar.currentCalendar().components(flags, fromDate: lastChangeAsDate, toDate: NSDate(), options: nil)
        
        if(components.hour >= 1){
            return "\(components.hour) h"
        }else{
            return "\(components.minute) m"
        }
    }

    override init(){
        super.init()
    }

    func getDoorState(onStateChanged: () -> Void) {
        let endpoint = resource + "/spaces/" + space

        RestManager.sharedInstance.makeJsonGetRequest(endpoint, params: nil, onCompletion: {
            json, err in

            if(err == nil){
                let newState = self.mapper.map(json);
                if(self.doorState == nil || self.doorState! != newState!){
                    self.doorState = newState
                    onStateChanged()
                }
            }
            //TODO error handling
        })
    }
}
