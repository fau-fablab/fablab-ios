import Foundation
import ObjectMapper
import SwiftyJSON


typealias updateCartCheckoutStatus = (NSError?) -> Void;

class CheckoutModel : NSObject{
    
    private let resource = "/carts"
    private var isLoading = false;
    
    override init(){
        super.init()
    }
    
    func sendCartToServer(cart: Cart, onCompletion: updateCartCheckoutStatus){
        println("CALLED")
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
    
 

}