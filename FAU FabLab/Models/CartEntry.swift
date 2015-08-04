
import Foundation
import ObjectMapper

class CartEntry : Mappable{
    private(set) var product = Product()
    private(set) var amount  = 0.0
    
    init(product: Product, amount: Double){
        self.product = product
        self.amount = amount
    }
    
    init(){}
    
    class func newInstance() -> Mappable {
        return CartEntry()
    }
    
    // Mappable
    func mapping(map: Map) {
        product <- (map["productId"], productToId)
        amount <- map["amount"]
    }
    
    let productToId = TransformOf<Product, String>(
        fromJSON: { (value: String?) -> Product? in
            return nil
        }, toJSON: { (product: Product?) -> String? in
            return product!.productId
    })
    
}