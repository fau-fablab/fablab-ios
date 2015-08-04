
import Foundation
import ObjectMapper

class CartEntry : Mappable{
    var productId: String?
    var amount: Double = 0.0
    
    class func newInstance() -> Mappable {
        return CartEntry()
    }
    
    // Mappable
    func mapping(map: Map) {
        productId <- map["product_id"]
        amount <- map["amount"]
    }

}