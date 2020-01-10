import SwiftUI

struct SongList: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    private var songList: FetchRequest<Song>

    init(sort: SongSorting) {
        UserDefaults.standard.set(sort.rawValue, forKey: "sortKey")
        songList = FetchRequest(entity: Song.entity(), sortDescriptors: [sort.sortDescriptor()])
    }
    
    var body: some View {
        List {
            ForEach(songList.wrappedValue, id: \.self) { song in
                SongRow(song: song).environment(\.managedObjectContext, self.managedObjectContext)
            }
            .onDelete(perform: self.deleteSong)
        }
        .navigationBarTitle("Songs\(numberOfSongs())", displayMode: .inline)
        .background(NavigationConfigurator { nc in
            // only works for inline nav bar
            nc.navigationBar.barTintColor = blueThemeColor
            nc.navigationBar.tintColor = .white
            nc.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        })
    }
    
    private func numberOfSongs() -> String {
        if songList.wrappedValue.count > 0 {
            return " (\(songList.wrappedValue.count))"
        } else {
            return ""
        }
    }
    
    private func deleteSong(at offsets: IndexSet) {
        for index in offsets {
            managedObjectContext.delete(songList.wrappedValue[index])
        }
        try? managedObjectContext.save()
    }
}
