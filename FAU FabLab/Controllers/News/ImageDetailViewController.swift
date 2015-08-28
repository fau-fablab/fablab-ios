
import Foundation
import UIKit

class ImageDetailViewController : UIViewController{
    
    @IBOutlet var imageView: UIImageView!
    
    var newsTitle: String?
    var image: UIImage?
    
    func configure(#title: String, image: UIImage){
        newsTitle = title
        self.image = image
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = newsTitle // sets the title in the navigation-bar
        imageView.image = image
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}