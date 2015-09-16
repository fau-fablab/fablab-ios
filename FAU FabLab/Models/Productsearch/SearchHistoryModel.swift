import Foundation
import CoreData
import UIKit

class SearchHistoryModel: NSObject {
    
    private let managedObjectContext: NSManagedObjectContext
    private let coreData = CoreDataHelper(sqliteDocumentName: "CoreDataModel.db", schemaName: "")
    private let settings = SettingsModel()
    
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
        //check settings
        if (settings.getValue(settings.historyKey) == false) {
            return
        }
        //ignore empty strings
        if (word.isEmpty) {
            return
        }
        //if word already exists, delete it and add it anew to retain chronological order
        if (!entries.isEmpty) {
            for entry in entries {
                if (entry.word == word) {
                    managedObjectContext.deleteObject(entry)
                }
            }
        }
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
            words.insert(entry.word, atIndex: 0)
        }
        return words
    }
    
    func getEntriesWithSubstring(substring: String) -> [String] {
        var words = [String]()
        var options = NSStringCompareOptions.CaseInsensitiveSearch
        for entry in entries {
            var substringRange: NSRange! = (entry.word as NSString).rangeOfString(substring, options: options)
            if (substringRange.location != NSNotFound) {
                words.insert(entry.word, atIndex: 0)
            }
        }
        return words
    }
    
}
