import SwiftUI

struct AutoscrollMenu: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Binding var defaultSpeed: Double
    @Binding var scrollSpeed: AutoScrollSpeed
    @Binding var autoScroll: Bool
    private let stepSpeed = 0.1

    var body: some View {
        VStack(spacing: 5) {
            Color.clear.frame(height: 1)
            HStack {
                Text("Autoscroll:")
                    .bold()
                Stepper(onIncrement: {
                    self.scrollSpeed = self.scrollSpeed.next
                    self.defaultSpeed = self.scrollSpeed.seconds
                    try? self.managedObjectContext.save()
                }, onDecrement: {
                    self.scrollSpeed = self.scrollSpeed.previous
                    self.defaultSpeed = self.scrollSpeed.seconds
                    try? self.managedObjectContext.save()
                }) {
                    Text("\(scrollSpeed.rawValue)")
                }
                Spacer()
                Button(action: {
                    self.autoScroll.toggle()
                }) {
                    Image(systemName: self.autoScroll ? "pause.fill" : "play.fill")
                        .frame(width: 40, height: 40)
                }
            }.padding([.leading, .trailing], 10)
            Color.secondary.frame(height: 1)
        }
        .background(Color(UIColor.systemBackground))
        .transition(.move(edge: .top))
        .onAppear {
            self.scrollSpeed = AutoScrollSpeed.from(seconds: self.defaultSpeed)
        }
    }
}
