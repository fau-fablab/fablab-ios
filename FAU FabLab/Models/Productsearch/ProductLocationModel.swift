import Alamofire

class ProductLocationModel : NSObject{
    
    static let sharedInstance = ProductLocationModel()
    
    override init(){
        super.init()
    }
    
    func loadProductMap(onCompletion: (Bool) -> Void){
        RestManager.sharedInstance.downloadFile("/productMap/productMap.html")
    }
    
    func getLocalFileUrl(locationId: String) -> NSURL?
    {
        let fileManager = NSFileManager.defaultManager()
        let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        
        if let documentDirectory: NSURL = urls.first as? NSURL {
            let productMapUrl = documentDirectory.URLByAppendingPathComponent("productMap.html")
            
            if productMapUrl.checkResourceIsReachableAndReturnError(nil) {
                let urlString = productMapUrl.absoluteString!.stringByAppendingString(
                    "?id=" + locationId.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)
                return NSURL(string: urlString)
            }
        }
        return nil
    }
}
