import Foundation
import CoreData

public class CoreDataHelper : NSObject {
    
    let managedObjectModel : NSManagedObjectModel
    let persistentStoreCoordinator : NSPersistentStoreCoordinator
    
    private init(storeType : String, documentName : String?, schemaName : String, options : [NSObject : AnyObject]?) {
        
        let bundle = NSBundle(forClass:object_getClass(CoreDataHelper))
        var modelURL = bundle.URLForResource(schemaName, withExtension: "mom")
        if (modelURL == nil) {
            modelURL = bundle.URLForResource(schemaName, withExtension: "momd")
        }
        managedObjectModel = NSManagedObjectModel(contentsOfURL: modelURL!)!
        
        var storeURL : NSURL?
        if (storeType != NSInMemoryStoreType) {
            storeURL = CoreDataHelper.applicationDocumentsDirectory().URLByAppendingPathComponent(documentName!)
            NSLog("%@", storeURL!.path!);
        }
        
        persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        do{
            try self.persistentStoreCoordinator.addPersistentStoreWithType(storeType, configuration: nil, URL: storeURL, options: options)
            
        }catch _{
            NSLog("Unresolved error")
            abort()
        }
    }
    
    public convenience init(sqliteDocumentName : String, schemaName : String) {
        let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
        self.init(storeType: NSSQLiteStoreType, documentName: sqliteDocumentName, schemaName: schemaName, options: options)
    }
    
    public convenience init(inMemorySchemaName : String) {
        let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
        self.init(storeType: NSInMemoryStoreType, documentName: nil, schemaName: inMemorySchemaName, options: options)
    }
    
    private class func applicationDocumentsDirectory() -> NSURL {
        return NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last!
    }
    
    public func createManagedObjectContext() -> NSManagedObjectContext {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        return managedObjectContext
    }
    
}