import SwiftUI

struct ScrollableLabel: UIViewRepresentable {
    private let scroll = UIScrollView()
    private let label = UILabel()
    var text: String?
    var scrollWidth: CGFloat
    var autoScroll: Bool
    var scrollSpeed: AutoScrollSpeed
    let autoScrollEnd: () -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: UIViewRepresentableContext<ScrollableLabel>) -> UIScrollView {
        label.numberOfLines = 0
        label.font = UIFont(name: "Menlo", size: 12)

        scroll.addSubview(label)
        scroll.bounces = false
        scroll.minimumZoomScale = 0.25
        scroll.maximumZoomScale = 3.0
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.delegate = context.coordinator
        return scroll
    }
    
    func updateUIView(_ scrollView: UIScrollView, context: UIViewRepresentableContext<ScrollableLabel>) {
        context.coordinator.applyUpdates(text: text, scroll: autoScroll, speed: scrollSpeed.seconds, width: scrollWidth, timerEnds: autoScrollEnd)
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        private var parent: ScrollableLabel
        private var timer: Timer?
        private var isAutoScrolling = false
        private var currentScrollSpeed: Double = 0.0
        private var currentScrollWidth: CGFloat = 0.0
        
        init(_ parent: ScrollableLabel) {
            self.parent = parent
        }
        
        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            parent.label
        }
        
        func applyUpdates(text: String?, scroll: Bool, speed: Double, width: CGFloat, timerEnds: @escaping () -> Void) {
            if isAutoScrolling == scroll, currentScrollSpeed == speed {
                if parent.label.text != text, text != nil {
                    applyText(text: text)
                    adjustZoom(scrollWidth: width)
                } else if width != currentScrollWidth {
                    adjustZoom(scrollWidth: width)
                }
            }
            
            autoScroll(scroll, speed: speed, timerEnds: timerEnds)
        }
        
        private func applyText(text: String?) {
            parent.label.text = text
            parent.label.sizeToFitContent()
            parent.scroll.contentSize = parent.label.frame.size
        }
        
        private func adjustZoom(scrollWidth: CGFloat) {
            currentScrollWidth = scrollWidth
            
            var newScale = scrollWidth / (parent.label.frame.width / parent.scroll.zoomScale)
            
            if newScale > parent.scroll.maximumZoomScale {
                newScale = parent.scroll.maximumZoomScale
            } else if newScale < parent.scroll.minimumZoomScale {
                newScale = parent.scroll.minimumZoomScale
            }
            
            if newScale != parent.scroll.zoomScale {
                let offset = newScale / parent.scroll.zoomScale * parent.scroll.contentOffset.y
                parent.scroll.zoomScale = newScale
                if parent.scroll.frame.size.height < parent.scroll.contentSize.height - offset  {
                    parent.scroll.setContentOffset(CGPoint(x: 0, y: offset), animated: false)
                }
            }
        }
        
        private func autoScroll(_ scroll: Bool, speed: Double, timerEnds: @escaping () -> Void) {
            if !isAutoScrolling, scroll {
                // if starting scroll, but already at the bottom, scroll to top
                 let offset = self.parent.scroll.contentOffset
                 if !(offset.y + self.parent.scroll.bounds.height < self.parent.scroll.contentSize.height)  {
                     self.parent.scroll.contentOffset = CGPoint(x: 0, y: 0)
                 }
            }
            
            isAutoScrolling = scroll
            currentScrollSpeed = speed
            if scroll {
                if timer?.timeInterval != speed {
                    timer?.invalidate()
                    timer = Timer.scheduledTimer(withTimeInterval: speed, repeats: true, block: { _ in
                        let offset = self.parent.scroll.contentOffset
                        if offset.y + self.parent.scroll.bounds.height < self.parent.scroll.contentSize.height  {
                            self.parent.scroll.contentOffset = CGPoint(x: 0, y: offset.y + 1)
                        } else {
                            timerEnds()
                        }
                    })
                }
            } else {
                timer?.invalidate()
                timer = nil
            }
        }
    }
}
