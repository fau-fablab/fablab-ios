import Foundation
import CoreData

class HistoryEntry: NSManagedObject {
    
    static let EntityName = "HistoryEntry"
    
    @NSManaged var word: String
    @NSManaged var date: NSDate
    
}