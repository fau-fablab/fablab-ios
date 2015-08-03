import Foundation
import SwiftyJSON
import Alamofire

typealias JsonServiceResponse = (AnyObject, NSError?) -> Void

class RestManager {
    
    static let sharedInstance = RestManager()

    private var manager:Manager;
    private let devApiUrl = "https://ec2-52-28-16-59.eu-central-1.compute.amazonaws.com:4433"
    
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
                println("GET: \(self.devApiUrl+resource)");
                onCompletion(json!, error);
        }
    }
    
    func makeJsonPostRequest(resource: String, params: [String : String]?, onCompletion : JsonServiceResponse) {
        manager.request(.POST, devApiUrl+resource, parameters: params)
            .responseJSON { (req, res, json, error) in
                println("POST: \(self.devApiUrl+resource)");
                onCompletion(json!, error);
        }
    }
}
