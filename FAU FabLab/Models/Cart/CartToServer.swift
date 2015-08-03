
import Foundation
import ObjectMapper

class CartToServer : Mappable{
    
    enum CartToServerStatus{
        case PENDING, PAID, CANCELLED, FAILED
    }

    private(set) var cartCode: String?
    private(set) var status = CartToServerStatus.PENDING
    private(set) var cartEntries = [CartToServerEntry]()
    private(set) var pushId: String? //Will we support Push?
    
    init(){}
    
    init(code: String, entries: [CartToServerEntry], pushId: String){
        self.cartCode = code
        self.cartEntries = entries
        self.pushId = pushId
    }

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