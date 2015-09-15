struct ICalApi{
    private let resource = "/ical"
    
    func findAll(onCompletion: ([ICal]?, NSError?) -> Void){
        let endpoint = resource + "/all"
        
        RestManager.sharedInstance.makeJSONRequest(.GET, encoding: .URL, resource: endpoint, params: nil,
            onCompletion: { json, err in
                ApiResult.getArray(json, error: err, completionHandler: onCompletion)
        })
    }
    
    func find(offset: Int, limit: Int, onCompletion: ([ICal]?, NSError?) -> Void){
        let endpoint = resource
        
        let params : [String : AnyObject] =
        [
            "offset"    :   offset,
            "limit"     :   limit
        ]
        
        RestManager.sharedInstance.makeJSONRequest(.GET, encoding: .URL, resource: endpoint, params: params,
            onCompletion: { json, err in
                ApiResult.getArray(json, error: err, completionHandler: onCompletion)
        })
    }
    
    func find(id: Int64, onCompletion: (ICal?, NSError?) -> Void){
        let endpoint = resource + "/\(id)"
        
        RestManager.sharedInstance.makeJSONRequest(.GET, encoding: .URL, resource: endpoint, params: nil,
            onCompletion: { json, err in
                ApiResult.get(json, error: err, completionHandler: onCompletion)
        })
    }
    
    func lastUpdate(onCompletion: (Int64?, NSError?) -> Void){
        let endpoint = resource + "/timestamp"
        
        RestManager.sharedInstance.makeJSONRequest(.GET, encoding: .URL, resource: endpoint, params: nil,
            onCompletion: { json, err in
                if(err != nil){
                    onCompletion(nil, err)
                }
                else{
                    var num = json as? NSNumber
                    var result = num?.longLongValue
                    onCompletion(result, nil)
                }
        })
    }
}
