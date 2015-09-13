
import Foundation
import CoreData

class ProjectsModel: NSObject {
    
    static let sharedInstance = ProjectsModel()
    
    private let coreData = CoreDataHelper(sqliteDocumentName: "CoreDataModel.db", schemaName: "")
    private let managedObjectContext: NSManagedObjectContext
    
    private var projects: [Project] {
        get {
            let request = NSFetchRequest(entityName: Project.EntityName)
            let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
            request.sortDescriptors = [sortDescriptor]
            return managedObjectContext.executeFetchRequest(request, error: nil) as! [Project]
        }
    }
    
    override init() {
        managedObjectContext = coreData.createManagedObjectContext()
        super.init()
    }
    
    private func saveCoreData() {
        var error: NSError?
        if !managedObjectContext.save(&error) {
            Debug.instance.log("Error saving: \(error!)")
        }
    }
    
    func getCount() -> Int {
        return projects.count
    }
    
    func getProject(index: Int) -> Project {
        return projects[index]
    }
    
    func addProject(#description: String, filename: String, content: String) {
        let project = NSEntityDescription.insertNewObjectForEntityForName(Project.EntityName,
            inManagedObjectContext: self.managedObjectContext) as! Project
        project.description = ""
        project.filename = ""
        project.content = ""
        saveCoreData()
        Debug.instance.log(projects)
    }
    
    func removeProject(index: Int) {
        managedObjectContext.deleteObject(projects[index])
        saveCoreData()
    }
    
}