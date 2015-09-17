import Foundation

class CategoryModel: NSObject {
    
    static let sharedInstance = CategoryModel()
    
    private let api = CategoryApi()
    private var isLoading = false
    private var categoriesLoaded = false
    private var categories = [Category]()
    private var category: Category!
    private var showAll = false
    
    func fetchCategories(onCompletion: ApiResponse) {
        if isLoading || categoriesLoaded {
            return
        }
        
        isLoading = true
        categories.removeAll(keepCapacity: false)
        
        api.findAll { (categories, error) -> Void in
            if error != nil {
                AlertView.showErrorView("Fehler bei der Produktsuche".localized)
                onCompletion(error)
            } else if categories != nil {
                self.categoriesLoaded = true
                self.categories = categories!
                self.reset()
                onCompletion(nil)
            }
            self.isLoading = false
        }
    }
    
    func reset() {
        showAll = false
        category = findRootCategory()
    }
    
    private func findRootCategory() -> Category? {
        for category in categories {
            if category.parentCategoryId == 0 {
                return category
            }
        }
        
        return nil
    }
    
    private func findCategoryById(id: Int) -> Category? {
        for category in categories {
            if category.categoryId == id {
                return category
            }
        }
        
        return nil
    }
    
    func getCategory() -> Category? {
        return category
    }
    
    func setCategory(category: Category) {
        self.category = category
    }
    
    func setCategory(section: Int, row: Int) {
        if section == 0 {
            showAll = true
            return
        }
        
        if category != nil && category.categories != nil {
            category = findCategoryById(category.categories![row])
        }
    }
    
    func getSubcategory(section: Int, row: Int) -> Category? {
        if section == 0 {
            return category
        }
        
        if category != nil && category.categories != nil {
            return findCategoryById(category.categories![row])
        }
        
        return nil
    }
    
    func getSupercategory() -> Category? {
        if category != nil {
            return findCategoryById(category.parentCategoryId!)
        }
        
        return nil
    }
    
    func getNumberOfSections() -> Int {
        return 2
    }
    
    func getNumberOfRowsInSection(section: Int) -> Int {
        if section == 0 && categoriesLoaded {
            return 1
        }
        
        if category != nil && category.categories != nil {
            return category.categories!.count
        }
        
        return 0
    }
    
    func getTitleOfSection(section: Int) -> String {
        return ""
    }
    
    func hasSubcategories() -> Bool {
        if showAll {
            return false
        }
        
        if category != nil {
            return category.categories != nil && category.categories?.count > 0
        }
        
        return false
    }
    
    func hasSupercategory() -> Bool {
        if category != nil {
            return category.parentCategoryId != 0
        }
        
        return false
    }
    
}

