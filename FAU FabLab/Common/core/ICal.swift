import Foundation
import ObjectMapper

class ICal: Mappable {

    private(set) var uid:           String?
    private(set) var summery:       String?
    private(set) var start:         NSDate?
    private(set) var end:           NSDate?
    private(set) var url:           String?
    private(set) var location:      String?
    private(set) var description:   String?
    private(set) var allday:        Bool?
    
    private var dateFormatter = NSDateFormatter()
    
    required init?(_ map: Map){
        self.dateFormatter.timeZone = NSTimeZone(name: "UTC+2")
    }

    // Mappable
    func mapping(map: Map) {
        uid         <-  map["uid"]
        summery     <-  map["summery"]
        start       <- (map["start"],   EventDateTransform())
        end         <- (map["end"],     EventDateTransform())
        url         <-  map["url"]
        location    <-  map["location"]
        description <-  map["description"]
        allday      <-  map["allday"]
    }

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
    
    var startOnlyDateString : String {
        dateFormatter.dateFormat = "dd.MM.yyy"
        return dateFormatter.stringFromDate(start!)
    }

    var startDateString : String {
        dateFormatter.dateFormat = "dd.MM.yyy - HH:mm"
        return dateFormatter.stringFromDate(start!)
    }

    var endDateString : String {
        dateFormatter.dateFormat = "dd.MM.yyy - HH:mm"
        return dateFormatter.stringFromDate(end!)
    }
    
    var isNow : Bool {
        if isToday {
            let now = NSDate()
            return (now.compare(start!) == NSComparisonResult.OrderedDescending &&
                now.compare(end!) == NSComparisonResult.OrderedAscending)
        } else {
            return false
        }
    }

    var isToday : Bool {
        return NSCalendar.currentCalendar().isDateInToday(start!)
    }

    var isOneDay : Bool {
        return NSCalendar.currentCalendar().isDate(start!, inSameDayAsDate: end!)
    }
    
    var getCustomColor : UIColor {
        if containsOpenLab(self.summery!) {
            return UIColor.fabLabBlue()
        } else if containsSelfLab(self.summery!) {
            return UIColor.fabLabGreen()
        } else {
            return UIColor.fabLabRed()
        }
    }

    private class EventDateTransform : DateFormatterTransform {
        init() {
            let formatter = NSDateFormatter()
            formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
            formatter.timeZone = NSTimeZone(name: "UTC")
            formatter.dateFormat = "yyyyMMdd'T'HHmmss'Z'"

            super.init(dateFormatter: formatter)
        }
    }
    
    private func containsOpenLab(string: String) -> Bool {
        return  (string.rangeOfString("Open") != nil || string.rangeOfString("open") != nil) &&
            (string.rangeOfString("Lab") != nil || string.rangeOfString("lab") != nil)
    }
    
    private func containsSelfLab(string: String) -> Bool {
        return  (string.rangeOfString("Self") != nil || string.rangeOfString("self") != nil) &&
            (string.rangeOfString("Lab") != nil || string.rangeOfString("lab") != nil)
    }
}

