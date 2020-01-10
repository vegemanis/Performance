import SwiftUI

struct SongListView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var newSongAdded: Song? = nil
    @State private var moveToNewSong = false
    @State private var isModalPresented = false
    @State private var addNewSelected = false
    @State private var showSortingSheet = false
    @State private var sort: SongSorting = {
        if let raw = UserDefaults.standard.object(forKey: "sortKey") as? String {
            return SongSorting(rawValue: raw) ?? SongSorting.titleAsc
        }
        return SongSorting.titleAsc
    }()
    
    private func moveLink() -> some View {
        DispatchQueue.main.async {
            self.moveToNewSong.toggle()
            if self.moveToNewSong == false {
                self.newSongAdded = nil
            }
        }
        return NavigationLink(destination: EditSongView(song: newSongAdded!).environment(\.managedObjectContext, self.managedObjectContext), isActive: $moveToNewSong) {
            EmptyView()
        }
    }
    
    var body: some View {
        ZStack {
            if newSongAdded != nil {
                moveLink()
            }
            VStack(spacing: 0) {
                ZStack {
                    Color.white.edgesIgnoringSafeArea([.leading, .trailing]).opacity(0.55)
                    Color(blueThemeColor).edgesIgnoringSafeArea([.leading, .trailing]).opacity(0.88)
                    HStack {
                        Button(action: {
                            self.addNewSelected = true
                            self.isModalPresented.toggle()
                        }) {
                            HStack {
                                Image(systemName: "plus")
                                Text("New")
                            }
                        }
                        Spacer()
                        Button(action: {
                            self.addNewSelected = false
                            self.isModalPresented.toggle()
                        }) {
                            HStack {
                                Image(systemName: "square.and.arrow.down")
                                Text("Import")
                            }
                        }
                        if UIDevice.current.userInterfaceIdiom != .pad {
                            Spacer()
                            Button(action: {
                                self.showSortingSheet.toggle()
                            }) {
                                HStack {
                                    Image(systemName: "arrow.up.arrow.down")
                                    Text("Sort")
                                }
                            }
                        }
                    }
                    .foregroundColor(.white)
                    .padding()
                }
                .frame(height: 40)
                SongList(sort: sort)
                    .sheet(isPresented: $isModalPresented) {
                        if self.addNewSelected {
                            AddSongView(newSongAdded: self.$newSongAdded).environment(\.managedObjectContext, self.managedObjectContext)
                        } else {
                            SongImportPicker().environment(\.managedObjectContext, self.managedObjectContext)
                        }
                }
                .actionSheet(isPresented: $showSortingSheet) { () -> ActionSheet in
                    ActionSheet(title: Text("Sort By..."), buttons: [
                        .default(sort.actionTitle(.titleAsc), action: {
                            self.sort = .titleAsc
                        }),
                        .default(sort.actionTitle(.titleDesc), action: {
                            self.sort = .titleDesc
                        }),
                        .default(sort.actionTitle(.artistAsc), action: {
                            self.sort = .artistAsc
                        }),
                        .default(sort.actionTitle(.artistDesc), action: {
                            self.sort = .artistDesc
                        }),
                        .default(sort.actionTitle(.createdAsc), action: {
                            self.sort = .createdAsc
                        }),
                        .default(sort.actionTitle(.createdDesc), action: {
                            self.sort = .createdDesc
                        }),
                        .default(sort.actionTitle(.modifiedAsc), action: {
                            self.sort = .modifiedAsc
                        }),
                        .default(sort.actionTitle(.modifiedDesc), action: {
                            self.sort = .modifiedDesc
                        }),
                        .cancel(Text("Cancel"))])
                }
            }
        }
    }
}
