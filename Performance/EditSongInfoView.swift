import SwiftUI

struct EditSongInfoView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var song: Song
    @State private var title: String = ""
    @State private var artist: String = ""
    
    var body: some View {
        EditDetailsView(created: song.createdDate,
                        modified: song.modifiedDate,
                        initialValues: {
                            self.title = self.song.title ?? ""
                            self.artist = self.song.artist ?? ""
        }, onClose: { save in
            if save {
                self.song.title = self.title
                self.song.artist = self.artist
                
                try? self.managedObjectContext.save()
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
