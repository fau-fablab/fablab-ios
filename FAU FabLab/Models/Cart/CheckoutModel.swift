import Foundation
import ObjectMapper

/*
    ALL CartToServer CLASSES ARE ONLY USED FOR TRANSFERING THE CART TO THE SERVER
    --> SERVER ONLY ACCEPTS PRODUCTS WITH 'ID' AND 'AMOUNT' (==> CartToServerEntry)
*/



typealias updateCartCheckoutStatus = (NSError?) -> Void;

class CheckoutModel : NSObject{
    
    private let resource = "/carts"
    private var cart : Cart?
    private var mapper = Mapper<Cart>();
    private var isSent = false;
    
    override init(){
        super.init()
    }
    
    func startCheckoutProcess(code: String, cart: Cart, onCompletion: updateCartCheckoutStatus){
        self.cart = cart
        cart.setCode(code)
        cart.setStatus(Cart.CartStatus.PENDING)
        
        println("Starting Checkout: \(code) \(cart)")
        
        if(!isSent){
            RestManager.sharedInstance.makeJsonPostRequest(resource, params: nil, onCompletion:  {
                json, err in
                if (err != nil) {
                    println("ERROR! ", err);
                    onCompletion(err)
                }
                
                println(json)
                
                onCompletion(nil);
                self.isSent = false;
            })
        }

        
    }
    
    

}