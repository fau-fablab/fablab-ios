import Foundation
import CoreData

class CartEntry : NSManagedObject{
    
    static let EntityName = "CartEntry"

    @NSManaged var product: CartProduct
    @NSManaged var amount: Double
    
    func serialize() -> NSDictionary{
        return ["productId" : product.id as String!, "amount" : amount]
    }
}