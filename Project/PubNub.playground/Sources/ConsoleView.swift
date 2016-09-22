import UIKit

public class ConsoleView: UIViewController {
    private let textView: UITextView
    public init() {
        self.textView = UITextView(frame: .zero)
        super.init(nibName: nil, bundle: nil)
    }
    
    override public func loadView() {
        let frame = CGRect(x: 0.0, y: 0.0, width: 200.0, height: 300.0)
        let loadingView = UIView(frame: frame)
        loadingView.backgroundColor = UIColor.cyan
        loadingView.addSubview(textView)
        self.view = loadingView
        view.setNeedsLayout()
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        textView.text = "Starting\n"
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let textViewEdgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        let textViewFrame = UIEdgeInsetsInsetRect(view.frame, textViewEdgeInsets)
        textView.frame = textViewFrame
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func addMessage(message: String) {
        let finalMessage = message + "\n"
        textView.text.append(finalMessage)
        view.setNeedsLayout()
    }
}

