import ObjectMapper
struct ApiResult{
    
    static func get<T: Mappable>(data: AnyObject?, error: NSError?, completionHandler: (T?, NSError?) -> Void){
        if(error != nil){
            completionHandler(nil, error)
        }
        else{
            let result = Mapper<T>().map(data)
            completionHandler(result, nil)
        }
    }
    
    static func getArray<T: Mappable>(data: AnyObject?, error: NSError?, completionHandler: ([T]?, NSError?) -> Void){
        if(error != nil){
            completionHandler(nil, error)
        }
        else{
            let result = Mapper<T>().mapArray(data)
            completionHandler(result, nil)
        }
    }
    
    static func getSimpleType<T>(data: AnyObject?, error: NSError?, completionHandler: (T?, NSError?) -> Void){
        if(error != nil){
            completionHandler(nil, error)
        }
        else{
            let result = data as? T
            completionHandler(result, nil)
        }
    }
}
