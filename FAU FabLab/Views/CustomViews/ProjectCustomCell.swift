import Foundation
import UIKit

class ProjectCustomCell: UITableViewCell {
    
    @IBOutlet var filenameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    func configure(#filename: String, description: String) {
        filenameLabel.text = filename
        descriptionLabel.text = description
    }    
}