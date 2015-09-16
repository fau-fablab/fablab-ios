import UIKit
import SwiftyJSON
import Foundation.NSURL

public class NewsModel: NSObject {

    private let api = NewsApi()
    
    private var news = [News]()
    
    //The initial values have to be different so we initially fetch the news
    private var clientTimestamp: Int64 = 0
    private var serverTimestamp: Int64 = -1
    
    private var isLoading = false;
    private var newsLoaded: Bool{
        return clientTimestamp == serverTimestamp
    };

    override init() {
        super.init()
    }

    func getCount() -> Int {
        return news.count;
    }
    
    func fetchNews(#onCompletion: ApiResponse) {
        //If we are already loading just return
        if(isLoading){
            return
        }
        //get the latest timestamp from server
        updateNeeded({ result in
            //if we have the latest version just return
            if (self.newsLoaded) {
                Debug.instance.log("Latest version of news!")
                return
            }
            //mark ourself as loading and fetch the news
            self.isLoading = true;
                    
            self.api.findAll({  news, err in
                if(err != nil){
                    AlertView.showErrorView("Fehler beim Abrufen der News".localized)
                    onCompletion(err)
                }
                //if we fetched the news, set our timestamp
                else if let news = news{
                    self.news = news
                    self.clientTimestamp = self.serverTimestamp
                    onCompletion(nil);
                }
                self.isLoading = false;
            })
        })
    }
    
    func getNews(position:Int) -> News{
        return news[position];
    }
    
    private func updateNeeded(onCompletion: (Bool) -> Void){
        self.api.lastUpdate({ timestamp, error in
            if(error != nil){
                Debug.instance.log("Error!");
                onCompletion(false)
            }
            self.serverTimestamp = timestamp!
            onCompletion(self.newsLoaded)
        })
    }
}

