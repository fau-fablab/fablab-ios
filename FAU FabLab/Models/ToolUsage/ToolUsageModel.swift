import Foundation
import CoreData

class ToolUsageModel: NSObject {
    
    static let sharedInstance = ToolUsageModel()
    
    private let api = ToolUsageApi()
    private let coreData = CoreDataHelper(sqliteDocumentName: "CoreDataModel.db", schemaName:"")
    private let managedObjectContext : NSManagedObjectContext
    
    private var toolUsages = [ToolUsage]()
    private var isLoading = false
    
    private var ownToolUsages: [OwnToolUsage] {
        get {
            let request = NSFetchRequest(entityName: OwnToolUsage.EntityName)
            return (try! managedObjectContext.executeFetchRequest(request)) as! [OwnToolUsage]
        }
    }
    
    override init(){
        self.managedObjectContext = coreData.createManagedObjectContext()
        super.init()
    }
    
    func fetchToolUsagesForTool(toolId: Int64, onCompletion: ApiResponse) {
        if isLoading {
            onCompletion(nil)
            return
        }
        
        isLoading = true
        
        api.getUsageForTool(toolId, onCompletion: {
            (result, error) -> Void in
            if error != nil {
                AlertView.showErrorView("Fehler beim Laden der Reservierungen".localized)
            } else if let result = result {
                self.toolUsages = result
            }
            
            self.isLoading = false
            onCompletion(error)
        })
        
    }
    
    func addToolUsage(toolUsage: ToolUsage, user: User?, token: String, onCompletion: ApiResponse) {
        if isLoading {
            onCompletion(nil)
            return
        }
        
        isLoading = true
        
        api.addUsage(user, token: token, toolId: toolUsage.toolId!, usage: toolUsage) {
            (result, error) -> Void in
            if error != nil {
                AlertView.showErrorView("Fehler beim Hinzufügen der Reservierung".localized)
            } else if let result = result {
                self.addOwnToolUsage(result.id!)
            }
            self.isLoading = false
            onCompletion(error)
        }
    }
    
    func removeToolUsage(toolUsage: ToolUsage, user: User?, token: String, onCompletion: ApiResponse) {
        if isLoading {
            onCompletion(nil)
            return
        }
        
        isLoading = true
        
        api.removeUsage(user, token: token, toolId: toolUsage.toolId!, usageId: toolUsage.id!) {
            (error) -> Void in
            if error != nil {
                AlertView.showErrorView("Fehler beim Löschen der Reservierung".localized)
            } else {
                self.removeOwnToolUsage(toolUsage.toolId!)
            }
            self.isLoading = false
            onCompletion(error)
        }
    }
    
    func getCount() -> Int {
        return toolUsages.count
    }
    
    func getToolUsage(index: Int) -> ToolUsage {
        return toolUsages[index]
    }
    
    //in seconds
    func getStartingTimeOfToolUsage(index: Int) -> Int64 {
        if index == 0 {
            return (toolUsages[0].creationTime!)/1000
        } else if index == 1 {
            return ((toolUsages[0].creationTime!)+(toolUsages[0].duration!*60*1000))/1000
        }
        var time = toolUsages[0].creationTime!
        for i in 0...index-1 {
            time = time + (toolUsages[i].duration!*60*1000)
        }
        return time/1000
    }
    
    func addOwnToolUsage(toolUsageId: Int64) {
        let ownToolUsage = NSEntityDescription.insertNewObjectForEntityForName(OwnToolUsage.EntityName,
            inManagedObjectContext: self.managedObjectContext) as! OwnToolUsage
        ownToolUsage.id = toolUsageId
        saveCoreData()
    }
    
    func isOwnToolUsage(toolUsageId: Int64) -> Bool {
        for ownToolUsage in ownToolUsages {
            if ownToolUsage.id == toolUsageId {
                return true
            }
        }
        return false
    }
    
    func removeOwnToolUsage(toolUsageId: Int64) {
        for ownToolUsage in ownToolUsages {
            if ownToolUsage.id == toolUsageId {
                managedObjectContext.deleteObject(ownToolUsage)
            }
        }
        saveCoreData()
    }
    
    private func saveCoreData() {
        var error : NSError?
        do {
            try self.managedObjectContext.save()
        } catch let error1 as NSError {
            error = error1
            Debug.instance.log("Error saving: \(error!)")
        }
    }
    
}