import SwiftUI

struct SongPicker: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var setList: SetList
    @State private var selections: [Song]
    @State private var sort = SongSorting.titleAsc
    @State private var presentSort = false
    
    init(setList: SetList) {
        self.setList = setList
        self._selections = State(initialValue: setList.songs?.array as? [Song] ?? [])
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Color(blueThemeColor).edgesIgnoringSafeArea([.leading, .trailing])
                HStack {
                    Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                        HStack {
                            Image(systemName: "xmark")
                            Text("Close")
                        }
                    }
                    Spacer()
                    if UIDevice.current.userInterfaceIdiom != .pad {
                        Button(action: { self.presentSort.toggle() }) {
                            Image(systemName: "arrow.up.arrow.down")
                                .frame(width: 30, height: 30)
                        }
                        Spacer()
                    }
                    Button(action: {
                        self.setList.songs = NSOrderedSet(array: self.selections)
                        self.setList.modifiedDate = Date()
                        try? self.managedObjectContext.save()
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "checkmark")
                            Text("Save")
                        }
                    }
                }
                .padding()
                .foregroundColor(.white)
            }
            .frame(height: 40)
            SongPickerList(setList: setList, sort: sort, selections: $selections)
            .actionSheet(isPresented: $presentSort) { () -> ActionSheet in
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
