import Foundation
import CoreData

class SettingsEntry : NSManagedObject{
    
    static let SettingsName = "Settings"
    
    @NSManaged var key: String
    @NSManaged var value: Bool
    
    
}