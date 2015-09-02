import Foundation
import SwiftyJSON
import CoreData

typealias ProductNamesLoadFinished = (NSError?) -> Void

class AutocompleteModel : NSObject {
    
    static let sharedInstance = AutocompleteModel()
    
    private let managedObjectContext : NSManagedObjectContext
    private let coreData = CoreDataHelper(sqliteDocumentName: "CoreDataModel.db", schemaName:"")
    private let resource = "/products/autocompletions"
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
            fetchAutocompleteSuggestions({err in })
        }
    }
    
    func getAutocompleteSuggestions() -> [String] {
        var suggestions = [String]()
        for suggestion in autocompleteSuggestions {
            suggestions.append(suggestion.name)
        }
        return suggestions
    }
    
    private func fetchAutocompleteSuggestions(onCompletion: ProductNamesLoadFinished) {
        let params = ["search": ""]
        if (!isLoading) {
            isLoading = true
            RestManager.sharedInstance.makeJsonGetRequest(resource, params: params, onCompletion: {
                json, err in
                if (err != nil) {
                    Debug.instance.log(err)
                } else {
                    self.addAutocompleteSuggestions(json as! [String])
                }
                onCompletion(err)
                self.isLoading = false
            })
        }
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