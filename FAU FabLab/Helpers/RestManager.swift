import Foundation
import Alamofire
import SwiftyJSON

typealias ServiceResponse = (String?, NSError?) -> Void
typealias JsonServiceResponse = (AnyObject?, NSError?) -> Void

class RestManager {
    
    static let sharedInstance = RestManager()
    
    private var manager:Manager;
    
    let apiUrl = "https://ec2-52-28-163-255.eu-central-1.compute.amazonaws.com:4433"
    
    init(){
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            "ec2-52-28-163-255.eu-central-1.compute.amazonaws.com": .PinCertificates(
                certificates: ServerTrustPolicy.certificatesInBundle(),
                validateCertificateChain: true,
                validateHost: true
            )
        ]
        
        manager = Manager(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
    }
    
    func makeJsonGetRequest(resource: String, params: [String : String]?, onCompletion : JsonServiceResponse) {
        let endpoint = apiUrl+resource
        manager.request(.GET, endpoint, parameters: params)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { (req, res, json, error) in
                self.printDebug("GET", resource: endpoint, res: res, responseJson: json, error: error)
                onCompletion(json, error);
        }
    }
    
    func makeGetRequest(resource: String, params: [String : String]?, onCompletion : ServiceResponse) {
        let endpoint = apiUrl+resource
        manager.request(.GET, endpoint, parameters: params)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["text/plain"])
            .responseString { (req, res, answer, error) in
                self.printDebug("GET", resource: endpoint, res: res, responseString: answer, error: error);
                onCompletion(answer, error);
        }
    }
    
    func makeJsonPostRequest(resource: String, params: NSDictionary?, onCompletion : JsonServiceResponse) {
        let endpoint = apiUrl+resource
        manager.request(.POST, endpoint, parameters: params as? [String : AnyObject], encoding: .JSON)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { (req, res, json, error) in
                self.printDebug("POST", resource: endpoint, res: res, responseJson: json, error: error)
                onCompletion(json, error)
        }
        
        //Can be used to debug the request...
        //        Alamofire.request(.POST, "http://httpbin.org/post", parameters: params as? [String : AnyObject], encoding: .JSON)
        //            .responseJSON {(request, response, JSON, error) in
        //                println(JSON)
        //        }
    }
    
    func makeJsonPutRequest(resource: String, params: NSDictionary?, onCompletion : JsonServiceResponse) {
        let endpoint = apiUrl+resource
        manager.request(.PUT, endpoint, parameters: params as? [String : AnyObject], encoding: .JSON)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { (req, res, json, error) in
                self.printDebug("PUT", resource: endpoint, res: res, responseJson: json, error: error)
                onCompletion(json, error)
        }
    }
    

    func makePostRequest(resource: String, params: NSDictionary?, onCompletion : ServiceResponse) {
        let endpoint = apiUrl + resource
        manager.request(.POST, endpoint, parameters: params as? [String:AnyObject], encoding: .JSON)
        .validate(statusCode: 200 ..< 300)
        .validate(contentType: ["text/plain"])
        .responseString {
            (req, res, answer, error) in
                self.printDebug("POST", resource: endpoint, res: res, responseString: answer, error: error);
                onCompletion(answer, error)
        }
    }
    
    private func printDebug(method: String, resource: String, res: NSHTTPURLResponse?, responseJson: AnyObject?, error: NSError?){
        if let res = res{
            Debug.instance.log("\(method): \(resource) JSONAnswer: \(responseJson) StatusCode: \(res.statusCode)");
        }
        if let error = error{
            Debug.instance.log(error)
        }
    }
    
    private func printDebug(method: String, resource: String, res: NSHTTPURLResponse?, responseString: String?, error: NSError?){
        if let res = res{
            Debug.instance.log("\(method): \(resource) Answer: \(responseString) StatusCode: \(res.statusCode)");
        }
        if let error = error{
            Debug.instance.log(error)
        }
    }
    
}
