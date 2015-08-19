
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
    
    func saveCoreData() {
        var error : NSError?
        if !self.managedObjectContext.save(&error) {
            Debug.instance.log("Error saving: \(error!)")
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
        
        if(self.status != CartStatus.SHOPPING){
            //TODO notify user?
            return
        }
        
        //if product is already in cart, update amount
        if (!entries.isEmpty) {
            for index in 0...(entries.count - 1) {
                if (entries[index].product.id == product.productId) {
                    updateEntry(index, amount: entries[index].amount + amount)
                    return
                }
            }
        }
        
        let cartEntry = NSEntityDescription.insertNewObjectForEntityForName(CartEntry.EntityName,
            inManagedObjectContext: self.managedObjectContext) as! CartEntry
        
        let cartProduct = NSEntityDescription.insertNewObjectForEntityForName(CartProduct.EntityName,
            inManagedObjectContext: self.managedObjectContext) as! CartProduct
        
        cartProduct.name = product.name!
        cartProduct.price = product.price!
        cartProduct.id = product.productId!
        cartProduct.unit = product.unit!

        cartEntry.product = cartProduct
        cartEntry.amount = amount
        
        saveCoreData()
    }
    
    func updateEntry(position: Int, amount: Double) {
        entries[position].amount = amount
        saveCoreData()
    }
    
    func getEntry(position:Int) -> CartEntry{
        return entries[position];
    }
    
    func removeEntry(position:Int){
        
        if(self.status != CartStatus.SHOPPING){
            //TODO notify user?
            return
        }
        
        managedObjectContext.deleteObject(entries[position])
        saveCoreData()
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
            items.append(item.serialize())
        }
        
        let cart = [
            "cartCode": cartCode as String!,
            "items": items,
            "status": status.rawValue
        ]
        Debug.instance.log("Serialized cart is \n \(cart)")
        return cart
    }
    
}