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

    func getNews(#onCompletion: NewsLoadFinished) {
        if (!isLoading && !newsLoaded) {
            isLoading = true;

            RestManager.sharedInstance.makeJsonRequest(resource, onCompletion: {
                json, err in
                if (err != nil) {
                    println("ERROR! ", err);
                    onCompletion(err)
                }
                
                if let news = self.mapper.mapArray(json) {
                    for tmp in news {
                        self.addNews(tmp)
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

