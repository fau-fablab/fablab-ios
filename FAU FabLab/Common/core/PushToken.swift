import Foundation

class PushToken : NSObject {
    
    static var token = ""
    
    static func serialize() -> NSDictionary{
        return ["token" : PushToken.token, "platformType" : "\(PlatformType.APPLE)"]
    }
}
