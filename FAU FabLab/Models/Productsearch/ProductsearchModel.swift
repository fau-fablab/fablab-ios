import Foundation
import ObjectMapper
import SwiftyJSON

typealias ProductSearchFinished = (NSError?) -> Void;

class ProductsearchModel : NSObject{
    
    private let resource = "/products"
    private var products = [Product]()
    private var mapper = Mapper<Product>();
    private var isLoading = false;

    override init(){
        super.init()
    }
    
    func getCount() -> Int{
        return products.count;
    }
    
    private func addProduct(entry:Product) {
        products.append(entry)
    }
    
    private func clearProducts() {
        products.removeAll(keepCapacity: false)
    }
    
    func getProduct(position:Int) -> Product{
        return products[position];
    }
    
    func searchProductByName(name:String, onCompletion: ProductSearchFinished){
        let endpoint = resource + "/find/name"
        let params = ["search": name]
        
        if(!isLoading){
            self.clearProducts()
            RestManager.sharedInstance.makeJsonGetRequest(endpoint, params: params, onCompletion: {
                json, err in
                if (err != nil) {
                        println("ERROR! ", err);
                        onCompletion(err)
                }
        
                if let productList = self.mapper.mapArray(json) {
                    for tmp in productList {
                        self.addProduct(tmp)
                        println(tmp.name)
                    }
                }
        
                onCompletion(nil);
                self.isLoading = false;
            })

        }
    }
    
    func searchProductById(id:String, onCompletion: ProductSearchFinished){
        let endpoint = resource + "/find/id"
        let params = ["search": id]
        if(!isLoading){
            RestManager.sharedInstance.makeJsonGetRequest(endpoint, params: params, onCompletion: {
                json, err in
                println("GOT: \(json)")
                
                if (err != nil) {
                    println("ERROR! ", err);
                    onCompletion(err)
                }
                if let product = self.mapper.map(json) {
                    println(product)
                }
                
                
        
                onCompletion(nil);
                self.isLoading = false;
            })
            
        }
    }

}
