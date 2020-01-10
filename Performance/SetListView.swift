import SwiftUI

struct SetListView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var showAddEditSetList = false

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Color.white.edgesIgnoringSafeArea([.leading, .trailing]).opacity(0.55)
                Color(blueThemeColor).edgesIgnoringSafeArea([.leading, .trailing]).opacity(0.88)
                HStack {
                    Button(action: {
                        self.showAddEditSetList.toggle()
                    }) {
                        HStack {
                            Image(systemName: "plus")
                            Text("New")
                        }
                    }
                    Spacer()
                }
                .padding()
                .foregroundColor(.white)
            }
            .frame(height: 40)
            SetListList().environment(\.managedObjectContext, self.managedObjectContext)
        }
        .sheet(isPresented: $showAddEditSetList) {
            AddSetListView().environment(\.managedObjectContext, self.managedObjectContext)
        }
        .navigationBarTitle("Set Lists", displayMode: .inline)
    }
}

struct SetListView_Previews: PreviewProvider {
    static var previews: some View {
        SetListView()
    }
}
