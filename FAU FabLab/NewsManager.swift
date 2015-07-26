import UIKit
import SwiftyJSON
import Foundation.NSURL

typealias NewsLoadFinished = () -> Void;
typealias NewsLoadProgress = () -> Void;

var newsMgr: NewsManager = NewsManager()

struct newsEntry {
    var title: String
    var description: String;
}

class NewsManager: NSObject {

    var news = [newsEntry]()
    var isLoading = false;
    var newsLoaded = false;

    override init() {
        super.init()
    }

    func getCount() -> Int {
        return news.count;
    }

    func getNews(onProgress: NewsLoadProgress, onCompletion: NewsLoadFinished) {
        if (!isLoading && !newsLoaded) {
            isLoading = true;
            RestManager.sharedInstance.fetchNews {
                json in
                for (index: String, subJson: JSON) in json {

                    //Decode html
                    let htmlText = subJson["description"].string!.dataUsingEncoding(NSUTF8StringEncoding)!
                    let attributedOptions : [String: AnyObject] = [
                            NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                            NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding
                    ]
                    let attributedString = NSAttributedString(data: htmlText, options: attributedOptions, documentAttributes: nil, error: nil)!
                    let decodedString = attributedString.string // The Weeknd ‘King Of The Fall’

                    self.addNews(subJson["title"].string!, desc:decodedString )
                    onProgress()
                }
                self.isLoading = false;
                self.newsLoaded = true;
                onCompletion()
            }
        }
    }

    func addNews(title: String, desc: String) {
        news.append(newsEntry(title: title, description: desc))
    }

}

