import Foundation
import CoreData

class CartProduct : NSManagedObject{
    
    static let EntityName = "CartProduct"
    
    @NSManaged var name                 : String
    @NSManaged var id                   : String
    @NSManaged var price                : Double
    @NSManaged var unit                 : String
    @NSManaged var locationStringForMap : String
}