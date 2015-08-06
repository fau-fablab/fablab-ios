import Foundation
import ObjectMapper

class DoorStateModel : NSObject {

    private let resource = "/spaceapi";
    private let space = "FAU+FabLab";
    private let mapper = Mapper<DoorState>()

    func getDoorState() -> DoorState{
        let endpoint = resource + "/spaces/" + space

        RestManager.sharedInstance.makeJsonGetRequest(endpoint, params: nil, onCompletion: {
            json, err in

            if(err == nil){
                return self.mapper.map(json);
            }

            //TODO error handling
        })
    }
}
