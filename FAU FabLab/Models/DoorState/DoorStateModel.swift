import Foundation

class DoorStateModel : NSObject {

    private var doorState: DoorState?
    private let api = SpaceApi()

    var hasState: Bool{
        return doorState != nil
    }
    
    var isOpen : Bool{
        if let state = doorState{
            return state.open!
        }
        return false;
    }

    var lastChangeAsString : String {
        if let state = doorState{
            let lastChangeAsDate = NSDate(timeIntervalSince1970: doorState!.lastchange!)
            let flags = NSCalendarUnit.CalendarUnitMinute | NSCalendarUnit.CalendarUnitHour
            let components = NSCalendar.currentCalendar().components(flags, fromDate: lastChangeAsDate, toDate: NSDate(), options: nil)
            
            if(components.hour >= 1){
                return "\(components.hour)h"
            }else{
                return "\(components.minute)m"
            }
        }
        return "N/A"
    }

    override init(){
        super.init()
    }

    func getDoorState(onStateChanged: () -> Void) {
        api.getSpace({ newState, err in
            if(self.doorState == nil || self.doorState! != newState!){
                self.doorState = newState
                onStateChanged()
            }
        })
    }
}
