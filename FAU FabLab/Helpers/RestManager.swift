import Foundation
import Alamofire
import SwiftyJSON
typealias JsonServiceResponse = (AnyObject, NSError?) -> Void

class RestManager {
    
    static let sharedInstance = RestManager()

    private var manager:Manager;
    private let devApiUrl = "https://ec2-52-28-16-59.eu-central-1.compute.amazonaws.com:4433" //ec2-52-28-16-59.eu-central-1.compute.amazonaws.com/
    
    init(){
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            "ec2-52-28-16-59.eu-central-1.compute.amazonaws.com": .PinCertificates(
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
        manager.request(.GET, devApiUrl+resource, parameters: params)
            .responseJSON { (req, res, json, error) in
                println("GET: \(self.devApiUrl+resource) JSONAnswer: \(json)");
                onCompletion(json!, error);
        }
    }
    
    func makeJsonPostRequest(resource: String, params: NSDictionary, onCompletion : JsonServiceResponse) {
        
        manager.request(.POST, devApiUrl+resource, parameters: params as? [String : AnyObject], encoding: .JSON)
            .responseJSON { (req, res, json, error) in
                println("POST: \(self.devApiUrl+resource) JSONAnswer: \(json)");
                if(json != nil){
                    onCompletion(json!, error);
                }
        }

        //Can be used to debug the request...
//        Alamofire.request(.POST, "http://httpbin.org/post", parameters: params as? [String : AnyObject], encoding: .JSON)
//            .responseJSON {(request, response, JSON, error) in
//                println(JSON)
//        }
        
       
    }
    
    
    
}
