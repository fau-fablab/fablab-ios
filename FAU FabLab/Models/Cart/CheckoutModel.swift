import Foundation
import ObjectMapper
/*
    ALL CartToServer CLASSES ARE ONLY USED FOR TRANSFERING THE CART TO THE SERVER
    --> SERVER ONLY ACCEPTS PRODUCTS WITH 'ID' AND 'AMOUNT' (==> CartToServerEntry)
*/



typealias updateCartCheckoutStatus = (NSError?) -> Void;

class CheckoutModel : NSObject{
    
    private let resource = "/carts"
    private var mapper = Mapper<Cart>();
    private var isSent = false;
    
    override init(){
        super.init()
    }
    
    func startCheckoutProcess(cart: Cart, onCompletion: updateCartCheckoutStatus){
        cart.setStatus(Cart.CartStatus.PENDING)
        
        let JSONString = mapper.toJSON(cart)
        
        //println("Starting Checkout: \(cart.cartCode) OBJ: \(JSONString)")
        
        let params = ["code" : "asdf"]
        
        if(!isSent){
            RestManager.sharedInstance.makeJsonPostRequest(resource, params: params, onCompletion:  {
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