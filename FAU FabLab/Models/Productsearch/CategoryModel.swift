import Foundation
import ObjectMapper

class CategoryModel: NSObject {
    
    static let sharedInstance = CategoryModel()
    
    private let resource = "/products"
    private var mapper = Mapper<Product>()
    private var categories = [String]()
    private var isLoading = false
    private var categoriesLoaded = false
    
    private var supercategory: String!
    private var category: String!
    private var subcategories = [String]()
    private var showAll = false
    
    override init() {
        super.init()
        reset()
    }
    
    func reset() {
        showAll = false
        supercategory = ""
        category = "Alle Produkte"
        subcategories = getSubcategories(category)
    }
    
    //only for testing
    func fetchCategories(onCompletion: ApiResponse){
        
        let endpoint = resource + "/find/name"
        let params = ["search": ""]
        
        if(!isLoading && !categoriesLoaded){
            
            isLoading = true
            categories.removeAll(keepCapacity: false)
            
            RestManager.sharedInstance.makeJSONRequest(.GET, encoding: .URL, resource: endpoint, params: params, onCompletion: {
                json, err in
                if (err != nil) {
                    AlertView.showErrorView("Fehler bei der Produktsuche".localized)
                    onCompletion(err)
                    self.isLoading = false
                    return
                }
                if let productList = self.mapper.mapArray(json) {
                    for tmp in productList {
                        self.categories.append(tmp.categoryString!)
                        Debug.instance.log(tmp.categoryString)
                    }
                }
                self.reset()
                self.isLoading = false;
                self.categoriesLoaded = true
                onCompletion(nil);
                return
            })
            
        }
        
        reset()
        onCompletion(nil)
        return
        
    }
    
    //only for testing
    func getSubcategories(supercategory: String) -> [String] {
        
        var subcategories = [String]()
        
        let depth = split(supercategory, allowEmptySlices: false, isSeparator: {$0 == "/"}).count
        
        for category in categories  {
            
            let tmp = split(category, allowEmptySlices: false, isSeparator: {$0 == "/"})
            
            if tmp.count <= depth {
                continue
            }
            
            var subcategory = tmp[0]
            for index in 1...depth {
                subcategory += "/" + tmp[index]
            }
            
            if subcategory.hasSuffix(" ") {
                subcategory = dropLast(subcategory)
            }
            if subcategory.hasPrefix(" ") {
                subcategory = dropFirst(subcategory)
            }
            
            if let range = subcategory.rangeOfString(supercategory) {
                if !contains(subcategories, subcategory) {
                    subcategories.append(subcategory)
                }
            }
        }
        
        return subcategories
        
    }
    
    func getNumberOfSections() -> Int {
        return 2
    }
    
    func getNumberOfRowsInSection(section: Int) -> Int {
        if section == 0 && !subcategories.isEmpty {
            return 1
        }
        return subcategories.count
    }
    
    func getTitleOfSection(section: Int) -> String {
        return ""
    }
    
    func setCategory(section: Int, row: Int) {
        if section == 0 {
            showAll = true
            return
        }
        supercategory = category
        category = subcategories[row]
        subcategories = getSubcategories(category)
    }
    
    func getNameOfCategory(section: Int, row: Int) -> String {
        if section == 0 {
            return "Alle anzeigen".localized
        }
        let tmp = split(subcategories[row], allowEmptySlices: false, isSeparator: {$0 == "/"})
        var name = tmp[tmp.count - 1]
        if name.hasPrefix(" ") {
            name = dropFirst(name)
        }
        return name
    }
    
    func getNameOfCategory(category: String) -> String {
        if category.isEmpty {
            return ""
        }
        let tmp = split(category, allowEmptySlices: false, isSeparator: {$0 == "/"})
        var name = tmp[tmp.count - 1]
        if name.hasPrefix(" ") {
            name = dropFirst(name)
        }
        return name
    }
    
    func hasSubcategories() -> Bool {
        if showAll {
            return false
        }
        return !subcategories.isEmpty
    }
    
    func getCategory() -> String {
        return category
    }
    
}
