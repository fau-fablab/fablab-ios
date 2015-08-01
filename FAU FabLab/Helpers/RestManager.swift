import Foundation
import SwiftyJSON
import Alamofire

typealias JsonServiceResponse = (JSON, NSError?) -> Void

class RestManager {
    
    static let sharedInstance = RestManager()

    var manager:Manager;
    let devApiUrl = "https://ec2-52-28-16-59.eu-central-1.compute.amazonaws.com:4433"
    
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
    
    func makeJsonRequest(resource: String, onCompletion : JsonServiceResponse) {
        manager.request(.GET, devApiUrl+resource, parameters: nil)
            .responseJSON { (req, res, json, error) in
                println(self.devApiUrl+resource);
                var json = JSON(json!);
                onCompletion(json, error);
        }
    }
}
