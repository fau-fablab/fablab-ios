
import Foundation
import UIKit
import MarkdownTextView

class CreateProjectsViewController: UIViewController {
    
    @IBOutlet var titleText: UITextField!
    @IBOutlet var viewInScrollView: UIView!
    
    var textView : MarkdownTextView?
    
    @IBAction func saveProjectButtonTouched(sender: AnyObject) {
        let cancelAction: UIAlertAction = UIAlertAction(title: "Abbrechen".localized, style: .Cancel, handler: { (Void) -> Void in })
        
        let doneAction: UIAlertAction = UIAlertAction(title: "Hochladen".localized, style: .Default, handler: { (Void) -> Void in self.uploadProjectActionHandler()})
        
        let alertController: UIAlertController = UIAlertController(title: "Upload zu GitHub".localized, message: "Wollen Sie das Projekt-Snippet hochladen?".localized, preferredStyle: .Alert)
        alertController.addAction(cancelAction)
        alertController.addAction(doneAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func uploadProjectActionHandler() {
        let api = ProjectsApi()
        
        let project = ProjectFile()
        project.setFilename("fab-project.md")
        project.setDescription(self.titleText.text)
        project.setContent(self.textView!.text)
        
        api.create(project, onCompletion: {
            url, err in
            
            if (err != nil) {
                AlertView.showErrorView("Projekt-Snippet konnte nicht hochgeladen werden".localized)
            } else {
                let doneAction: UIAlertAction = UIAlertAction(title: "OK".localized, style: .Default, handler: { (Void) -> Void in })
                
                let browserAction: UIAlertAction = UIAlertAction(title: "Gist anzeigen".localized, style: .Default, handler: { (Void) -> Void in
                        if let nsurl = NSURL(string: url!) {
                            UIApplication.sharedApplication().openURL(nsurl)
                        }
                    })
                
                let alertController: UIAlertController = UIAlertController(title: "Projekt-Snipped wurde erfolgreich hochgeladen".localized, message: "Link".localized + ": " + url!, preferredStyle: .Alert)
                alertController.addAction(doneAction)
                alertController.addAction(browserAction)
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        })
    }
    
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