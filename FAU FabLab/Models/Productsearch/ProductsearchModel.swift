import Foundation
import ObjectMapper
import SwiftyJSON

class ProductsearchModel : NSObject{
    
    private enum Sorting {
        case Unsorted
        case SortedByName
        case SortedByPrice
    }
    
    private let api = ProductApi()
    
    private let collation = UILocalizedIndexedCollation.currentCollation() as! UILocalizedIndexedCollation

    private var products = [Product]()
    private var sectionedProducts = [[Product]]()
    private var isLoading = false
    private var sorting = Sorting.Unsorted
    

    override init(){
        super.init()
    }
    
    func getFirstProduct() -> Product{
        return products.first!
    }
    
    func getNumberOfProducts() -> Int {
        var count = 0
        for section in sectionedProducts {
            count += section.count
        }
        return count
    }
    
    func getNumberOfSections() -> Int {
        return sectionedProducts.count
    }
    
    func getNumberOfRowsInSection(section: Int) -> Int {
        return sectionedProducts[section].count
    }
    
    func getTitleOfSection(section: Int) -> String {
        if (sorting == Sorting.SortedByName && !sectionedProducts[section].isEmpty) {
            return (collation.sectionTitles[section] as? String)!
        }
        return ""
    }
    
    func getSectionIndexTitles() -> [AnyObject] {
        if (sorting == Sorting.SortedByName) {
            return collation.sectionIndexTitles
        }
        return []
    }
    
    func getSectionForSectionIndexTitleAtIndex(index: Int) -> Int {
        if (sorting == Sorting.SortedByName) {
            return collation.sectionForSectionIndexTitleAtIndex(index)
        }
        return 0
    }
    
    func getProduct(section: Int, row: Int) -> Product {
        return sectionedProducts[section][row]
    }
    
    func removeAllProducts() {
        products.removeAll(keepCapacity: false)
        sectionedProducts.removeAll(keepCapacity: false)
    }
    
    func sortProductsByName() {
        if (sorting == Sorting.SortedByName) {
            return
        }
        //section products
        let selector: Selector = "name"
        sectionedProducts.removeAll(keepCapacity: false)
        sectionedProducts = [[Product]](count: self.collation.sectionTitles.count, repeatedValue: []);
        for index in 0..<products.count {
            var sectionIndex = self.collation.sectionForObject(products[index], collationStringSelector: selector)
            sectionedProducts[sectionIndex].append(products[index])
        }
        //sort products
        for index in 0..<sectionedProducts.count {
            sectionedProducts[index] = collation.sortedArrayFromArray(sectionedProducts[index], collationStringSelector: selector) as! [Product]
        }
        sorting = Sorting.SortedByName
    }
    
    func sortProductsByPrice() {
        if (sorting == Sorting.SortedByPrice) {
            return
        }
        //section and sort products
        sectionedProducts.removeAll(keepCapacity: false)
        var sortedProducts = products
        sortedProducts.sort({$0.price < $1.price})
        sectionedProducts.append(sortedProducts)
        sorting = Sorting.SortedByPrice
    }
    
    func searchProductByName(name:String, onCompletion: ApiResponse){
        if(isLoading){
            return
        }
        
        isLoading = true
        removeAllProducts()
        sorting = Sorting.Unsorted
            
        api.findByName(name, limit: 0, offset: 0,
            onCompletion: { results, err in
                if(err != nil){
                    AlertView.showErrorView("Fehler bei der Produktsuche".localized)
                    onCompletion(err)
                }
                else if let results = results{
                    for product in results {
                        self.products.append(product)
                    }
                    self.sectionedProducts.removeAll(keepCapacity: false)
                    self.sectionedProducts.append(self.products)
                }
                onCompletion(nil)
                self.isLoading = false
        })
    }
    
    func searchProductById(id:String, onCompletion: ApiResponse){
        if(isLoading){
            return
        }
        isLoading = true
        removeAllProducts()
        sorting = Sorting.Unsorted
        
        api.findById(id, onCompletion: { result, err in
            if(err != nil){
                AlertView.showErrorView("Fehler bei der Produktsuche".localized)
                onCompletion(err)
            }
            else if let result = result{
                Debug.instance.log(result.name!)
                self.products.append(result)
                self.sectionedProducts.append(self.products)
            }
            onCompletion(nil);
            self.isLoading = false;
        })
    }
    
    func searchProductByCategory(category: String, onCompletion: ApiResponse) {
        if (isLoading) {
            return
        }
        isLoading = true
        removeAllProducts()
        sorting = Sorting.Unsorted
        
        api.findByCategory(category, limit: 0, offset: 0, onCompletion: { results, err in
            if (err != nil) {
                AlertView.showErrorView("Fehler bei der Produktsuche".localized)
                onCompletion(err)
            }
            if let results = results {
                for product in results {
                    Debug.instance.log(product.name!)
                    self.products.append(product)
                }
                self.sectionedProducts.removeAll(keepCapacity: false)
                self.sectionedProducts.append(self.products)
            }
            onCompletion(nil)
            self.isLoading = false
        })
    }
}
