struct ProductApi{
    
    let api = RestManager.sharedInstance
    let resource = "/products"
    
    func findById(id: String, onCompletion: (Product?, NSError?) -> Void){
        let endpoint = resource + "/find/id"
        let params = ["search": id]
        
        api.makeJSONRequest(.GET, encoding: .URL, resource: endpoint, params: params, headers: nil,
            onCompletion: { json, err in
                ApiResult.get(json, error: err, completionHandler: onCompletion)
        })
    }
    
    func findByName(name: String, limit: Int = 0, offset: Int = 0, onCompletion: ([Product]?, NSError?) -> Void){
        let endpoint = resource + "/find/name"
        let params: [String : AnyObject] =
        [
            "search"    :   name,
            "limit"     :   limit,
            "offset"    :   offset
        ]
        
        api.makeJSONRequest(.GET, encoding: .URL, resource: endpoint, params: params, headers: nil,
            onCompletion: { json, err in
                ApiResult.getArray(json, error: err, completionHandler: onCompletion)
        })
    }
    
    func findByCategory(category: String, limit: Int = 0, offset: Int = 0, onCompletion: ([Product]?, NSError?) -> Void){
        let endpoint = resource + "/find/category"
        let params: [String : AnyObject] =
        [
            "search"    :   category,
            "limit"     :   limit,
            "offset"    :   offset
        ]
        
        api.makeJSONRequest(.GET, encoding: .URL, resource: endpoint, params: params, headers: nil,
            onCompletion: { json, err in
                ApiResult.getArray(json, error: err, completionHandler: onCompletion)
        })
    }
    
    func findAll(limit: Int = 0, offset: Int = 0, onCompletion: ([Product]?, NSError?) -> Void){
        let params: [String : AnyObject] =
        [
            "limit"     :   limit,
            "offset"    :   offset
        ]
        
        api.makeJSONRequest(.GET, encoding: .URL, resource: resource, params: params, headers: nil,
            onCompletion: { json, err in
                ApiResult.getArray(json, error: err, completionHandler: onCompletion)
        })
    }
    
    func findAllWithoutFilters(limit: Int = 0, offset: Int = 0, onCompletion: ([Product]?, NSError?) -> Void){
        let endpoint = resource + "/find/all/withoutfilter"
        
        let params: [String : AnyObject] =
        [
            "limit"     :   limit,
            "offset"    :   offset
        ]
        
        api.makeJSONRequest(.GET, encoding: .URL, resource: endpoint, params: params, headers: nil,
            onCompletion: { json, err in
                ApiResult.getArray(json, error: err, completionHandler: onCompletion)
        })
    }
    
    func findAllNames(onCompletion: ([String]?, NSError?) -> Void){
        let endpoint = resource + "/names"
        
        api.makeJSONRequest(.GET, encoding: .URL, resource: endpoint, params: nil, headers: nil,
            onCompletion: { json, err in
                ApiResult.getSimpleType(json, error: err, completionHandler: onCompletion)
        })
    }
    
    func getAutoCompletions(onCompletion: ([String]?, NSError?) -> Void){
        let endpoint = resource + "/autocompletions"

        api.makeJSONRequest(.GET, encoding: .URL, resource: endpoint, params: nil, headers: nil,
            onCompletion: { json, err in
                ApiResult.getSimpleType(json, error: err, completionHandler: onCompletion)
        })
    }
}
