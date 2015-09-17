import Foundation
import ObjectMapper

class Location : Mappable{
    
    private(set) var name:          String?
    private(set) var code:          String?
    private(set) var locationId:    Int64?
    
    class func newInstance() -> Mappable {
        return Location()
    }
    
    // Mappable
    func mapping(map: Map) {
        name        <-  map["name"]
        code        <-  map["code"]
        locationId  <- (map["locationId"], Int64Transform())
    }
}
