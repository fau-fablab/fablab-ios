import Foundation
import Alamofire
import SwiftyJSON

typealias ServiceResponse = (String?, NSError?) -> Void
typealias JsonServiceResponse = (AnyObject?, NSError?) -> Void

class RestManager {

    static let sharedInstance = RestManager()
    private var manager: Manager;

#if PRODUCTION
    let apiUrl = "https://app.fablab.fau.de/api"
#else
    let apiUrl = "https://app.fablab.fau.de/api"
#endif

    init() {
        manager = Manager(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    }

    func makeJSONRequest(method: Alamofire.Method,
                         encoding: ParameterEncoding,
                         resource: String,
                         params: [String:AnyObject]?,
                         headers: [String:String]? = nil,
                         onCompletion: JsonServiceResponse) {

        let endpoint = apiUrl + resource
        manager.request(method, endpoint, parameters: params, headers: headers, encoding: encoding)
            .validate(statusCode: 200 ..< 300)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                //self.printDebug("GET", resource: endpoint, res: result, responseJson: json, error: error)
                switch response.result{
                case .Success:
                    onCompletion(response.result.value, nil)
                case .Failure:
                    onCompletion(nil, response.result.error)
                }
        }
    }

    func makeTextRequest(method: Alamofire.Method,
                         encoding: ParameterEncoding,
                         resource: String,
                         params: NSDictionary?,
                         headers: [String:String]? = nil,
                         onCompletion: ServiceResponse) {

        let endpoint = apiUrl + resource
        manager.request(method, endpoint, parameters: params as? [String:AnyObject], headers: headers, encoding: encoding)
        .validate(statusCode: 200 ..< 300)
        .validate(contentType: ["text/plain"])
        .responseString { response in
            //self.printDebug("GET", resource: endpoint, res: res, responseString: answer, error: error);
            switch response.result{
            case .Success:
                onCompletion(response.result.value, nil)
            case .Failure:
                onCompletion(nil, response.result.error)
            }
        }
    }
    
    func makeRequestWithBasicAuth(method: Alamofire.Method, encoding: ParameterEncoding, resource: String, username: String, password: String, params: [String:AnyObject]?, onCompletion: ServiceResponse) {
        
        let credentialData = "\(username):\(password)".dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Credentials = credentialData.base64EncodedStringWithOptions([])
        
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        
        makeTextRequest(method, encoding: encoding, resource: resource, params: params, headers: headers, onCompletion: onCompletion)
    }

    func makeJSONRequestWithBasicAuth(method: Alamofire.Method, encoding: ParameterEncoding, resource: String, username: String, password: String, params: [String:AnyObject]?, onCompletion: JsonServiceResponse) {

        let credentialData = "\(username):\(password)".dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Credentials = credentialData.base64EncodedStringWithOptions([])

        let headers = ["Authorization": "Basic \(base64Credentials)", "Accept": "application/json"]

        makeJSONRequest(method, encoding: encoding, resource: resource, params: params, headers: headers, onCompletion: onCompletion)
    }
    
    func downloadFile(resource: String){
        let endpoint = apiUrl + resource
        
        manager.download(.GET, endpoint) { temporaryURL, response in
            let fileManager = NSFileManager.defaultManager()
            if let directoryURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0] as? NSURL {
                let pathComponent = response.suggestedFilename
                return directoryURL.URLByAppendingPathComponent(pathComponent!)
            }
            return temporaryURL
        }
    }

    private func printDebug(method: String, resource: String, res: NSHTTPURLResponse?, responseJson: AnyObject?, error: NSError?) {
        if let res = res {
            Debug.instance.log("\(method): \(resource) JSONAnswer: \(responseJson) StatusCode: \(res.statusCode)");
        }
        if let error = error {
            Debug.instance.log(error)
        }
    }

    private func printDebug(method: String, resource: String, res: NSHTTPURLResponse?, responseString: String?, error: NSError?) {
        if let res = res {
            Debug.instance.log("\(method): \(resource) Answer: \(responseString) StatusCode: \(res.statusCode)");
        }
        if let error = error {
            Debug.instance.log(error)
        }
    }
}
