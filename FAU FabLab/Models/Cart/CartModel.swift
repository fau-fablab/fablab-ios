import Foundation


typealias updatePayOrCancelView = (Void) -> Void;

class CartModel : NSObject{
    
    private let cartResource = "/carts"
    private let checkoutResource = "/checkout"
    private var isLoading = false;
    private(set) var cart = Cart()
    static let sharedInstance = CartModel()
    
    func addProductToCart(product:Product, amount:Double){
        cart.addEntry(product, amount: amount)
    }
    
    func removeProductFromCart(index: Int){
        cart.removeEntry(index)
    }
    
    func updateProductInCart(index : Int, amount: Double) {
        cart.updateEntry(index, amount: amount)
    }
    
    /*                      Checkout process              */

    func sendCartToServer(code: String){
        cart.setCode(code)
        self.cart.setStatus(Cart.CartStatus.PENDING)
        let cartAsDict = cart.serialize()
        if(!isLoading){
            isLoading = true
            RestManager.sharedInstance.makePostRequest(cartResource, params: cartAsDict, onCompletion:  {
                json, error in
                if (error == nil) {
                    self.notifyControllerAboutStatusChange()
                    var timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("checkCheckoutStatus:"), userInfo: nil, repeats: true)
                }else{
                    self.cart.setStatus(Cart.CartStatus.SHOPPING)
                    self.notifyControllerAboutStatusChange()
                }
            })
            isLoading = false
        }
    }
    
    
    func cancelCheckoutProcessByUser(){
        let code = cart.cartCode as String!
        if(!isLoading){
            isLoading = true
            RestManager.sharedInstance.makePostRequest(checkoutResource + "/cancelled/\(code)" , params: nil, onCompletion:  {
                json, err in
            })
            isLoading = false
        }
    }
    
    func checkCheckoutStatus(timer: NSTimer!){
        let code = cart.cartCode as String!
        RestManager.sharedInstance.makeJsonGetRequest(cartResource + "/status/\(code)", params: nil, onCompletion: {
            json, err in
            
            if let newStatus = Cart.CartStatus(rawValue: json as! String) {
                
                if (newStatus == Cart.CartStatus.PENDING){
                    return
                }
                
                timer.invalidate()
                self.cart.setStatus(newStatus)

                switch(newStatus){
                    case Cart.CartStatus.PAID:
                        self.checkoutSuccessfulyPaid()
                    case Cart.CartStatus.CANCELLED:
                        self.checkoutCancelledOrFailed()
                    case Cart.CartStatus.FAILED:
                        self.checkoutCancelledOrFailed()
                    default: break
                }
            }
        })
    }
    
    func checkoutSuccessfulyPaid(){
        self.notifyControllerAboutStatusChange()
        
        //TODO
        //Put to archive or just delete all items/ stati?
        cart = Cart()
    }
    
    func checkoutCancelledOrFailed(){
        self.notifyControllerAboutStatusChange()
        cart.setStatus(Cart.CartStatus.SHOPPING)
    }
    
    
    
    private func notifyControllerAboutStatusChange(){
        NSNotificationCenter.defaultCenter().postNotificationName("CheckoutStatusChangedNotification", object: self.cart.status.rawValue)
    }
   
    
    /*                      Methods for DEV            */
    
    func simulatePayChecoutProcess(){
        let code = cart.cartCode as String!
        if(!isLoading){
            isLoading = true
            RestManager.sharedInstance.makePostRequest(checkoutResource + "/paid/\(code)" , params: nil, onCompletion:  {
                json, err in
                
            })
            isLoading = false
        }
    }
}