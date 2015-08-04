import Foundation


typealias updateCartCheckoutStatus = (NSError?) -> Void;

class CartModel : NSObject{
    
    private let resource = "/carts"
    private var isLoading = false;
    private var cart = Cart()
    
    
    
    /*                      Checkout process              */
    
    func sendCartToServer(code: String, onCompletion: updateCartCheckoutStatus){
        cart.setCode(code)
        cart.setStatus(Cart.CartStatus.PENDING)
        
        let cartAsDict = cart.serialize()
        if(!isLoading){
            isLoading = true
            RestManager.sharedInstance.makeJsonPostRequest(resource, params: cartAsDict, onCompletion:  {
                json, err in
                if (err != nil) {
                    println("ERROR! ", err)
                    onCompletion(err)
                }
                println(json)
                
                onCompletion(nil)
            })
            isLoading = false
        }
    }
    
    func checkStatus(onCompletion: updateCartCheckoutStatus){
        let code = cart.cartCode as String!
        if(!isLoading){
            isLoading = true
            RestManager.sharedInstance.makeJsonGetRequest(resource + "/status/\(code)" , params: nil, onCompletion:  {
                json, err in
                if (err != nil) {
                    println("ERROR! ", err)
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
            println("PAID! \(json)")
        })
    }
    
    func triggerCartWasCancelled(){
        let code = cart.cartCode as String!
        RestManager.sharedInstance.makeGetRequest("/checkout/cancelled/\(code)", params: nil, onCompletion: {
            json, err in
            println("CANCELLED! \(json)")
        })
    }
}