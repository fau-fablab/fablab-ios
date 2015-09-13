import Foundation
import CoreData

class CartHistoryModel: NSObject {
    
    static let sharedInstance = CartHistoryModel()
    
    private let coreData = CoreDataHelper(sqliteDocumentName: "CoreDataModel.db", schemaName: "")
    private let managedObjectContext: NSManagedObjectContext
    
    private var carts: [Cart] {
        get {
            let request = NSFetchRequest(entityName: Cart.EntityName)
            return managedObjectContext.executeFetchRequest(request, error: nil) as! [Cart]
        }
    }
    
    override init() {
        managedObjectContext = coreData.createManagedObjectContext()
        super.init()
        if carts.isEmpty {
            self.addCart()
        }
    }
    
    private func saveCoreData() {
        var error: NSError?
        if !managedObjectContext.save(&error) {
            Debug.instance.log("Error saving: \(error!)")
        }
    }
    
    func getCount() -> Int {
        return carts.count
    }
    
    func getCart(cartPosition: Int) -> Cart {
        return carts[cartPosition]
    }
    
    func addCart() {
        let cart = NSEntityDescription.insertNewObjectForEntityForName(Cart.EntityName,
            inManagedObjectContext: self.managedObjectContext) as! Cart
        cart.status = CartStatus.SHOPPING.rawValue
        saveCoreData()
        Debug.instance.log(carts)
    }
    
    func removeCart(cartPosition: Int) {
        managedObjectContext.deleteObject(carts[cartPosition])
        saveCoreData()
    }
    
}