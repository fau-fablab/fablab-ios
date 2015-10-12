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
    
    func addCart() {
        let cart = NSEntityDescription.insertNewObjectForEntityForName(Cart.EntityName,
            inManagedObjectContext: self.managedObjectContext) as! Cart
        cart.status = CartStatus.SHOPPING.rawValue
        cart.date = NSDate()
        saveCoreData()
        Debug.instance.log(carts)
    }
    
    func getCount() -> Int {
        return carts.count
    }

    func getCart(index: Int) -> Cart {
        return carts[index]
    }
    
    func removeCart(index: Int) {
        managedObjectContext.deleteObject(carts[index])
        saveCoreData()
    }
    
    private func getNonEmptyCarts() -> [Cart] {
        var nonEmptyCarts = [Cart]()
        for cart in carts {
            if cart.getCount() > 0 {
                nonEmptyCarts.append(cart)
            }
        }
        return nonEmptyCarts
    }
    
    func getCountOfNonEmptyCarts() -> Int {
        return getNonEmptyCarts().count
    }
    
    func getNonEmptyCart(index: Int) -> Cart {
        return getNonEmptyCarts()[index]
    }
    
    func removeNonEmptyCart(index: Int) {
        managedObjectContext.deleteObject(getNonEmptyCarts()[index])
        saveCoreData()
    }
    
}