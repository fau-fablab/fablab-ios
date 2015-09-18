import Foundation
import Alamofire
import SwiftyJSON

typealias ServiceResponse = (String?, NSError?) -> Void
typealias JsonServiceResponse = (AnyObject?, NSError?) -> Void

class RestManager {

    static let sharedInstance = RestManager()
    private var manager: Manager;

#if PRODUCTION
    let apiUrl = "https://ec2-52-28-126-35.eu-central-1.compute.amazonaws.com:4433"
    let serverTrustPolicies: [String:ServerTrustPolicy] = [
            "ec2-52-28-126-35.eu-central-1.compute.amazonaws.com": .PinCertificates(
            certificates: ServerTrustPolicy.certificatesInBundle(),
                    validateCertificateChain: true,
                    validateHost: true
            )
    ]
#else
    let apiUrl = "https://ec2-52-28-163-255.eu-central-1.compute.amazonaws.com:4433"
    let serverTrustPolicies: [String:ServerTrustPolicy] = [
            "ec2-52-28-163-255.eu-central-1.compute.amazonaws.com": .PinCertificates(
            certificates: ServerTrustPolicy.certificatesInBundle(),
                    validateCertificateChain: true,
                    validateHost: true
            )
    ]
#endif

    init() {
        manager = Manager(
        configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
                serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
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
            .responseJSON { (req, res, json, error) in
                self.printDebug("GET", resource: endpoint, res: res, responseJson: json, error: error)
                onCompletion(json, error);
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
        .responseString { (req, res, answer, error) in
            self.printDebug("GET", resource: endpoint, res: res, responseString: answer, error: error);
            onCompletion(answer, error);
        }
    }

    func makeJSONRequestWithBasicAuth(method: Alamofire.Method, encoding: ParameterEncoding, resource: String, username: String, password: String, params: [String:AnyObject]?, onCompletion: JsonServiceResponse) {
        let endpoint = apiUrl + resource

        let credentialData = "\(username):\(password)".dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Credentials = credentialData.base64EncodedStringWithOptions(nil)

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
