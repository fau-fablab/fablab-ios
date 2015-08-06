import Foundation
import ObjectMapper

class DoorState : Mappable{

    private(set) var open: Bool?
    private(set) var lastchange: Double?

    class func newInstance() -> Mappable {
        return DoorState()
    }

    func mapping(map: Map) {
        open <- map["state.open"]
        lastchange <- map["state.lastchange"]
    }
}