import ObjectMapper

//  This custom TransformTyp fixes the mapping of Int64
//  see https://github.com/Hearst-DD/ObjectMapper/issues/130
public class Int64Transform : TransformType{
    public typealias Object = Int64
    public typealias JSON = NSNumber
    
    public init() {}
    
    public func transformFromJSON(value: AnyObject?) -> Int64? {
        if let number = value as? NSNumber {
            return number.longLongValue
        }
        return nil
    }
    
    public func transformToJSON(value: Int64?) -> NSNumber? {
        if let number = value {
            return NSNumber(longLong: number)
        }
        return nil
    }
}
