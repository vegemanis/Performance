import Foundation
import SwiftUI

struct SongDetails: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var song: Song
    @State private var showScrollMenu = false
    @State private var showMetronomeMenu = false
    @State private var showEditMenu = false
    @State private var scrollSpeed = AutoScrollSpeed.medium
    @State private var autoScroll = false
    @State private var scrollWidth: CGFloat = 0.0
    
    private func scrollView(width: CGFloat) -> ScrollableLabel {
        DispatchQueue.main.async {
            self.scrollWidth = width
        }
        
        return ScrollableLabel(text: song.text,
                               scrollWidth: scrollWidth,
                               autoScroll: autoScroll,
                               scrollSpeed: scrollSpeed,
                               autoScrollEnd: {
                                self.autoScroll.toggle()
        })
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if showScrollMenu {
                AutoscrollMenu(defaultSpeed: $song.defaultSpeed, scrollSpeed: $scrollSpeed, autoScroll: $autoScroll).environment(\.managedObjectContext, self.managedObjectContext)
            }
            if showMetronomeMenu {
                MetronomeMenu(defaultBpm: $song.defaultBpm).environment(\.managedObjectContext, self.managedObjectContext)
            }
            GeometryReader { geometry in
                self.scrollView(width: geometry.size.width)
            }
            .padding()
            .onDisappear() {
                self.autoScroll = false
                self.showScrollMenu = false
                self.showMetronomeMenu = false
            }
        }
        .navigationBarTitle(Text(showEditMenu ? "" : self.song.title ?? ""), displayMode: .inline)
        .navigationBarItems(trailing: HStack(spacing: 14) {
            Button(action: {
                withAnimation {
                    self.showMetronomeMenu.toggle()
                }
            }) {
                Image(systemName: "metronome")
                    .resizable()
                    .frame(width: 22, height: 22)
            }
            NavigationLink(destination: EditSongView(song: song).environment(\.managedObjectContext, self.managedObjectContext), isActive: $showEditMenu) {
                Button(action: {
                    self.showEditMenu.toggle()
                }) {
                    Image(systemName: "square.and.pencil")
                        .resizable()
                        .frame(width: 22, height: 22)
                }
            }
            Button(action: {
                withAnimation {
                    self.showScrollMenu.toggle()
                }
            }) {
                ZStack {
                    AutoScrollIcon()
                }.frame(width: 22, height: 22)
            }
        }
        .padding(0)
        )
    }
}
