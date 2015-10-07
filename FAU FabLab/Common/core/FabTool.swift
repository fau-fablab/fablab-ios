import Foundation
import ObjectMapper

class FabTool : Mappable{

    private(set) var id:                        Int64?
    private(set) var title:                     String?
    private(set) var link:                      String?
    private(set) var description:               String?
    private(set) var details:                   String?
    private(set) var linkToPicture:             String?
    private(set) var enabledForMachineUsage:    Bool?

    required init?(_ map: Map){}
    
    func mapping(map: Map) {
        id                      <- (map["id"], Int64Transform())
        title                   <-  map["title"]
        link                    <-  map["link"]
        description             <-  map["description"]
        details                 <-  map["details"]
        linkToPicture           <-  map["linkToPicture"]
        enabledForMachineUsage  <-  map["enabledForMachineUsage"]
    }
}
