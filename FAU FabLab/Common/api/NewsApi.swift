struct NewsApi {
    
    let resource = "/news"
    
    func findById(id: Int64, onCompletion: (News?, NSError?) -> Void){
        let endpoint = resource + "/\(id)"
        
        RestManager.sharedInstance.makeJSONRequest(.GET, encoding: .URL, resource: endpoint, params: nil,
            onCompletion: { json, err in
                ApiResult.get(json, error: err, completionHandler: onCompletion)
        })
    }
    
    func find(offset: Int, limit: Int, onCompletion: ([News]?, NSError?) -> Void){
        let params = ["offset": offset, "limit" : limit]
        
        RestManager.sharedInstance.makeJSONRequest(.GET, encoding: .URL, resource: resource, params: params,
            onCompletion: { json, err in
            ApiResult.getArray(json, error: err, completionHandler: onCompletion)
        })
    }
    
    func findAll(onCompletion: ([News]?, NSError?) -> Void){
        let endpoint = resource + "/all"
        
        RestManager.sharedInstance.makeJSONRequest(.GET, encoding: .URL, resource: endpoint, params: nil,
            onCompletion: { json, err in
                ApiResult.getArray(json, error: err, completionHandler: onCompletion)
        })
    }
    
    func findNewsSince(timestamp: Int64, onCompletion: ([News]?, NSError?) -> Void){
        let endpoint = resource + "/all/\(timestamp)"
        
        RestManager.sharedInstance.makeJSONRequest(.GET, encoding: .URL, resource: endpoint, params: nil,
            onCompletion: {   json, err in
                ApiResult.getArray(json, error: err, completionHandler: onCompletion)
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
                    let num = json as? NSNumber
                    let result = num?.longLongValue
                    onCompletion(result, nil)
                }
        })
    }
}
