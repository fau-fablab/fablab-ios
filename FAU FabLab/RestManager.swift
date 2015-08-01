import Foundation
import SwiftyJSON

typealias ServiceResponse = (JSON, NSError?) -> Void

class RestManager {

    static let sharedInstance = RestManager()

    let apiUrl = "https://52.28.16.59:4433"

    func fetchNews(onCompletion: (JSON) -> Void) {
        let route = apiUrl + "/news/all";
        makeHTTPGetRequest(route, onCompletion: { json, err in
            if(err != nil){
                //TODO error handling
                println("Error");
            }
            onCompletion(json as JSON)
        })
    }

    func makeHTTPGetRequest(path: String, onCompletion: ServiceResponse) {
        let request = NSMutableURLRequest(URL: NSURL(string: path)!)

        let session = NSURLSession.sharedSession()

        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            let json:JSON = JSON(data: data)
            onCompletion(json, error)
        })
        task.resume()
    }
}
