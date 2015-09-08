import ObjectMapper

struct InventoryApi{
    
    let api = RestManager.sharedInstance
    let inventoryMapper = Mapper<InventoryItem>()
    let resource = "/inventory"
    
    func getAll(onCompletion: ([InventoryItem]?, NSError?) -> Void){
        api.makeJSONRequest(.GET, encoding: .URL, resource: resource, params: nil, onCompletion: {
            JSON, err in
                if(err != nil){
                    onCompletion(nil, err)
                }else{
                    onCompletion(self.inventoryMapper.mapArray(JSON), nil)
                }
        })
    }
    
    func add(user: User, item: InventoryItem, onCompletion: (InventoryItem?, NSError?) -> Void){
        let params = inventoryMapper.toJSON(item)
                
        api.makeJSONRequestWithBasicAuth(.POST, encoding: .JSON, resource: resource, username: user.username!, password: user.password!, params: params,
            onCompletion: {
                JSON, err in
                
                if(err != nil){
                    onCompletion(nil, err)
                }
                else{
                    onCompletion(self.inventoryMapper.map(JSON), nil)
                }
        })
    }
    
    func deleteAll(user: User, onCompletion: (Bool?, NSError?) -> Void){
        api.makeJSONRequestWithBasicAuth(.DELETE, encoding: .URL, resource: resource, username: user.username!, password: user.password!, params: nil,
            onCompletion: {
                JSON, err in

                if(err != nil){
                    onCompletion(nil, err)
                }
                else{
                    onCompletion(JSON as? Bool, nil)
                }
        })
    }
}