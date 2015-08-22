import Foundation
import SwiftyJSON
import CoreData

typealias ProductNamesLoadFinished = (NSError?) -> Void

class AutocompleteModel : NSObject {
    
    static let sharedInstance = AutocompleteModel()
    
    private let managedObjectContext : NSManagedObjectContext
    private let coreData = CoreDataHelper(sqliteDocumentName: "CoreDataModel.db", schemaName:"")
    private let resource = "/products/names"
    private var productNames = [String]()
    private var productNamesLoaded = false
    private var isLoading = false
    
    //24 hours, in seconds
    private let refreshInterval : Double = 24*60*60
    
    private var autocompleteSuggestions : [AutocompleteSuggestion] {
        get {
            let reqeust = NSFetchRequest(entityName: AutocompleteSuggestion.EntityName)
            return managedObjectContext.executeFetchRequest(reqeust, error: nil) as! [AutocompleteSuggestion]
        }
    }
    
    override init(){
        self.managedObjectContext = coreData.createManagedObjectContext()
        super.init()
    }
    
    func loadAutocompleteSuggestion() {
        if(autocompleteSuggestions.isEmpty || Double(NSDate().timeIntervalSinceDate(autocompleteSuggestions[0].lastRefresh)) >= refreshInterval) {
            fetchProductNames({err in
                if(err == nil) {
                    self.createAutocompleteSuggestions()
                }
            })
        }
    }
    
    func getAutocompleteSuggestions() -> [String] {
        var suggestions = [String]()
        for suggestion in autocompleteSuggestions {
            suggestions.append(suggestion.name)
        }
        return suggestions
    }
    
    private func fetchProductNames(onCompletion: ProductNamesLoadFinished) {
        let params = ["search": ""]
        if (!isLoading && !productNamesLoaded) {
            isLoading = true
            productNames.removeAll(keepCapacity: false)
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
        var suggestions = [String]()
        let digits = NSCharacterSet.decimalDigitCharacterSet()
        for name in productNames {
            var tmpName = name.stringByReplacingOccurrencesOfString(",", withString: " ")
                .stringByReplacingOccurrencesOfString("(", withString: " ")
                .stringByReplacingOccurrencesOfString(")", withString: " ")
                .stringByReplacingOccurrencesOfString("_", withString: " ")
                .stringByReplacingOccurrencesOfString("-", withString: " ")
                .stringByReplacingOccurrencesOfString("\"", withString: " ")
                .stringByReplacingOccurrencesOfString("/", withString: " ")
                .stringByReplacingOccurrencesOfString("=", withString: " ")
                .stringByReplacingOccurrencesOfString("+", withString: " ")
                .stringByReplacingOccurrencesOfString("?", withString: " ")
                .stringByReplacingOccurrencesOfString(":", withString: " ")
                .stringByReplacingOccurrencesOfString("&", withString: " ")
                .stringByReplacingOccurrencesOfString("≥", withString: " ")
                .stringByReplacingOccurrencesOfString("Ø", withString: " ")
            var separatedName = split(tmpName, isSeparator: {$0 == " " || $0 == " "})
            for string in separatedName {
                if (count(string) > 2) {
                    var found = false
                    var digitPrefix = false
                    for char in string.unicodeScalars {
                        if digits.longCharacterIsMember(char.value) {
                            digitPrefix = true
                            break;
                        }
                    }
                    if (digitPrefix) {
                        continue
                    }
                    for suggestion in suggestions {
                        if (suggestion.lowercaseString == string.lowercaseString) {
                            found = true
                        }
                    }
                    if (!found) {
                        suggestions.append(string)
                    }
                }
            }
        }
        addAutocompleteSuggestions(suggestions)
    }
    
    private func addAutocompleteSuggestions(strings: [String]) {
        clearAutocompleteSuggestions()
        for string in strings {
            let suggestion = NSEntityDescription.insertNewObjectForEntityForName(AutocompleteSuggestion.EntityName, inManagedObjectContext: self.managedObjectContext) as! AutocompleteSuggestion
            suggestion.name = string
            suggestion.lastRefresh = NSDate()
        }
        saveCoreData()
    }
    
    private func clearAutocompleteSuggestions() {
        for suggestion in autocompleteSuggestions {
            managedObjectContext.deleteObject(suggestion)
        }
    }
    
    private func saveCoreData() {
        var error : NSError?
        if !self.managedObjectContext.save(&error) {
            Debug.instance.log("Error saving: \(error!)")
        }
    }

    
}