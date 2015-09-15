struct DrupalApi{
    private let resource = "/drupal";
    
    func findAllTools(onCompletion: ([FabTool]?, NSError?) -> Void){
        let endpoint = resource + "/tools"
        
        RestManager.sharedInstance.makeJSONRequest(.GET, encoding: .URL, resource: endpoint, params: nil,
            onCompletion: { json, err in
                ApiResult.getArray(json, error: err, completionHandler: onCompletion)
        })
    }
    
    func findToolById(id: Int64, onCompletion: (FabTool?, NSError?) -> Void){
        let endpoint = resource + "/tools/\(id)"

        RestManager.sharedInstance.makeJSONRequest(.GET, encoding: .URL, resource: endpoint, params: nil,
            onCompletion: { json, err in
                ApiResult.get(json, error: err, completionHandler: onCompletion)
        })
    }
}
