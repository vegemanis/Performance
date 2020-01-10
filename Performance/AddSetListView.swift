import SwiftUI

struct AddSetListView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var name: String = ""
    
    var body: some View {
        EditDetailsView(onClose: { save in
            if save {
                let setList = SetList(context: self.managedObjectContext)
                setList.name = self.name
                setList.id = UUID()
                setList.modifiedDate = Date()
                setList.createdDate = Date()
                try? self.managedObjectContext.save()
            }
        }) {
            HStack {
                Text("Name")
                    .frame(width: 80, alignment: .leading)
                TextField("Name", text: $name)
            }
        }
    }
}
