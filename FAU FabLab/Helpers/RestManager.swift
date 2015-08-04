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
    
    func makeJsonPostRequest(resource: String, params: [String : String]?, onCompletion : JsonServiceResponse) {
        
        var temp1 : String! = "adsf"
        let parameters = [
            "cartCode": temp1,
            "baz": ["a", 1],
            "qux": [
                "x": 1,
                "y": 2,
                "z": 3
            ],
            "asdf" : "asdf"
        ]
        
        Alamofire.request(.POST, "http://httpbin.org/post", parameters: parameters as? [String : AnyObject], encoding: .JSON)
            .responseJSON {(request, response, JSON, error) in
                println(JSON)
        }

        
       
    }
    
    
    
}
