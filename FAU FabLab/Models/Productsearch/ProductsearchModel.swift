import Foundation
import ObjectMapper
import SwiftyJSON

class ProductsearchModel : NSObject{
    
    private enum Sorting {
        case Unsorted
        case SortedByName
        case SortedByPrice
    }
    
    private let collation = UILocalizedIndexedCollation.currentCollation() as! UILocalizedIndexedCollation
    private let resource = "/products"
    private var mapper = Mapper<Product>()
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
        let endpoint = resource + "/find/name"
        let params = ["search": name]
        if(!isLoading){
            removeAllProducts()
            sorting = Sorting.Unsorted
            RestManager.sharedInstance.makeJsonGetRequest(endpoint, params: params, onCompletion: {
                json, err in
                if (err != nil) {
                    AlertView.showErrorView("Fehler bei der Produktsuche".localized)
                    onCompletion(err)
                }
                if let productList = self.mapper.mapArray(json) {
                    for tmp in productList {
                        Debug.instance.log(tmp.name!)
                        self.products.append(tmp)
                    }
                    self.sectionedProducts.removeAll(keepCapacity: false)
                    self.sectionedProducts.append(self.products)
                }
                onCompletion(nil);
                self.isLoading = false;
            })

        }
    }
    
    func searchProductById(id:String, onCompletion: ApiResponse){
        let endpoint = resource + "/find/id"
        let params = ["search": id]
        if(!isLoading){
            removeAllProducts()
            sorting = Sorting.Unsorted
            RestManager.sharedInstance.makeJsonGetRequest(endpoint, params: params, onCompletion: {
                json, err in
                Debug.instance.log("GOT: \(json)")
                
                if (err != nil) {
                    AlertView.showErrorView("Fehler bei der Produktsuche".localized)
                    onCompletion(err)
                }
                if let product = self.mapper.map(json) {
                    Debug.instance.log(product.name!)
                    self.products.append(product)
                    self.sectionedProducts.append(self.products)
                }
                onCompletion(nil);
                self.isLoading = false;
            })
            
        }
    }

}
