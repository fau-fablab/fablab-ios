
import Foundation
import UIKit
import MarkdownTextView

class CreateProjectsViewController: UIViewController {
    // this is just a basic test
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let attributes = MarkdownAttributes()
        let textStorage = MarkdownTextStorage(attributes: attributes)
        var error: NSError?
        if let linkHighlighter = LinkHighlighter(errorPtr: &error) {
            textStorage.addHighlighter(linkHighlighter)
        } else {
            assertionFailure("Error initializing LinkHighlighter: \(error)")
        }
        textStorage.addHighlighter(MarkdownStrikethroughHighlighter())
        textStorage.addHighlighter(MarkdownSuperscriptHighlighter())
        if let codeBlockAttributes = attributes.codeBlockAttributes {
            textStorage.addHighlighter(MarkdownFencedCodeHighlighter(attributes: codeBlockAttributes))
        }
        
        let textView = MarkdownTextView(frame: CGRectZero, textStorage: textStorage)
        textView.setTranslatesAutoresizingMaskIntoConstraints(false)
        textView.text = "TEST"
        view.addSubview(textView)
        
        let views = ["textView": textView]
        var constraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-20-[textView]-20-|", options: nil, metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[textView]-20-|", options: nil, metrics: nil, views: views)
        NSLayoutConstraint.activateConstraints(constraints)
    }
    
}