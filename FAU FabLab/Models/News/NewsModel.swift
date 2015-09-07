import UIKit
import SwiftyJSON
import Foundation.NSURL
import ObjectMapper

public class NewsModel: NSObject {

    private let resource = "/news";
    private let timestampResource = "/news/timestamp"
    private var news = [News]()
    private var isLoading = false;
    private var newsLoaded = false;
    private var mapper:Mapper<News>;
    
    private var clientTimestamp: Int = Int()
    private var serverTimestamp: Int = Int()

    override init() {
        mapper = Mapper<News>()
        super.init()
    }

    func getCount() -> Int {
        return news.count;
    }

    func fetchNews(#onCompletion: ApiResponse) {
        if (!isLoading && !newsLoaded) {
            isLoading = true;

            RestManager.sharedInstance.makeJsonGetRequest(resource, params: nil, onCompletion: {
                json, err in
                if (err != nil) {
                    AlertView.showErrorView("Fehler beim Abrufen der News".localized)
                    onCompletion(err)
                }
                
                if let news = self.mapper.mapArray(json) {
                    for tmp in news {
                        self.addNews(tmp)
                        Debug.instance.log("Added news ! ")
                    }
                }
                
                onCompletion(nil);
                self.isLoading = false;
                self.newsLoaded = true;
                
                // set clientTimestamp to the current server-timestamp
                self.getLastUpdateTimestamp(onCompletion: { error in
                    if(error != nil){
                        Debug.instance.log("Error!");
                    }
                    self.clientTimestamp = self.getServerTimestamp()
                })
            })
        }
    }
    
    func getLastUpdateTimestamp(#onCompletion: ApiResponse) {
        RestManager.sharedInstance.makeJsonGetRequest(timestampResource, params: nil, onCompletion: {
            ts, err in
            if (err != nil) {
                AlertView.showErrorView("Fehler beim Abrufen der News".localized)
                onCompletion(err)
            }
            self.serverTimestamp = Int(ts as! NSNumber)
            onCompletion(nil);
        })
    }

    func addNews(entry:News) {
        news.append(entry)
    }
    
    func getNews(position:Int) -> News{
        return news[position];
    }
    
    func getClientTimestamp() -> Int {
        return self.clientTimestamp
    }
    
    func getServerTimestamp() -> Int {
        return self.serverTimestamp
    }
    
    func setFlagToReloadNews() {
        self.newsLoaded = false
    }

}

