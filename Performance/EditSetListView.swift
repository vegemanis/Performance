import SwiftUI

struct EditSetListView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var name: String = ""
    @ObservedObject var setList: SetList
    
    var body: some View {
        EditDetailsView(created: setList.createdDate,
                        modified: setList.modifiedDate,
                        initialValues: {
                            self.name = self.setList.name ?? ""
        }, onClose: { save in
            if save {
                self.setList.name = self.name
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

