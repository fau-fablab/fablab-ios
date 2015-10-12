import Foundation
import CoreData

class CartModel: NSObject {
    
    // MARK: Fields
    private let cartResource = "/carts"
    private let checkoutResource = "/checkout"
    private var isLoading = false;
    private(set) var cartHistory = CartHistoryModel()
    static let sharedInstance = CartModel()
    private var cart: Cart
    
    private let coreData = CoreDataHelper(sqliteDocumentName: "CoreDataModel.db", schemaName: "")
    private let managedObjectContext: NSManagedObjectContext
    
    //for current cart
    override init() {
        cart = cartHistory.getCart(0)
        managedObjectContext = cart.managedObjectContext!
        super.init()
    }
    
    //for prior carts
    init(cart: Cart) {
        self.cart = cart
        managedObjectContext = cart.managedObjectContext!
        super.init()
    }
    
    private func saveCoreData() {
        //update date
        if (getStatus() == CartStatus.SHOPPING) {
            cart.date = NSDate()   
        }
        var error: NSError?
        do {
            try managedObjectContext.save()
        } catch let error1 as NSError {
            error = error1
            Debug.instance.log("Error saving: \(error!)")
        }
    }
    
    // MARK: Cart
    func addProductToCart(product: Product, amount: Double) {
        
        if (cart.cartStatus != CartStatus.SHOPPING) {
            return
        }
        
        if let entry = cart.findEntry(product.productId!) {
            entry.amount += amount
            saveCoreData()
            return
        }
        
        let cartProduct = NSEntityDescription.insertNewObjectForEntityForName(CartProduct.EntityName,
            inManagedObjectContext: self.managedObjectContext) as! CartProduct
        
        let cartEntry = NSEntityDescription.insertNewObjectForEntityForName(CartEntry.EntityName,
            inManagedObjectContext: self.managedObjectContext) as! CartEntry
        
        cartProduct.name = product.name!
        cartProduct.price = product.price!
        cartProduct.id = product.productId!
        cartProduct.unit = product.unit!
        cartProduct.locationStringForMap = product.locationStringForMap!
        cartProduct.rounding = product.uom!.rounding!
        
        cartEntry.product = cartProduct
        cartEntry.amount = amount
        
        cart.addEntry(cartEntry)
        saveCoreData()
        
        CartNavigationButtonController.sharedInstance.updateBadge()

    }
    
    func addEntryToCart(entry: CartEntry) {
        
        if (cart.cartStatus != CartStatus.SHOPPING) {
            return
        }
        
        if let foundEntry = cart.findEntry(entry.product.id) {
            foundEntry.amount += entry.amount
            saveCoreData()
            return
        }
        
        let cartProduct = NSEntityDescription.insertNewObjectForEntityForName(CartProduct.EntityName,
            inManagedObjectContext: self.managedObjectContext) as! CartProduct
        
        let cartEntry = NSEntityDescription.insertNewObjectForEntityForName(CartEntry.EntityName,
            inManagedObjectContext: self.managedObjectContext) as! CartEntry
        
        cartProduct.name = entry.product.name
        cartProduct.price = entry.product.price
        cartProduct.id = entry.product.id
        cartProduct.unit = entry.product.unit
        cartProduct.locationStringForMap = entry.product.locationStringForMap
        cartProduct.rounding = entry.product.rounding
        
        cartEntry.product = cartProduct
        cartEntry.amount = entry.amount
        
        cart.addEntry(cartEntry)
        saveCoreData()
        
        CartNavigationButtonController.sharedInstance.updateBadge()
        
    }
    
    func removeProductFromCart(index: Int){
        
        if (cart.cartStatus != CartStatus.SHOPPING) {
            return
        }
        
        cart.removeEntry(index)
        saveCoreData()
        
        CartNavigationButtonController.sharedInstance.updateBadge()

    }
    
    func removeAllProductsFromCart() {
        
        if (cart.cartStatus != CartStatus.SHOPPING) {
            return
        }
        
        cart.removeEntries()
        saveCoreData()
        
    }
    
    func updateProductInCart(index: Int, amount: Double) {
        
        if (cart.cartStatus != CartStatus.SHOPPING) {
            return
        }
        
        let entry = cart.getEntry(index)
        entry.amount = amount
        saveCoreData()
        
    }
    
