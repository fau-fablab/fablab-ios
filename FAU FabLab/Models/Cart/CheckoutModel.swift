import Foundation
import ObjectMapper
import SwiftyJSON


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
        
        
        
        //["cartCode" : String(stringInterpolationSegment: cart.cartCode)]
        
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