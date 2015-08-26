import Foundation
import ObjectMapper

class MailAddresses : Mappable{
    
    private(set) var feedbackMail: String?
    private(set) var fabLabMail: String?
    
    class func newInstance() -> Mappable {
        return MailAddresses()
    }
    
    // Mappable
    func mapping(map: Map) {
        feedbackMail <- map["feedbackMail"]
        fabLabMail <- map["fabLabMail"]
    }
}