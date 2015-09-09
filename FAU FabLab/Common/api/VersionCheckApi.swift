import ObjectMapper

struct VersionCheckApi {
    
    private let mapper = Mapper<UpdateStatus>()
    private let resource = "/versionCheck";
    
    func checkVersion(platformType: PlatformType, version: Int, onCompletion: (UpdateStatus?, NSError?) -> Void){
        
        let params: [String : AnyObject] = ["platformType" : platformType.rawValue, "currentVersion" : version]

        RestManager.sharedInstance.makeJSONRequest(.GET, encoding: .URL, resource: resource, params: params,
            onCompletion: { json, error in
                if(error != nil){
                    Debug.instance.log(error)
                    onCompletion(nil, error)
                }
                else{
                    Debug.instance.log(json)
                    onCompletion(self.mapper.map(json), nil)
                }
            })
    }
}
