
import Foundation
import CoreData

class ProjectsModel: NSObject {

    static let sharedInstance = ProjectsModel()
    
    private let coreData = CoreDataHelper(sqliteDocumentName: "CoreDataModel.db", schemaName: "")
    private let managedObjectContext: NSManagedObjectContext
    
    private var projects: [Project] {
        get {
            let request = NSFetchRequest(entityName: Project.EntityName)
            let sortDescriptor = NSSortDescriptor(key: "filename", ascending: true)
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
    
    func getProject(id: Int) -> Project {
        return projects[id]
    }
    
    func addProject(#description: String, filename: String, content: String, gistId: String) {
        let project = NSEntityDescription.insertNewObjectForEntityForName(Project.EntityName,
            inManagedObjectContext: self.managedObjectContext) as! Project
        project.descr = description
        project.filename = filename
        project.content = content
        project.gistId = gistId
        saveCoreData()
        Debug.instance.log(projects)
    }
    
    func updateProject(#id: Int, description: String, filename: String, content: String) {
        let project = getProject(id)
        project.descr = description
        project.filename = filename
        project.content = content
        saveCoreData()
    }
    
    func updateGistId(#id: Int, gistId: String) {
        let project = getProject(id)
        project.gistId = gistId
        saveCoreData()
    }
    
    func getGistId(id: Int) -> String {
        let project = getProject(id)
        return project.gistId
    }
    
    func removeProject(id: Int) {
        managedObjectContext.deleteObject(projects[id])
        saveCoreData()
    }
}