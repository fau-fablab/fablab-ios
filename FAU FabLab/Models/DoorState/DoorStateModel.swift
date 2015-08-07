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
    
    var lastChange : Double {
        return doorState!.lastchange!
    }

    override init(){
        super.init()
        getDoorState()
    }

    func getDoorState() {
        let endpoint = resource + "/spaces/" + space

        RestManager.sharedInstance.makeJsonGetRequest(endpoint, params: nil, onCompletion: {
            json, err in

            if(err == nil){
                self.doorState = self.mapper.map(json);
            }

            //TODO error handling
        })
    }
}
