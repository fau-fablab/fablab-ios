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
    
    func makeJsonPostRequest(resource: String, cart: Cart, onCompletion : JsonServiceResponse) {
        
        let test = "asdf"
        
        let asdf = ["title" : "asdf", "body": "I iz fisrt", "userId": 1]
        
        let values = ["06786984572365", "06644857247565", "06649998782227"]
        
        let request = Alamofire.request(.POST, resource, parameters: asdf, encoding: .JSON)
        //debugPrintln(request)
    }
    
    func testRequest(resource: String, parameters: [String : String]?, onCompletion : JsonServiceResponse){
        let json = ["password": "dummyPassword"]
        let request = manager.request(.POST, resource, parameters: json, encoding: .JSON)
            .responseString { (req, res, json, error) in
                println("JSON: \(json)");
                println("error: \(error)");
                if (json != nil){
                    onCompletion(json!, error);
                }
        }
        debugPrintln(request)
    }
    
    
    
}
