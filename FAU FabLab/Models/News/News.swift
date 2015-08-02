import UIKit
import Foundation
import ObjectMapper


class News: Mappable {

    private(set) var title: String?;
    private(set) var description: String?
    private(set) var link: String?
    private(set) var descriptionShort: String?
    private(set) var category: String?
    private(set) var pubDate: NSDate?
    private(set) var creator: String?
    private(set) var isPermaLink: Bool?
    private(set) var linkToPreviewImage: String?
    
    let htmlTransform = TransformOf<String, String>(
        fromJSON: { (value: String?) -> String? in
            // transform value from String? to Int?
            //Decode html
            let htmlText = value!.dataUsingEncoding(NSUTF8StringEncoding)!
            let attributedOptions: [String:AnyObject] = [
                NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding
            ]
            let attributedString = NSAttributedString(data: htmlText, options: attributedOptions, documentAttributes: nil, error: nil)!
            return attributedString.string
        },
        toJSON: { (value: String?) -> String? in
            // transform value from Int? to String?
            return nil
    })
    
    class func newInstance() -> Mappable {
        return News()
    }

    // Mappable
    func mapping(map: Map) {
        title <- map["title"]
        description <- (map["description"], htmlTransform)
        link <- map["link"]
        descriptionShort <- map["descriptionShort"]
        category <- map["category"]
        pubDate <- (map["pubDate"], ISO8601DateTransform())
        creator <- map["creator"]
        isPermaLink <- map["isPermaLink"]
        linkToPreviewImage <- map["linkToPreviewImage"]
    }
}