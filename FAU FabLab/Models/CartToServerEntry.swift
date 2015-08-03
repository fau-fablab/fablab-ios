import Foundation
import ObjectMapper

class CartToServerEntry : Mappable{
    
    var productId: String?
    var amount: Double = 0.0
    
    class func newInstance() -> Mappable {
        return CartToServerEntry()
    }
    
    // Mappable
    func mapping(map: Map) {
        productId <- map["product_id"]
        amount <- map["amount"]
    }
    
}