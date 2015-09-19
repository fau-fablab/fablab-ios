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
            RestManager.sharedInstance.makeJSONRequest(.GET, encoding: .JSON, resource: request.URL!.absoluteString!, params: bodyParams,
                onCompletion: { json, err in
                    ApiResult.get(json, error: err, completionHandler: onCompletion)
            })
        }
        else{
            RestManager.sharedInstance.makeJSONRequestWithBasicAuth(.GET, encoding: .JSON, resource: request.URL!.absoluteString!,
                username: user!.username!, password: user!.password!, params: bodyParams,
                onCompletion: { json, err in
                    ApiResult.get(json, error: err, completionHandler: onCompletion)
            })
        }
    }
}
