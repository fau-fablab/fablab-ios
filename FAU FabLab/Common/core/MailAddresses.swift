import Foundation
import ObjectMapper

class MailAddresses : Mappable{
    
    private(set) var feedbackMail:  String?
    private(set) var fabLabMail:    String?
    
    required init?(_ map: Map){}
    
    // Mappable
    func mapping(map: Map) {
        feedbackMail    <- map["feedbackMail"]
        fabLabMail      <- map["fabLabMail"]
    }
}