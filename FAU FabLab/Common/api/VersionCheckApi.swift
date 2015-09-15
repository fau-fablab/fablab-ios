struct VersionCheckApi {
    private let resource = "/versionCheck";
    
    func checkVersion(platformType: PlatformType, version: Int, onCompletion: (UpdateStatus?, NSError?) -> Void){
        let params: [String : AnyObject] = ["platformType" : platformType.rawValue, "currentVersion" : version]

        RestManager.sharedInstance.makeJSONRequest(.GET, encoding: .URL, resource: resource, params: params,
            onCompletion: { json, error in
                ApiResult.get(json, error: error, completionHandler: onCompletion)
        })
    }
}
