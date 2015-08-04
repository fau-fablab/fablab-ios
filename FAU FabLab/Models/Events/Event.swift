import Foundation
import ObjectMapper

class Event : Mappable{
    
    private(set) var uid:String?
    private(set) var summery:String?
    private(set) var start:String?
    private(set) var end:String?
    private(set) var url:String?
    private(set) var location:String?
    private(set) var description:String?
    private(set) var allday:Bool?
    
    
    class func newInstance() -> Mappable {
        return Event()
    }
    
    // Mappable
    func mapping(map: Map) {
        uid <- map["uid"]
        summery <- map["summery"]
        start <- map["start"]
        end <- map["end"]
        url <- map["url"]
        location <- map["location"]
        description <- map["description"]
        allday <- map["allday"]
    }
    
    func getDateFormatter() -> NSDateFormatter {
        var dateFmt = NSDateFormatter()
        dateFmt.timeZone = NSTimeZone.defaultTimeZone()
        dateFmt.dateFormat = "yyyyMMdd'T'HHmmss'Z'"
        return dateFmt
    }

    func getStartAsDate() -> NSDate {
        return getDateFormatter().dateFromString(start!)!
    }
    
    func getEndAsDate() -> NSDate {
        return getDateFormatter().dateFromString(end!)!
    }
}

