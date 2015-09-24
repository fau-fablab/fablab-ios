import Foundation
import ObjectMapper

class UpdateStatus : Mappable{
    
    enum UpdateAvailability: String {
        case NotAvailable   = "NotAvailable"
        case Optional       = "Optional"
        case Required       = "Required"
    }
    
    private(set) var latestVersion:     String?
    private(set) var latestVersionCode: Int?
    private(set) var oldVersionCode:    Int?
    private(set) var updateAvailable:   UpdateAvailability?
    private(set) var updateMessage:     String?

    
    required init?(_ map: Map){}
    
    // Mappable
    func mapping(map: Map) {
        latestVersion       <- map["latestVersion"]
        latestVersionCode   <- map["latestVersionCode"]
        oldVersionCode      <- map["oldVersionCode"]
        updateAvailable     <- map["updateAvailable"]
        updateMessage       <- map["updateMessage"]
    }
}