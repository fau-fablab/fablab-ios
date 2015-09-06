
import Foundation
import ObjectMapper
import SwiftyJSON
import CoreData

class Settings : NSObject{
    
    let historyKey = "History"
    
    private let managedObjectContext : NSManagedObjectContext
    private let coreData = CoreDataHelper(sqliteDocumentName: "CoreDataModel.db", schemaName:"")
    

    
    private var entries : [SettingsEntry] {
        get {
            let request = NSFetchRequest(entityName: SettingsEntry.SettingsName)
            return managedObjectContext.executeFetchRequest(request, error: nil) as! [SettingsEntry]
        }
    }
    
    
    override init(){
        self.managedObjectContext = coreData.createManagedObjectContext()
        super.init()
    }
    

    
    func getValue(key:String) -> Bool?{
        for res in entries{
            if( res.key == key){
                return res.value
            }
        }
        return nil;
    }
    
    func updateOrCreate(key: String, value: Bool){
        if(!self.updateKeyValue(key, value: value)){
            self.createNewKeyValue(key, value: value);
        }
    }
    
    
    private func updateKeyValue(key: String, value: Bool) -> Bool{
        for res in entries{
            if( res.key == key){
                res.value = value;
                self.managedObjectContext.save(nil)
                return true
            }
        }
        return false
    }
    
    private func createNewKeyValue(key: String, value: Bool){
        let newKeyValue = NSEntityDescription.insertNewObjectForEntityForName(SettingsEntry.SettingsName,
            inManagedObjectContext: self.managedObjectContext) as! SettingsEntry
        newKeyValue.key = key
        newKeyValue.value = value
        self.managedObjectContext.save(nil)
    }
    
}