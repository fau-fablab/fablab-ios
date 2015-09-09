import ObjectMapper

struct SpaceApi{
    
    private let resource = "/spaceapi";
    private let space = "FAU+FabLab";
    private let mapper = Mapper<DoorState>()
    
    func getSpace(onCompletion: (DoorState?, NSError?) -> Void){
        let endpoint = resource + "/spaces/" + space
        
        RestManager.sharedInstance.makeJSONRequest(.GET, encoding: .JSON, resource: endpoint, params: nil, onCompletion: {
            json, err in
            
            if(err != nil){
                onCompletion(nil, err)
            }
            else{
                onCompletion(self.mapper.map(json), nil)
            }
        })
    }
}
