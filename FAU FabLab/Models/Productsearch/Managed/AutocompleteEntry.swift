import Foundation
import CoreData

class AutocompleteEntry: NSManagedObject {
    
    static let EntityName = "AutocompleteEntry"
    
    @NSManaged var word: String
    @NSManaged var date: NSDate
    
}