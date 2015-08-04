
import Foundation
import ObjectMapper

class CartEntry : NSObject{
    private(set) var product = Product()
    private(set) var amount  = 0.0
    
    init(product: Product, amount: Double){
        self.product = product
        self.amount = amount
        super.init()
    }
    
    func serialize() -> NSDictionary{
        return ["productId" : product.productId as String!, "amount" : amount]
    }
}