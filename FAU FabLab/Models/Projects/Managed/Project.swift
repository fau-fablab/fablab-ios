
import Foundation
import CoreData

class Project : NSManagedObject {
    
    static let EntityName = "Projects"
    
    @NSManaged var descr: String
    @NSManaged var filename: String
    @NSManaged var content: String
}