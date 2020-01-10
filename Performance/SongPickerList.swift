import SwiftUI

struct SongPickerList: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var setList: SetList
    @Binding var selections: [Song]
    private var songList: FetchRequest<Song>

    init(setList: SetList, sort: SongSorting, selections: Binding<[Song]>) {
        self.setList = setList
        self._selections = selections
        songList = FetchRequest(entity: Song.entity(), sortDescriptors: [sort.sortDescriptor()])
    }
    
    var body: some View {
        List {
            ForEach(songList.wrappedValue, id: \.self) { song in
                MultipleSongSelectionRow(song: song, isSelected: self.selections.contains(where: { $0.id == song.id })) {
                    if self.selections.contains(where: { $0.id == song.id }) {
                        self.selections.removeAll(where: { $0.id == song.id })
                    }
                    else {
                        self.selections.append(song)
                    }
                }
            }
        }
    }
}
