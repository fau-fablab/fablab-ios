
import Foundation
import ObjectMapper
import SwiftyJSON
import CoreData

// INFO TO ALL: Check Cart Status before doing anything. 
//              --> ONLY IF STATUS == Shopping -> ADD/CHANGE.... -> OTHERWISE there is a checkout process running!

class Cart : NSObject{
    
    enum CartStatus : String{
        case SHOPPING = "SHOPPING"
        case PENDING = "PENDING"
        case PAID = "PAID"
        case CANCELLED = "CANCELLED"
        case FAILED = "FAILED"
    }
    
    private let managedObjectContext : NSManagedObjectContext
    private let coreData = CoreDataHelper(sqliteDocumentName: "CoreDataModel.db", schemaName:"")

    private(set) var cartCode: String?
    private(set) var status = CartStatus.SHOPPING
    
    private var entries : [CartEntry] {
        get {
            let request = NSFetchRequest(entityName: CartEntry.EntityName)
            return managedObjectContext.executeFetchRequest(request, error: nil) as! [CartEntry]
        }
    }
    
    func save() {
        var error : NSError?
        if !self.managedObjectContext.save(&error) {
            NSLog("Error saving: %@", error!)
        }
    }
    
    override init(){
        self.managedObjectContext = coreData.createManagedObjectContext()
        CartStatus.SHOPPING
        super.init()
    }
    
    func getPrice() -> Double{
        
        var price:Double = 0.0
        
        for item in entries{
            price += item.product.price * item.amount
        }
        
        return price
    }
    
    func getCount() -> Int{
        return entries.count;
    }
    
    func addEntry(product:Product, amount:Double) {
        let cartEntry = NSEntityDescription.insertNewObjectForEntityForName(CartEntry.EntityName,
            inManagedObjectContext: self.managedObjectContext) as! CartEntry
        
        let cartProduct = NSEntityDescription.insertNewObjectForEntityForName(CartProduct.EntityName,
            inManagedObjectContext: self.managedObjectContext) as! CartProduct
        
        cartProduct.name = product.name!
        cartProduct.price = product.price!
        cartProduct.id = product.productId!

        cartEntry.product = cartProduct
        cartEntry.amount = amount
        
        save()
    }
    
    func getEntry(position:Int) -> CartEntry{
        return entries[position];
    }
    
    func removeEntry(position:Int){
        managedObjectContext.deleteObject(entries[position])
        save()
    }
    
    /*                      Checkout process            */
    func setCode(code :String){
        self.cartCode = code
    }
    
    func setStatus(status: CartStatus){
        self.status = status
    }
    
    func serialize() -> NSDictionary{
        var items = [NSDictionary]()
        for item in entries{
            //items.append(item.serialize())
        }
        
        let cart = [
            "cartCode": cartCode as String!,
            "items": items,
            "status": status.rawValue
        ]
        return cart
    }
    
}