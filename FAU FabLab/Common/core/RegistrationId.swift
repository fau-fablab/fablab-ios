import Foundation
import ObjectMapper

class RegistrationId : Mappable {
    
    private(set) var registrationid: String?
    private(set) var deviceType = "iOS"
    
    class func newInstance() -> Mappable {
        return RegistrationId()
    }
    
    // Mappable
    func mapping(map: Map) {
        registrationid <- map["registrationid"]
        deviceType <- map["deviceType"]
    }
}
