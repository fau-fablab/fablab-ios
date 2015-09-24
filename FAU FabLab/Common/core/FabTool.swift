import Foundation
import ObjectMapper

class FabTool : Mappable{

    private(set) var title:         String?
    private(set) var link:          String?
    private(set) var description:   String?
    private(set) var details:       String?
    private(set) var linkToPicture: String?

    required init?(_ map: Map){}
    
    func mapping(map: Map) {
        title           <- map["title"]
        link            <- map["link"]
        description     <- map["description"]
        details         <- map["details"]
        linkToPicture   <- map["linkToPicture"]
    }
}
