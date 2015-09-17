import UIKit
import Foundation

class SearchHelpModel: NSObject {
    
    static let sharedInstance = SearchHelpModel()
    
    private let history = SearchHistoryModel()
    private let autocomplete = AutocompletionModel()
    
    private var entries = [[String]]()
    
    override init() {
        super.init()
    }
    
    func fetchEntries() {
        entries.removeAll(keepCapacity: false)
        //entries.append(["Kategorien".localized])
        entries.append(history.getEntries())
    }
    
    func fetchEntriesWithSubstring(substring: String) {
        entries.removeAll(keepCapacity: false)
        //entries.append(["Kategorien".localized])
        entries.append(history.getEntriesWithSubstring(substring))
        if (count(substring) > 1) {
            entries.append(autocomplete.getEntriesWithSubstring(substring))
        }
    }
    
    func getCount() -> Int {
        var count = 0
        for entry in entries {
            count += entry.count
        }
        return count
    }
    
    func getNumberOfSections() -> Int {
        return entries.count
    }
    
    func getNumberOfRowsInSection(section: Int) -> Int {
        return entries[section].count
    }
    
    func getTitleOfSection(section: Int) -> String {
        if (section == 0 && !entries[0].isEmpty) {
            return "Verlauf".localized
        } else if (section == 1 && !entries[1].isEmpty) {
            return "Vorschläge".localized
        }
        return ""
        /*
        if (section == 1 && !entries[0].isEmpty) {
            return "Verlauf".localized
        } else if (section == 2 && !entries[1].isEmpty) {
            return "Vorschläge".localized
        }
        return ""
        */
    }
    
    func getEntry(section: Int, row: Int) -> String {
        return entries[section][row]
    }
    
    func addHistoryEntry(word: String) {
        history.addEntry(word)
    }
    
    func removeHistoryEntries() {
        history.removeEntries()
    }
    
    func fetchAutocompleteEntries() {
        autocomplete.fetchEntries()
    }
    
    func removeAutocompleteEntries(){
        autocomplete.removeEntries()
    }
    
}
