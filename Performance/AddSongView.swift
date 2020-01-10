import SwiftUI

struct AddSongView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var title: String = ""
    @State private var artist: String = ""
    @Binding var newSongAdded: Song?
    
    var body: some View {
        EditDetailsView(onClose: { save in
            if save {
                let song = Song(context: self.managedObjectContext)
                song.title = self.title
                song.artist = self.artist
                song.id = UUID()
                song.text = ""
                song.createdDate = Date()
                song.modifiedDate = Date()
                try? self.managedObjectContext.save()
                self.newSongAdded = song
            }
        }) {
            HStack {
                Text("Title")
                    .frame(width: 80, alignment: .leading)
                TextField("Title", text: $title)
            }
            HStack {
                Text("Artist")
                    .frame(width: 80, alignment: .leading)
                TextField("Artist", text: $artist)
            }
        }
    }
}
