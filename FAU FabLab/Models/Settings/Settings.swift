
import Foundation
import ObjectMapper
import SwiftyJSON
import CoreData

class Settings : NSObject{
    
    private let managedObjectContext : NSManagedObjectContext
    private let coreData = CoreDataHelper(sqliteDocumentName: "CoreDataModel.db", schemaName:"")
    

    
    private var entries : [SettingsEntry] {
        get {
            let request = NSFetchRequest(entityName: SettingsEntry.SettingsName)
            return managedObjectContext.executeFetchRequest(request, error: nil) as! [SettingsEntry]
        }
    }
    
    func saveCoreData() {
        var error : NSError?
        if !self.managedObjectContext.save(&error) {
            Debug.instance.log("Error saving: \(error!)")
        }
    }
    
    override init(){
        self.managedObjectContext = coreData.createManagedObjectContext()
        super.init()
    }
    

    func updateEntry(position: Int, value: Bool) {
        entries[position].value = value
        saveCoreData()
    }
    
    func getEntry(position:Int) -> SettingsEntry{
        return entries[position];
    }
    
    
}