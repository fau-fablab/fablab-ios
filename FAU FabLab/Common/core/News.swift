import UIKit
import Foundation
import ObjectMapper


class News: Mappable {

    private(set) var title:                 String?;
    private(set) var description:           String?
    private(set) var link:                  String?
    private(set) var descriptionShort:      String?
    private(set) var category:              String?
    private(set) var pubDate:               NSDate?
    private(set) var creator:               String?
    private(set) var isPermaLink:           Bool?
    private(set) var linkToPreviewImage:    String?
    
    private var dateFormatter = NSDateFormatter()
    
    required init?(_ map: Map) {
        self.dateFormatter.timeZone = NSTimeZone(name: "UTC+2")
    }
    
    // Mappable
    func mapping(map: Map) {
        title               <-  map["title"]
        description         <-  map["description"]
        link                <-  map["link"]
        descriptionShort    <-  map["descriptionShort"]
        category            <-  map["category"]
        pubDate             <- (map["pubDate"], ISO8601DateTransform())
        creator             <-  map["creator"]
        isPermaLink         <-  map["isPermaLink"]
        linkToPreviewImage  <-  map["linkToPreviewImage"]
    }
    
    var pubDateString : String {
        dateFormatter.dateFormat = "dd.MM.yyy - HH:mm"
        return dateFormatter.stringFromDate(pubDate!)
    }
}