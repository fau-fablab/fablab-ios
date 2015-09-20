import Foundation
import CoreData

class CategoryModel: NSObject {
    
    static let sharedInstance = CategoryModel()
    
    private let api = CategoryApi()
    private let managedObjectContext: NSManagedObjectContext
    private let coreData = CoreDataHelper(sqliteDocumentName: "CoreDataModel.db", schemaName:"")
    private let refreshInterval: Double = 24*60*60
    
    private var isLoading = false
    private var categoryEntity: CategoryEntity!
    
    private var categoryEntities : [CategoryEntity] {
        get {
            let request = NSFetchRequest(entityName: CategoryEntity.EntityName)
            let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [sortDescriptor]
            return managedObjectContext.executeFetchRequest(request, error: nil) as! [CategoryEntity]
        }
    }
    
    override init() {
        managedObjectContext = coreData.createManagedObjectContext()
        super.init()
    }
    
    func reset() {
        categoryEntity = findRootCategory()
    }
    
    func fetchCategories(onCompletion: ApiResponse) {
        if (isLoading || (!categoryEntities.isEmpty && Double(NSDate()
                .timeIntervalSinceDate(categoryEntities[0].date)) < refreshInterval)) {
            return
        }
        
        isLoading = true
        
        api.findAll { (categories, error) -> Void in
            if error != nil {
                AlertView.showErrorView("Fehler bei der Produktsuche".localized)
                onCompletion(error)
            } else if categories != nil {
                self.addCategories(categories!)
                self.reset()
                onCompletion(nil)
            }
            NSNotificationCenter.defaultCenter().postNotificationName("CategoriesLoadedNotification", object: nil)
            self.isLoading = false
        }
    }
        
    private func addCategories(categories: [Category]) {
        removeCategories()
        //insert categories
        for category in categories {
            let categoryEntity = NSEntityDescription.insertNewObjectForEntityForName(CategoryEntity.EntityName,
                inManagedObjectContext: self.managedObjectContext) as! CategoryEntity
            categoryEntity.categoryId = category.categoryId!
            categoryEntity.name = category.name!
            categoryEntity.date = NSDate()
        }
        saveCoreData()
        //update relationships
        for category in categories {
            if let categoryEntity = findCategoryById(category.categoryId!) {
                categoryEntity.supercategory = findCategoryById(category.parentCategoryId!)
            }
        }
        saveCoreData()
    }
    
    private func removeCategories() {
        for categoryEntity in categoryEntities {
            managedObjectContext.deleteObject(categoryEntity)
        }
    }
    
    private func saveCoreData() {
        var error : NSError?
        if !self.managedObjectContext.save(&error) {
            Debug.instance.log("Error saving: \(error!)")
        }
    }
    
    private func findRootCategory() -> CategoryEntity? {
        for categoryEntity in categoryEntities {
            if categoryEntity.categoryId == 1 {
                return categoryEntity
            }
        }
        
        return nil
    }
    
    private func findCategoryById(id: Int64) -> CategoryEntity? {
        for categoryEntity in categoryEntities {
            if categoryEntity.categoryId == id {
                return categoryEntity
            }
        }
        
        return nil
    }
    
    func getCategory() -> CategoryEntity? {
        return categoryEntity
    }
    
    func setCategory(categoryEntity: CategoryEntity) {
        self.categoryEntity = categoryEntity
    }
    
    func hasSubcategories() -> Bool {
        if categoryEntity != nil {
            return categoryEntity.getNumberOfSubcategories() > 0
        }
        
        return false
    }
    
    func getNumberOfSubcategories() -> Int {
        if categoryEntity != nil {
            return categoryEntity.getNumberOfSubcategories()
        }
        
        return 0
    }
    
    func getSubcategory(index: Int) -> CategoryEntity? {
        if categoryEntity != nil && categoryEntity.getNumberOfSubcategories() > 0 {
            return categoryEntity.getSubcategory(index)
        }
        
        return nil
    }
    
    func hasSupercategory() -> Bool {
        if categoryEntity != nil {
            return categoryEntity.supercategory != nil
        }
        
        return false
    }
    
    func getSupercategory() -> CategoryEntity? {
        if categoryEntity != nil {
            return categoryEntity.supercategory
        }
        
        return nil
    }
    
}

