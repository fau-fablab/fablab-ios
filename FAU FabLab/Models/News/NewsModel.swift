import UIKit
import SwiftyJSON
import Foundation.NSURL
import ObjectMapper

typealias NewsLoadFinished = (NSError?) -> Void;

public class NewsModel: NSObject {

    private let resource = "/news";
    private var news = [News]()
    private var isLoading = false;
    private var newsLoaded = false;
    private var mapper:Mapper<News>;

    override init() {
        mapper = Mapper<News>()
        super.init()
    }

    func getCount() -> Int {
        return news.count;
    }

    func fetchNews(#onCompletion: NewsLoadFinished) {
        if (!isLoading && !newsLoaded) {
            isLoading = true;

            RestManager.sharedInstance.makeJsonGetRequest(resource, params: nil, onCompletion: {
                json, err in
                if (err != nil) {
                    ErrorAlertView.showErrorView("Fehler beim Abrufen der News".localized)
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
            })
        }
    }

    func addNews(entry:News) {
        news.append(entry)
    }
    
    func getNews(position:Int) -> News{
        return news[position];
    }

}

