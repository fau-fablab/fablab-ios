import Foundation
import SwiftyJSON
import CoreData

class Autocomplete: NSObject {
    
    private let resource = "/products/autocompletions"
    private let managedObjectContext : NSManagedObjectContext
    private let coreData = CoreDataHelper(sqliteDocumentName: "CoreDataModel.db", schemaName:"")
    //24 hours, in seconds
    private let refreshInterval : Double = 24*60*60
    
    private var isLoading = false
    
    private var entries : [AutocompleteEntry] {
        get {
            let reqeust = NSFetchRequest(entityName: AutocompleteEntry.EntityName)
            return managedObjectContext.executeFetchRequest(reqeust, error: nil) as! [AutocompleteEntry]
        }
    }
    
    override init(){
        self.managedObjectContext = coreData.createManagedObjectContext()
        super.init()
    }
    
    private func saveCoreData() {
        var error : NSError?
        if !self.managedObjectContext.save(&error) {
            Debug.instance.log("Error saving: \(error!)")
        }
    }
    
    func fetchEntries() {
        if(entries.isEmpty || Double(NSDate().timeIntervalSinceDate(entries[0].date)) >= refreshInterval) {
            let params = ["search": ""]
            if (!isLoading) {
                isLoading = true
                RestManager.sharedInstance.makeJSONRequest(.GET, encoding: .URL, resource: resource, params: params, onCompletion: {
                    json, err in
                    if (err != nil) {
                        Debug.instance.log(err)
                    } else {
                        self.addEntries(json as! [String])
                    }
                    self.isLoading = false
                })
            }
        }
    }
    
    private func addEntries(words: [String]) {
        removeEntries()
        for word in words {
            let entry = NSEntityDescription.insertNewObjectForEntityForName(AutocompleteEntry.EntityName,
                inManagedObjectContext: self.managedObjectContext) as! AutocompleteEntry
            entry.word = word
            entry.date = NSDate()
        }
        saveCoreData()
    }
    
    func removeEntries() {
        for entry in entries {
            managedObjectContext.deleteObject(entry)
        }
    }
    
    func getCount() -> Int {
        return entries.count
    }
    
    func getEntries() -> [String] {
        var words = [String]()
        for entry in entries {
            words.append(entry.word)
        }
        //sort suggestions alphabetically
        words.sort({$0 < $1})
        return words
    }
    
    func getEntriesWithSubstring(substring: String) -> [String] {
        var words = [String]()
        var options = NSStringCompareOptions.CaseInsensitiveSearch
        for entry in entries {
            var substringRange: NSRange! = (entry.word as NSString).rangeOfString(substring, options: options)
            if (substringRange.location != NSNotFound) {
                words.append(entry.word)
            }
        }
        //sort suggestions alphabetically
        words.sort({$0 < $1})
        return words
    }
    
}