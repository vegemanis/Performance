import SwiftUI

struct SongRow: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var song: Song
    @State private var showInfo = false
    
    var body: some View {
        NavigationLink(destination: SongDetails(song: song).environment(\.managedObjectContext, self.managedObjectContext)) {
            HStack {
                Image(systemName: "info.circle")
                    .frame(width: 30, height: 30)
                    .onTapGesture {
                        self.showInfo.toggle()
                    }
                VStack(alignment: .leading) {
                    Text(song.title ?? "")
                    if song.artist != nil && song.artist != "" {
                        Text(song.artist!).font(.caption)
                    }
                }
            }
        }
        .sheet(isPresented: self.$showInfo) {
            EditSongInfoView(song: self.song).environment(\.managedObjectContext, self.managedObjectContext)
        }
    }
}
