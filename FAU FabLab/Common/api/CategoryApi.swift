struct CategoryApi {
    
    private let api = RestManager.sharedInstance
    private let resource = "/categories"
    
    func findAll(onCompletion: ([Category]?, NSError?) -> Void){
        let endpoint = resource + "/find/all"
        
        api.makeJSONRequest(.GET, encoding: .URL, resource: endpoint, params: nil, headers: nil,
            onCompletion: { json, err in
                ApiResult.getArray(json, error: err, completionHandler: onCompletion)
        })
    }
    
    func getAutocompletions(onCompletion: ([String]?, NSError?) -> Void){
        let endpoint = resource + "/autocompletions"
        
        api.makeJSONRequest(.GET, encoding: .URL, resource: endpoint, params: nil, headers: nil,
            onCompletion: { json, err in
                ApiResult.getSimpleType(json, error: err, completionHandler: onCompletion)
        })
    }
    
}
