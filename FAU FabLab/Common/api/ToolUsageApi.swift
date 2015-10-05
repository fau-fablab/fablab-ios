import ObjectMapper
import Alamofire

struct ToolUsageApi{
    
    private let resource = "/toolUsage"
    
    func getUsageForTool(toolId: Int64, onCompletion: ([ToolUsage]?, NSError?) -> Void){
        let endpoint = resource + "/\(toolId)/"
        
        RestManager.sharedInstance.makeJSONRequest(.GET, encoding: .URL, resource: endpoint, params: nil,
            onCompletion: { json, err in
                ApiResult.getArray(json, error: err, completionHandler: onCompletion)
        })
    }
    
    func getUsage(toolId: Int64, usageId: Int64, onCompletion: (ToolUsage?, NSError?) -> Void){
        let endpoint = resource + "/\(toolId)/\(usageId)/"
        
        RestManager.sharedInstance.makeJSONRequest(.GET, encoding: .URL, resource: endpoint, params: nil,
            onCompletion: { json, err in
                ApiResult.get(json, error: err, completionHandler: onCompletion)
        })
    }
    
    func addUsage(user: User? = nil, token: String, toolId: Int64, usage: ToolUsage, onCompletion: (ToolUsage?, NSError?) -> Void){
        let endpoint = resource + "/\(toolId)/"
        
        let bodyParams = Mapper<ToolUsage>().toJSON(usage)
        let headerParams = ["token" : token]
        
        let url = NSURL(string: endpoint)
        let encoding = Alamofire.ParameterEncoding.URL
        var request = NSMutableURLRequest(URL: url!)
        (request, _) = encoding.encode(request, parameters: headerParams)
        
        
        if(user == nil){
            RestManager.sharedInstance.makeJSONRequest(.PUT, encoding: .JSON, resource: request.URL!.absoluteString, params: bodyParams,
                onCompletion: { json, err in
                    ApiResult.get(json, error: err, completionHandler: onCompletion)
            })
        }
        else{
            RestManager.sharedInstance.makeJSONRequestWithBasicAuth(.PUT, encoding: .JSON, resource: request.URL!.absoluteString,
                username: user!.username!, password: user!.password!, params: bodyParams,
                onCompletion: { json, err in
                    ApiResult.get(json, error: err, completionHandler: onCompletion)
            })
        }
    }
    
    func removeUsage(user: User? = nil, token: String, toolId: Int64, usageId: Int64, onCompletion: (NSError?) -> Void){
        let endpoint = resource + "/\(toolId)/\(usageId)"
        let headerParams = ["token" : token]

        if(user == nil){
            RestManager.sharedInstance.makeTextRequest(.DELETE, encoding: .URL, resource: endpoint, params: headerParams,
                onCompletion: { _, err in
                    if(err != nil){
                        onCompletion(err)
                    }
                    onCompletion(nil)
            })
        }
        else{
            RestManager.sharedInstance.makeRequestWithBasicAuth(.DELETE, encoding: .URL, resource: endpoint,
                username: user!.username!, password: user!.password!, params: nil,
                onCompletion: { _, err in
                    if(err != nil){
                        onCompletion(err)
                    }
                    onCompletion(nil)
            })
        }
    }
    
    func removeUsagesForTool(user: User, toolId: Int64, onCompletion: (NSError?) -> Void){
        let endpoint = resource + "/\(toolId)"
        
        RestManager.sharedInstance.makeRequestWithBasicAuth(.DELETE, encoding: .URL, resource: endpoint,
            username: user.username!, password: user.password!, params: nil,
            onCompletion: { _, err in
                if(err != nil){
                    onCompletion(err)
                }
                onCompletion(nil)
        })
    }
    
    func getEnabledTools(onCompletion: ([FabTool]?, NSError?) -> Void) {
        let endpoint = resource + "/tools"
        
        RestManager.sharedInstance.makeJSONRequest(.GET, encoding: .URL, resource: endpoint,
            params: nil, headers: nil) { (json, error) -> Void in
                ApiResult.getArray(json, error: error, completionHandler: onCompletion)
        }
    }
}
