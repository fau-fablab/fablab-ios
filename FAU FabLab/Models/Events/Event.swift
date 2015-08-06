import Foundation
import ObjectMapper

class Event: Mappable {

    private(set) var uid: String?
    private(set) var summery: String?
    private(set) var start: NSDate?
    private(set) var end: NSDate?
    private(set) var url: String?
    private(set) var location: String?
    private(set) var description: String?
    private(set) var allday: Bool?

    private var dateFormatter = NSDateFormatter()

    var startDayString : String {
        dateFormatter.dateFormat = "dd"
        return dateFormatter.stringFromDate(start!)
    }

    var endDayString : String {
        dateFormatter.dateFormat = "dd"
        return dateFormatter.stringFromDate(end!)
    }

    var startMonthString : String {
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.stringFromDate(start!)
    }

    var endMonthString : String {
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.stringFromDate(end!)
    }

    var startYearString : String {
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.stringFromDate(start!)
    }

    var endYearString : String {
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.stringFromDate(end!)
    }

    var startTimeString : String {
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.stringFromDate(start!)
    }

    var endTimeString : String {
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.stringFromDate(end!)
    }

    var startDateString : String {
        dateFormatter.dateFormat = "dd.MM.yyy - HH:mm"
        return dateFormatter.stringFromDate(start!)
    }

    var endDateString : String {
        dateFormatter.dateFormat = "dd.MM.yyy - HH:mm"
        return dateFormatter.stringFromDate(end!)
    }

    var isToday : Bool {
        return NSCalendar.currentCalendar().isDateInToday(start!)
    }

    var isOneDay : Bool {
        return NSCalendar.currentCalendar().isDate(start!, inSameDayAsDate: end!)
    }

    class func newInstance() -> Mappable {
        let event = Event();
        event.dateFormatter.timeZone = NSTimeZone(name: "UTC+2")

        return event
    }

    // Mappable
    func mapping(map: Map) {
        uid <- map["uid"]
        summery <- map["summery"]
        start <- (map["start"], EventDateTransform())
        end <- (map["end"], EventDateTransform())
        url <- map["url"]
        location <- map["location"]
        description <- map["description"]
        allday <- map["allday"]
    }

    private class EventDateTransform : DateFormaterTransform {
        init() {
            let formatter = NSDateFormatter()
            formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
            formatter.timeZone = NSTimeZone(name: "UTC")
            formatter.dateFormat = "yyyyMMdd'T'HHmmss'Z'"

            super.init(dateFormatter: formatter)
        }
    }
}

