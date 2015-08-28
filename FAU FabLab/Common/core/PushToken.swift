import Foundation

class PushToken : NSObject {
    
    static var token = ""
    static var platformType = "APPLE"
    
    static func serialize() -> NSDictionary{
        return ["token" : PushToken.token, "platformType" : PushToken.platformType]
    }
}
