
import Foundation
import UIKit
import MarkdownTextView

class CreateProjectsViewController: UIViewController {
    
    @IBOutlet var titleText: UITextField!
    @IBOutlet var viewInScrollView: UIView!
    
    var textView : MarkdownTextView?
    
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
        
        textView = MarkdownTextView(frame: CGRectZero, textStorage: textStorage)
        // hide autocorrection
        textView!.autocorrectionType = UITextAutocorrectionType.No
        textView!.setTranslatesAutoresizingMaskIntoConstraints(false)
        textView!.text = "_Enter Markdown-Text_"
        
        //view.addSubview(textView!)
        viewInScrollView.addSubview(textView!)
        
        let views = ["textView": textView!]
        var constraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[textView]-10-|", options: nil, metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[textView]-10-|", options: nil, metrics: nil, views: views)
        NSLayoutConstraint.activateConstraints(constraints)
        
        // Keyboard-Customization
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 44.0))
        toolBar.items = [
            UIBarButtonItem(title: "H1", style: UIBarButtonItemStyle.Plain, target: self, action: "addText:"),
            UIBarButtonItem(title: "H2", style: UIBarButtonItemStyle.Plain, target: self, action: "addText:"),
            UIBarButtonItem(title: "H3", style: UIBarButtonItemStyle.Plain, target: self, action: "addText:"),
            UIBarButtonItem(title: "B", style: UIBarButtonItemStyle.Plain, target: self, action: "addText:"),
            UIBarButtonItem(title: "I", style: UIBarButtonItemStyle.Plain, target: self, action: "addText:"),
            UIBarButtonItem(title: "*", style: UIBarButtonItemStyle.Plain, target: self, action: "addText:"),
            UIBarButtonItem(title: ">", style: UIBarButtonItemStyle.Plain, target: self, action: "addText:"),
            UIBarButtonItem(title: "^", style: UIBarButtonItemStyle.Plain, target: self, action: "addText:"),
            UIBarButtonItem(title: "~", style: UIBarButtonItemStyle.Plain, target: self, action: "addText:"),
            UIBarButtonItem(title: "`", style: UIBarButtonItemStyle.Plain, target: self, action: "addText:"),
            UIBarButtonItem(title: "Code", style: UIBarButtonItemStyle.Plain, target: self, action: "addText:"),
            UIBarButtonItem(title: "Link", style: UIBarButtonItemStyle.Plain, target: self, action: "addText:")
        ]
        
        textView!.inputAccessoryView = toolBar
    }
    
    func addText(sender: UIBarButtonItem) {
        if sender.title == "H1" {
            self.textView!.insertText("#")
        } else if sender.title == "H2" {
            self.textView!.insertText("##")
        } else if sender.title == "H3" {
            self.textView!.insertText("###")
        } else if sender.title == "B" {
            self.textView!.insertText("**")
        } else if sender.title == "I" {
            self.textView!.insertText("_")
        } else if sender.title == "Code" {
            self.textView!.insertText("```")
        } else if sender.title == "Link" {
            self.textView!.insertText("[title](url)")
        } else {
            self.textView!.insertText(sender.title!)
        }
    }
    
}