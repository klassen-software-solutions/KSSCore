import Combine
import SwiftUI

/**
 SwiftUI text view control allowing multi-font content. The content is controlled via a binding to an
 `NSMutableAttributedString`.

 - note: This is a modified version of code provided by Thiago Holanda, called the `MacEditorTextView`.
    The original code is available from https://twitter.com/tholanda and is subject to the MIT License.
 */
@available(OSX 10.15, *)
public struct KSSTextView: NSViewRepresentable {
    /**
     The binding used to control the text view contents.
     */
    @Binding public var text: NSMutableAttributedString

    /**
     Used to determine if the control is editable or not. This is set using the `editable` modifier.
     */
    public private(set) var isEditable = true

    /**
     Used to determine if the control should automatically scroll to the bottom when the text is changed. This
     is intended to be used if your view is one that always appends and saves the developer from having to
     do this manually. This is set using the `autoScrollToBottom` modifier.
     */
    public private(set) var isAutoScrollToBottom = false

    /**
     Construct a new text view with the given binding.
     */
    public init(text: Binding<NSMutableAttributedString>) {
        self._text = text
    }

    /**
     This is a modifier that returns a View with the `isEditable` field changed.
     */
    public func editable(_ isEditable: Bool) -> KSSTextView {
        var newView = self
        newView.isEditable = isEditable
        return newView
    }

    /**
     This is a modivier that returns a View with the `isAutoScrollToBottom` field changed.
     */
    public func autoScrollToBottom() -> KSSTextView {
        var newView = self
        newView.isAutoScrollToBottom = true
        return newView
    }

    /// :nodoc:
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    /// :nodoc:
    public func makeNSView(context: Context) -> CustomTextView {
        let textView = CustomTextView(text: self.text,
                                      isEditable: self.isEditable,
                                      isAutoScrollToBottom: self.isAutoScrollToBottom)
        textView.delegate = context.coordinator
        
        return textView
    }
    
    /// :nodoc:
    public func updateNSView(_ view: CustomTextView, context: Context) {
        view.text = text
        view.selectedRanges = context.coordinator.selectedRanges
    }

}


/// :nodoc:
@available(OSX 10.15, *)
extension KSSTextView {
    public class Coordinator: NSObject, NSTextViewDelegate {
        var parent: KSSTextView
        var selectedRanges: [NSValue] = []
        
        init(_ parent: KSSTextView) {
            self.parent = parent
        }
        
        public func textDidBeginEditing(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else {
                return
            }

            self.parent.text.setAttributedString(textView.textStorage ?? NSAttributedString())
        }
        
        public func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else {
                return
            }

            self.parent.text.setAttributedString(textView.textStorage ?? NSAttributedString())
            self.selectedRanges = textView.selectedRanges
        }
        
        public func textDidEndEditing(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else {
                return
            }
            
            self.parent.text.setAttributedString(textView.textStorage ?? NSAttributedString())
        }
    }
}


/// :nodoc:
@available(OSX 10.15, *)
public final class CustomTextView: NSView {
    private let isEditable: Bool
    private let isAutoScrollToBottom: Bool

    weak var delegate: NSTextViewDelegate?
    
    var text: NSMutableAttributedString {
        didSet {
            textView.textStorage?.setAttributedString(text)

            if isAutoScrollToBottom {
                if let documentView = scrollView.documentView {
                    documentView.scroll(NSPoint(x: 0, y: documentView.bounds.size.height))
                }
            }
        }
    }
    
    var selectedRanges: [NSValue] = [] {
        didSet {
            guard selectedRanges.count > 0 else {
                return
            }
            
            textView.selectedRanges = selectedRanges
        }
    }
    
    private lazy var scrollView: NSScrollView = {
        let scrollView = NSScrollView()
        scrollView.drawsBackground = true
        scrollView.borderType = .noBorder
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalRuler = false
        scrollView.autoresizingMask = [.width, .height]
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private lazy var textView: NSTextView = {
        let contentSize = scrollView.contentSize
        let textStorage = NSTextStorage()
        
        
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        
        
        let textContainer = NSTextContainer(containerSize: scrollView.frame.size)
        textContainer.widthTracksTextView = true
        textContainer.containerSize = NSSize(
            width: contentSize.width,
            height: CGFloat.greatestFiniteMagnitude
        )
        
        layoutManager.addTextContainer(textContainer)
        
        
        let textView                     = NSTextView(frame: .zero, textContainer: textContainer)
        textView.autoresizingMask        = .width
        textView.backgroundColor         = NSColor.textBackgroundColor
        textView.delegate                = self.delegate
        textView.drawsBackground         = true
        textView.isEditable              = self.isEditable
        textView.isHorizontallyResizable = false
        textView.isVerticallyResizable   = true
        textView.maxSize                 = NSSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        textView.minSize                 = NSSize(width: 0, height: contentSize.height)
        textView.textColor               = NSColor.labelColor
    
        return textView
    }()
    
    init(text: NSMutableAttributedString, isEditable: Bool, isAutoScrollToBottom: Bool) {
        self.isEditable = isEditable
        self.text = text
        self.isAutoScrollToBottom = isAutoScrollToBottom

        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewWillDraw() {
        super.viewWillDraw()
        
        setupScrollViewConstraints()
        setupTextView()
    }
    
    func setupScrollViewConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
    
    func setupTextView() {
        scrollView.documentView = textView
    }
}