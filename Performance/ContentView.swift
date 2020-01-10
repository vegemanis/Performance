import CoreData
import SwiftUI

struct ContentView: View {
    var managedObjectContext: NSManagedObjectContext
    @State private var selectedTab = 0

    var body: some View {
        NavigationView {
            VStack {
                if selectedTab == 0 {
                    SongListView().environment(\.managedObjectContext, self.managedObjectContext)
                } else {
                    SetListView().environment(\.managedObjectContext, self.managedObjectContext)
                }
                TabView(selection: $selectedTab) {
                    Text("")
                        .tabItem {
                            Image(systemName: "music.note.list")
                            Text("Songs")
                    }
                    .tag(0)
                    Text("")
                        .tabItem {
                            Image(systemName: "doc.on.doc")
                            Text("Set Lists")
                    }
                    .tag(1)
                }
                .frame(height: 42)
                .accentColor(Color(blueThemeColor))
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
