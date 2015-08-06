import Foundation


typealias updatePayOrCancelView = (Void) -> Void;

class CartModel : NSObject{
    
    private let cartResource = "/carts"
    private let checkoutResource = "/checkout"
    private var isLoading = false;
    private var cart = Cart()
    static let sharedInstance = CartModel()
    
    
    
    
    /*                      Checkout process              */

    
    func sendCartToServer(code: String){
        cart.setCode(code)
        let cartAsDict = cart.serialize()
        if(!isLoading){
            isLoading = true
            RestManager.sharedInstance.makeJsonPostRequest(cartResource, params: cartAsDict, onCompletion:  {
                json, err in
                if (err == nil) {
                    self.cart.setStatus(Cart.CartStatus.PENDING)
                    self.notifyControllerAboutStatusChange()
                }
            })
            isLoading = false
        }
    }
    
    
    func cancelCheckoutProcessByUser(onCompletion: updatePayOrCancelView){
        let code = cart.cartCode as String!
        if(!isLoading){
            isLoading = true
            RestManager.sharedInstance.makeJsonPostRequest(checkoutResource + "/cancelled/\(code)" , params: nil, onCompletion:  {
                json, err in
                if (err == nil) {
                    self.cart.setStatus(Cart.CartStatus.CANCELLED)
                    self.notifyControllerAboutStatusChange()
                    onCompletion()
                }
            })
            isLoading = false
        }
    }
    
    private func checkCheckoutStatus(){
        //TODO Pull status from server
        
        //Got update --> self.notifyControllerAboutStatusChange() 
        
        //Paid: self.cartWasSuccessfulyPaid()
        //Cancelled: self.checkoutCancelledOrFailed()
        
    }
    
    func checkoutSuccessfulyPaid(){
        //TODO
        //Put to archive or just delete all items/ stati?
    }
    
    func checkoutCancelledOrFailed(){
        self.notifyControllerAboutStatusChange()
        cart.setStatus(Cart.CartStatus.SHOPPING)
        
    }
    
    
    
    private func notifyControllerAboutStatusChange(){
        NSNotificationCenter.defaultCenter().postNotificationName("CheckoutStatusChangedNotification", object: self.cart.status.rawValue)
    }
   
    
    /*                      Methods for DEV            */
    
    func createDummyData(){
        
        let p1 = Product()
        p1.setId("123")
        let e1 = CartEntry(product: p1, amount: 1.0)
        
        let p2 = Product()
        p2.setId("123")
        let e2 = CartEntry(product: p2, amount: 5.0)
        
        cart.addEntry(e1)
        cart.addEntry(e2)
    }
    
    func simulatePayChecoutProcess(onCompletion: updatePayOrCancelView){
        let code = cart.cartCode as String!
        if(!isLoading){
            isLoading = true
            RestManager.sharedInstance.makeJsonPostRequest(checkoutResource + "/paid/\(code)" , params: nil, onCompletion:  {
                json, err in
                if (err == nil) {
                    self.cart.setStatus(Cart.CartStatus.PAID)
                    self.notifyControllerAboutStatusChange()
                    onCompletion()
                }
            })
            isLoading = false
        }
    }
}