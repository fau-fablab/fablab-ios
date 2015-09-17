import Foundation
import CoreData

class CategoryEntity: NSManagedObject {
    
    static let EntityName = "CategoryEntity"
    
    @NSManaged var categoryId: Int
    @NSManaged var name: String
    @NSManaged var supercategory: CategoryEntity?
    @NSManaged var subcategories: NSOrderedSet?
    @NSManaged var date: NSDate
    
    func getNumberOfSubcategories() -> Int {
        if subcategories != nil {
            return subcategories!.count
        }
        
        return 0
    }
    
    func getSubcategory(index: Int) -> CategoryEntity {
        var items = self.mutableOrderedSetValueForKey("subcategories")
        return items[index] as! CategoryEntity
    }
    
    func addSubcategory(subcategory: CategoryEntity) {
        var items = self.mutableOrderedSetValueForKey("subcategories")
        items.addObject(subcategory)
    }
    
}


