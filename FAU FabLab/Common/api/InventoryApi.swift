import ObjectMapper

struct InventoryApi{
    
    let api = RestManager.sharedInstance
    let mapper = Mapper<InventoryItem>()
    let resource = "/inventory"
    
    func getAll(onCompletion: ([InventoryItem]?, NSError?) -> Void){
        api.makeJSONRequest(.GET, encoding: .URL, resource: resource, params: nil, onCompletion: {
            JSON, err in
                if(err != nil){
                    onCompletion(nil, err)
                }else{
                    onCompletion(self.mapper.mapArray(JSON), nil)
                }
        })
    }
}