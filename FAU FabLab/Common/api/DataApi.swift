struct DataApi{
    private let resource = "/data";
    
    func getFablabMailAddress(onCompletion: (String?, NSError?) -> Void){
        let endpoint = resource + "/fablab-mail"
        
        RestManager.sharedInstance.makeTextRequest(.GET, encoding: .URL, resource: endpoint, params: nil,
            onCompletion: { text, err in
                ApiResult.getSimpleType(text, error: err, completionHandler: onCompletion)
        })
    }
    
    func getFeedbackMailAddress(onCompletion: (String?, NSError?) -> Void){
        let endpoint = resource + "/feedback-mail"
        
        RestManager.sharedInstance.makeTextRequest(.GET, encoding: .URL, resource: endpoint, params: nil,
            onCompletion: { text, err in
                ApiResult.getSimpleType(text, error: err, completionHandler: onCompletion)
        })
    }
    
    func getMailAddresses(onCompletion: ([MailAddresses]?, NSError?) -> Void){
        let endpoint = resource + "/mail-addresses"
        
        RestManager.sharedInstance.makeJSONRequest(.GET, encoding: .URL, resource: endpoint, params: nil,
            onCompletion: { json, err in
                ApiResult.getArray(json, error: err, completionHandler: onCompletion)
        })
    }
}
