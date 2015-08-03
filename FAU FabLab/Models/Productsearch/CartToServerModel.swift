import Foundation
import ObjectMapper

/*
    ALL CartToServer CLASSES ARE ONLY USED FOR TRANSFERING THE CART TO THE SERVER

    --> SERVER ONLY ACCEPTS PRODUCTS WITH 'ID' AND 'AMOUNT' (==> CartToServerEntry)


*/


class CartToServerModel : NSObject{
    
    private let resource = "/carts"
    private var cart = CartToServer()
    private var mapper = Mapper<CartToServer>();
    private var isLoading = false;
    
    override init(){
        super.init()
    }
    
    //TODO add CarItems
    //==> No CartItems Class implemented yet
    func createCart(code: String){
        cart.status = CartToServerStatus.PENDING
        cart.pushId = "0"
        cart.cartCode = code
        
        var e1 = CartToServerEntry()
        e1.productId = "0009"
        e1.amount = 5.0
        
        var e2 = CartToServerEntry()
        e2.productId = "0440"
        e2.amount = 1.0
        
        cart.cartEntries = [e1,e2]
        
    }
    
    //TODO Closure anpassen
    func sendToServer(onCompletion: ProductSearchFinished){
        let endpoint = resource
        let params = []
        
        //TODO Parse Cart to JSON and send it to server
        
        if(!isLoading){
            isLoading = true;
            RestManager.sharedInstance.makeJsonPostRequest(resource, params: nil, onCompletion:  {
                json, err in
                if (err != nil) {
                    println("ERROR! ", err);
                    onCompletion(err)
                }
                
                println(json)
            
                onCompletion(nil);
                self.isLoading = false;
            })
        }
    }
    
    //TODO Closure anpassen
    func getStatus(onCompletion: ProductSearchFinished){
        let endpoint = resource + "/status/" + cart.cartCode!
        if(!isLoading){
            isLoading = true;
            RestManager.sharedInstance.makeJsonGetRequest(endpoint, params: nil, onCompletion: {
                json, err in
                println("GOT: \(json)")
                
                if (err != nil) {
                    println("ERROR! ", err);
                    onCompletion(err)
                }
                
                //TODO
                //STATUS ENUM ÄNDERN FALLS Änderung vorliegt
                
                
                
                onCompletion(nil);
                self.isLoading = false;
            })
            
        }

    }
}
