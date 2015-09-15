struct SpaceApi{
    
    private let resource = "/spaceapi";
    private let space = "FAU+FabLab";
    
    func getSpace(onCompletion: (DoorState?, NSError?) -> Void){
        let endpoint = resource + "/spaces/" + space
        
        RestManager.sharedInstance.makeJSONRequest(.GET, encoding: .JSON, resource: endpoint, params: nil,
            onCompletion: { json, err in
                ApiResult.get(json, error: err, completionHandler: onCompletion)
        })
    }
}
