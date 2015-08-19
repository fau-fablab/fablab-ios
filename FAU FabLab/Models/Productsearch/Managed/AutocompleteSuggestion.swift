import Foundation
import CoreData

class AutocompleteSuggestion : NSManagedObject{
    
    static let EntityName = "AutocompleteSuggestion"
    
    @NSManaged var name: String
    @NSManaged var lastRefresh: NSDate
    
}