    func getNumberOfProductsInCart() -> Int {
        return cart.getCount()
    }
    
    func getProductInCart(index: Int) -> CartEntry {
        return cart.getEntry(index)
    }
    
    func getTotalPrice() -> Double {
        var totalPrice: Double = 0.0
        if cart.getCount() > 0 {
            for index in 0...cart.getCount()-1 {
                totalPrice += cart.getEntry(index).product.price * cart.getEntry(index).amount
            }
        }
        return totalPrice
    }
    
    func setCode(cartCode: String) {
        cart.code = cartCode
        saveCoreData()
    }
    
    func getCode() -> String {
        return cart.code
    }
    
    func setStatus(cartStatus: CartStatus) {
        cart.cartStatus = cartStatus
        saveCoreData()
    }
    
    func getStatus() -> CartStatus {
        return cart.cartStatus
    }
    
    //replace shopping cart by paid cart
    func replace() {
        if (cart.cartStatus != CartStatus.SHOPPING) {
            CartModel.sharedInstance.removeAllProductsFromCart()
            for index in 0...cart.getCount()-1 {
                CartModel.sharedInstance.addEntryToCart(cart.getEntry(index))
            }
            CartNavigationButtonController.sharedInstance.updateBadge()
        }
    }
    
    //add entries of paid cart to shopping cart
    func add() {
        if (cart.cartStatus != CartStatus.SHOPPING) {
            for index in 0...cart.getCount()-1 {
                CartModel.sharedInstance.addEntryToCart(cart.getEntry(index))
            }
            CartNavigationButtonController.sharedInstance.updateBadge()
        }
    }

    // MARK: Checkout Process
    func sendCartToServer(code: String){
        self.setCode(code)
        self.setStatus(CartStatus.PENDING)
        let cartAsDict = cart.serialize()
        if(!isLoading){
            isLoading = true
            RestManager.sharedInstance.makeTextRequest(.POST, encoding: .JSON, resource: cartResource, params: cartAsDict, onCompletion:  {
                json, error in
                if (error == nil) {
                    self.notifyControllerAboutStatusChange()
                    _ = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("checkCheckoutStatus:"), userInfo: nil, repeats: true)
                }else{
                    self.setStatus(CartStatus.SHOPPING)
                    self.notifyControllerAboutStatusChange()
                }
            })
            isLoading = false
        }
    }
    
    func cancelCheckoutProcessByUser(){
        let code = cart.code
        if(!isLoading){
            isLoading = true
            RestManager.sharedInstance.makeTextRequest(.POST, encoding: .JSON, resource: checkoutResource + "/cancelled/\(code)" , params: nil, onCompletion:  {
                json, err in
            })
            isLoading = false
        }
    }
    
    func checkCheckoutStatus(timer: NSTimer!){
        let code = cart.code
        RestManager.sharedInstance.makeJSONRequest(.GET, encoding: .JSON, resource: cartResource + "/status/\(code)", params: nil, onCompletion: {
            json, err in
            
            if let newStatus = CartStatus(rawValue: json as! String) {
                
                if (newStatus == CartStatus.PENDING){
                    return
                }
                
                timer.invalidate()
                self.setStatus(newStatus)

                switch(newStatus){
                    case CartStatus.PAID:
                        self.checkoutSuccessfulyPaid()
                    case CartStatus.CANCELLED:
                        self.checkoutCancelledOrFailed()
                    case CartStatus.FAILED:
                        self.checkoutCancelledOrFailed()
                    default: break
                }
            }
        })
    }
    
    func checkoutSuccessfulyPaid(){
        self.notifyControllerAboutStatusChange()
        cartHistory.addCart()
        cart = cartHistory.getCart(0)
        CartNavigationButtonController.sharedInstance.updateBadge()
    }
    
    func checkoutCancelledOrFailed(){
        self.notifyControllerAboutStatusChange()
        self.setStatus(CartStatus.SHOPPING)
    }
    
    private func notifyControllerAboutStatusChange(){
        NSNotificationCenter.defaultCenter().postNotificationName("CheckoutStatusChangedNotification", object: cart.cartStatus.rawValue)
    }
}