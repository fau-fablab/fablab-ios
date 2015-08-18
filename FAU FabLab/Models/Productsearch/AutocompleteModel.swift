import Foundation

class AutocompleteModel : NSObject {
    
    override init(){
        super.init()
    }
    
    func loadAutocompleteSuggestion() {
        //TODO load product names and create autocomplete suggestions
    }
    
    func getAutocompleteSuggestions() -> [String] {
        //TODO return autocomplete suggestions
        //return dummy autocomplete suggestions
        return ["Schraube","Acryl","Holzleim","Bohrschrauber"]
    }
    
}