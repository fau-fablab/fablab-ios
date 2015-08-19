import Foundation
import SwiftyJSON

typealias ProductNamesLoadFinished = (NSError?) -> Void

class AutocompleteModel : NSObject {
    
    static let sharedInstance = AutocompleteModel()
    
    private let resource = "/products/names"
    private var productNames = [String]()
    private var productNamesLoaded = false
    private var isLoading = false
    private var autocompleteSuggestions = [String]()
    private var autocompleteSuggestionsCreated = false
    
    override init(){
        super.init()
    }
    
    func loadAutocompleteSuggestion() {
        //TODO store autocomplete suggestions and reload them every 24 hours
        fetchProductNames({err in
            if(err == nil) {
                self.createAutocompleteSuggestions()
            }
        })
    }
    
    func getAutocompleteSuggestions() -> [String] {
        return autocompleteSuggestions
    }
    
    private func fetchProductNames(onCompletion: ProductNamesLoadFinished) {
        let params = ["search": ""]
        if (!isLoading && !productNamesLoaded) {
            isLoading = true
            clearProductNames()
            RestManager.sharedInstance.makeJsonGetRequest(resource, params: params, onCompletion: {
                json, err in
                if (err != nil) {
                    Debug.instance.log(err)
                } else {
                    self.productNames = json as! [String]
                    self.productNamesLoaded = true
                }
                onCompletion(err)
                self.isLoading = false
            })
        }
    }
    
    private func createAutocompleteSuggestions() {
        for name in productNames {
            var tmpName = name.stringByReplacingOccurrencesOfString(",", withString: " ")
                .stringByReplacingOccurrencesOfString("(", withString: " ")
                .stringByReplacingOccurrencesOfString(")", withString: " ")
                .stringByReplacingOccurrencesOfString("_", withString: " ")
                .stringByReplacingOccurrencesOfString("-", withString: " ")
            var separatedName = split(tmpName, isSeparator: {$0 == " "})
            for string in separatedName {
                if (count(string) > 2) {
                    var found = false
                    for suggestion in autocompleteSuggestions {
                        if (suggestion.lowercaseString == string.lowercaseString) {
                            found = true
                        }
                    }
                    if (!found) {
                        autocompleteSuggestions.append(string)
                    }
                }
            }
        }
        autocompleteSuggestionsCreated = true
        Debug.instance.log(autocompleteSuggestions)
    }
    
    
    
    private func addProductName(productName: String) {
        productNames.append(productName)
    }
    
    private func clearProductNames() {
        productNames.removeAll(keepCapacity: false)
    }
    
}