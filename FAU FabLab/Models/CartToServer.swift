
import Foundation
import ObjectMapper

class CartToServer : Mappable{

    var cartCode: String?
    var status: String?
    var cartEntries = [CartToServerEntry]()
    var pushId: String? //Will we support Push?

    

    class func newInstance() -> Mappable {
        return CartToServer()
    }
    
    
    func mapping(map: Map) {
        status <- map["status"]
        cartCode <- map["cartCode"]
        cartEntries <- map["cart"]
        pushId <- map["push_id"]
    }

}