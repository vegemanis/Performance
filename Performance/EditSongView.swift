import SwiftUI

struct EditSongView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var song: Song
    @State private var scrollWidth: CGFloat = 0.0 // for screen rotation
    
    private func scrollView(width: CGFloat) -> ScrollableTextView {
        DispatchQueue.main.async {
            self.scrollWidth = width
        }
        
        return ScrollableTextView(boundText: $song.text, scrollWidth: scrollWidth)
    }
    
    var body: some View {
        KeyboardHost {
            GeometryReader { g in
                self.scrollView(width: g.size.width)
            }
            .navigationBarTitle(Text("\(song.title ?? "")"), displayMode: .inline)
            .padding([.top, .leading, .trailing])
            .onDisappear() {
                self.song.modifiedDate = Date()
                try? self.managedObjectContext.save()
            }
        }
    }
}
