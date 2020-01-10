import SwiftUI

struct SetListList: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    private let setList: FetchRequest<SetList>

    init() {
        setList = FetchRequest(entity: SetList.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \SetList.createdDate, ascending: true)])
    }
    
    var body: some View {
        List {
            ForEach(setList.wrappedValue, id: \.self) { setList in
                SetListRow(setList: setList).environment(\.managedObjectContext, self.managedObjectContext)
            }
            .onDelete(perform: self.deleteSet)
        }
    }
    
    private func deleteSet(at offsets: IndexSet) {
        for index in offsets {
            managedObjectContext.delete(setList.wrappedValue[index])
        }
        try? managedObjectContext.save()
    }
}
