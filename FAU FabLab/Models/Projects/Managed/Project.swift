
import Foundation
import CoreData

class Project : NSManagedObject {
    
    static let EntityName = "Projects"
    
    @NSManaged var description: String
    @NSManaged var filename: String
    @NSManaged var content: String
    
    
}