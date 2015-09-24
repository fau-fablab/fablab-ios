import Foundation
import CoreData

class CartHistoryModel: NSObject {
    
    static let sharedInstance = CartHistoryModel()
    
    private let coreData = CoreDataHelper(sqliteDocumentName: "CoreDataModel.db", schemaName: "")
    private let managedObjectContext: NSManagedObjectContext
    
    private var carts: [Cart] {
        get {
            let request = NSFetchRequest(entityName: Cart.EntityName)
            let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
            request.sortDescriptors = [sortDescriptor]
            return (try! managedObjectContext.executeFetchRequest(request)) as! [Cart]
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
        do {
            try managedObjectContext.save()
        } catch let error1 as NSError {
            error = error1
            Debug.instance.log("Error saving: \(error!)")
        }
    }
    
    func getCount() -> Int {
        return carts.count
    }
    
    func countNonEmptyCarts() -> Int {
        var count : Int = 0
        for cart in carts {
            if cart.getCount() > 0 {
                count++
            }
        }
        return count
    }
    
    func getCart(cartPosition: Int) -> Cart {
        return carts[cartPosition]
    }
    
    func addCart() {
        let cart = NSEntityDescription.insertNewObjectForEntityForName(Cart.EntityName,
            inManagedObjectContext: self.managedObjectContext) as! Cart
        cart.status = CartStatus.SHOPPING.rawValue
        cart.date = NSDate()
        saveCoreData()
        Debug.instance.log(carts)
    }
    
    func removeCart(cartPosition: Int) {
        managedObjectContext.deleteObject(carts[cartPosition])
        saveCoreData()
    }
    
}