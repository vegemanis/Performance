import SwiftUI

struct SetListSongsView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var setList: SetList
    @State private var showAddSongs = false
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Color.white.edgesIgnoringSafeArea([.leading, .trailing]).opacity(0.55)
                Color(blueThemeColor).edgesIgnoringSafeArea([.leading, .trailing]).opacity(0.88)
                HStack {
                    Button(action: { self.showAddSongs.toggle() }) {
                        HStack {
                            Image(systemName: "plus")
                            Text("Add")
                        }
                    }
                    Spacer()
                    EditButton()
                }.padding()
                    .foregroundColor(.white)
            }
            .frame(height: 40)
            List {
                ForEach(setList.songs?.array as? [Song] ?? [], id: \.self) { song in
                    SongRow(song: song).environment(\.managedObjectContext, self.managedObjectContext)
                }
                .onMove(perform: self.moveSong)
                .onDelete(perform: self.removeSong)
            }
            .sheet(isPresented: $showAddSongs) {
                SongPicker(setList: self.setList).environment(\.managedObjectContext, self.managedObjectContext)
            }
            .navigationBarTitle(Text(navigationTitle()), displayMode: .inline)
        }
    }
    
    private func navigationTitle() -> String {
        if let songs = setList.songs, let name = setList.name {
            if songs.count > 0 {
                return "\(name) (\(songs.count))"
            } else {
                return name
            }
        }
        return setList.name ?? ""
    }
    
    private func removeSong(at offsets: IndexSet) {
        for index in offsets {
            setList.removeFromSongs(at: index)
        }
        try? managedObjectContext.save()
    }
    
    private func moveSong(from source: IndexSet, to destination: Int) {
        if let songs = setList.songs {
            var mutableSongs = songs.array
            mutableSongs.move(fromOffsets: source, toOffset: destination)
            setList.songs = NSOrderedSet(array: mutableSongs)
            try? managedObjectContext.save()
        }
    }
}

