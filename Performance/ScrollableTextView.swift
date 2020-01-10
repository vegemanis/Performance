import SwiftUI

struct ScrollableTextView: UIViewRepresentable {
    @Binding var boundText: String?
    var scrollWidth: CGFloat

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<ScrollableTextView>) -> UIScrollView {
        let textView = UITextView()
        textView.font = UIFont(name: "Menlo", size: 12)
        textView.autocorrectionType = .no
        textView.autocapitalizationType = .none
        textView.delegate = context.coordinator
        textView.isScrollEnabled = false

        let scroll = UIScrollView()
        scroll.bounces = false
        scroll.addSubview(textView)
        return scroll
    }
    
    func updateUIView(_ scroll: UIScrollView, context:
        UIViewRepresentableContext<ScrollableTextView>) {
        if let textView = scroll.subviews.first as? UITextView {
            textView.text = boundText
            textView.sizeToFitContent()
            scroll.contentSize = textView.contentSize
            
            if boundText == "" {
                textView.becomeFirstResponder()
            }
        }
    }
    
    class Coordinator : NSObject, UITextViewDelegate {
        var parent: ScrollableTextView

        init(_ uiTextView: ScrollableTextView) {
            self.parent = uiTextView
        }

        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            return true
        }
        
        func textViewDidChange(_ textView: UITextView) {
            self.parent.boundText = textView.text
            textView.sizeToFitContent()
            if let scroll = textView.superview as? UIScrollView {
                scroll.contentSize = textView.contentSize
 
                // backspace and newline sometimes get messed up, manually set scroll offset to fix
                if let pos = textView.selectedTextRange?.start {
                    let rect = textView.caretRect(for: pos)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.025) {
                        scroll.scrollRectToVisible(rect, animated: false)
                        textView.selectedTextRange = textView.textRange(from: pos, to: pos)
                    }
                }
            }
        }
    }
}
