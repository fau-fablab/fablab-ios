import Foundation


typealias updateCartCheckoutStatus = (NSError?) -> Void;

class CartModel : NSObject{
    
    private let cartResource = "/carts"
    private let checkoutResource = "/checkout"
    private var isLoading = false;
    private var cart = Cart()

    
    /*                      Checkout process              */
    func getStatus()-> Cart.CartStatus{
        return cart.status
    }
    
    func isShopping() -> Bool{
        if(cart.status == Cart.CartStatus.SHOPPING){
            return true
        }
        return false
    }
    
    func sendCartToServer(code: String, onCompletion: updateCartCheckoutStatus){
        cart.setCode(code)
        cart.setStatus(Cart.CartStatus.PENDING)
        
        let cartAsDict = cart.serialize()
        if(!isLoading){
            isLoading = true
            RestManager.sharedInstance.makeJsonPostRequest(cartResource, params: cartAsDict, onCompletion:  {
                json, err in
                onCompletion(nil)
            })
            isLoading = false
        }
    }
    
    
    func cancelChecoutProcess(onCompletion: updateCartCheckoutStatus){
        let code = cart.cartCode as String!
        if(!isLoading){
            isLoading = true
            RestManager.sharedInstance.makeJsonGetRequest(checkoutResource + "/cancelled/\(code)" , params: nil, onCompletion:  {
                json, err in
                if (err != nil) {
                    Debug.instance.log(err)
                    onCompletion(err)
                }else{
                    self.cart.setStatus(Cart.CartStatus.CANCELLED)
                }
                
                onCompletion(nil)
            })
            isLoading = false
        }

    }
    
    
    func checkStatus(onCompletion: updateCartCheckoutStatus){
        let code = cart.cartCode as String!
        if(!isLoading){
            isLoading = true
            RestManager.sharedInstance.makeJsonGetRequest(cartResource + "/status/\(code)" , params: nil, onCompletion:  {
                json, err in
                if (err != nil) {
                    Debug.instance.log(err)
                    onCompletion(err)
                }
                //TODO Update Status
                //cart.setStatus() -> Cart.CartStatus.PENDING .... println(json)
                
                
                
                onCompletion(nil)
            })
            isLoading = false
        }
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
    
    func triggerCartWasPaid(){
        let code = cart.cartCode as String!
        RestManager.sharedInstance.makeGetRequest("/checkout/paid/\(code)", params: nil, onCompletion: {
            json, err in
            Debug.instance.log("PAID! \(json)")
        })
    }
    
    func triggerCartWasCancelled(){
        let code = cart.cartCode as String!
        RestManager.sharedInstance.makeGetRequest("/checkout/cancelled/\(code)", params: nil, onCompletion: {
            json, err in
            Debug.instance.log("CANCELLED! \(json)")
        })
    }
}