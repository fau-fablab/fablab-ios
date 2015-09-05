import Foundation
import CoreData
import UIKit

class History: NSObject {
    
    private let managedObjectContext: NSManagedObjectContext
    private let coreData = CoreDataHelper(sqliteDocumentName: "CoreDataModel.db", schemaName: "")
    
    private var entries : [HistoryEntry] {
        get {
            let reqeust = NSFetchRequest(entityName: HistoryEntry.EntityName)
            return managedObjectContext.executeFetchRequest(reqeust, error: nil) as! [HistoryEntry]
        }
    }
    
    override init() {
        self.managedObjectContext = coreData.createManagedObjectContext()
        super.init()
    }
    
    private func saveCoreData() {
        var error : NSError?
        if !self.managedObjectContext.save(&error) {
            Debug.instance.log("Error saving: \(error!)")
        }
    }
    
    func addEntry(word: String) {
        //ignore empty strings
        if (word.isEmpty) {
            return
        }
        //if word already exists, update date only
        if (!entries.isEmpty) {
            for index in 0...(entries.count - 1) {
                if (entries[index].word == word) {
                    entries[index].date = NSDate()
                    saveCoreData()
                    return
                }
            }
        }
        //if word doesn't exist, create search word
        let entry = NSEntityDescription.insertNewObjectForEntityForName(HistoryEntry.EntityName,
            inManagedObjectContext: self.managedObjectContext) as! HistoryEntry
        entry.word = word
        entry.date = NSDate()
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
        return words
    }
    
}
