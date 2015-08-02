import Foundation
import ObjectMapper

class Location : Mappable{
    
    private(set) var name: String?
    private(set) var code: String?
    
    class func newInstance() -> Mappable {
        return Location()
    }
    
    // Mappable
    func mapping(map: Map) {
        name <- map["name"]
        code <- map["code"]
    }

}
