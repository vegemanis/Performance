import SwiftUI

struct MultipleSongSelectionRow: View {
    @ObservedObject var song: Song
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: self.action) {
            HStack {
                VStack(alignment: .leading) {
                    Text(song.title ?? "")
                    if song.artist != nil {
                        Text(song.artist!).font(.caption)
                    }
                }
                if self.isSelected {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
        }
    }
}
