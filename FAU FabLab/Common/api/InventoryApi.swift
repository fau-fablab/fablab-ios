import ObjectMapper

struct InventoryApi{
    
    private let api = RestManager.sharedInstance
    private let mapper = Mapper<InventoryItem>()
    private let resource = "/inventory"
    
    func getAll(onCompletion: ([InventoryItem]?, NSError?) -> Void){
        api.makeJSONRequest(.GET, encoding: .URL, resource: resource, params: nil,
            onCompletion: { json, err in
                ApiResult.getArray(json, error: err, completionHandler: onCompletion)
        })
    }
    
    func add(user: User, item: InventoryItem, onCompletion: (InventoryItem?, NSError?) -> Void){
        let params = mapper.toJSON(item)
                
        api.makeJSONRequestWithBasicAuth(.POST, encoding: .JSON, resource: resource, username: user.username!, password: user.password!, params: params,
            onCompletion: { json, err in
                ApiResult.get(json, error: err, completionHandler: onCompletion)
        })
    }
    
    func deleteAll(user: User, onCompletion: (Bool?, NSError?) -> Void){
        api.makeJSONRequestWithBasicAuth(.DELETE, encoding: .URL, resource: resource, username: user.username!, password: user.password!,
            params: nil,
            onCompletion: { json, err in
                ApiResult.getSimpleType(json, error: err, completionHandler: onCompletion)
        })
    }
}