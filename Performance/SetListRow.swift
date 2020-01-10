import SwiftUI

struct SetListRow: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var setList: SetList
    @State private var showInfo = false
    
    var body: some View {
        NavigationLink(destination: SetListSongsView(setList: setList).environment(\.managedObjectContext, self.managedObjectContext)) {
            HStack {
                Image(systemName: "info.circle")
                    .frame(width: 30, height: 30)
                    .onTapGesture {
                        self.showInfo.toggle()
                    }
                VStack(alignment: .leading) {
                    Text(setList.name ?? "")
                }
            }
        }
        .sheet(isPresented: self.$showInfo) {
            EditSetListView(setList: self.setList).environment(\.managedObjectContext, self.managedObjectContext)
        }
    }
}
