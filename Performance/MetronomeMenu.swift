import AVFoundation
import SwiftUI

struct MetronomeMenu: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Binding var defaultBpm: Int32
    @State private var play = false
    @State private var bpm: Int32 = 120
    @State private var timer: DispatchSourceTimer?
    private let bpmStep: Int32 = 2
    private let sound: AVAudioPlayer = {
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: "key_press_click", ofType: "caf")!)
        let player = try! AVAudioPlayer(contentsOf: url)
        player.prepareToPlay()
        return player
    }()

    var body: some View {
        VStack(spacing: 5) {
            Color.clear.frame(height: 1)
            HStack {
                Text("Metronome:")
                    .bold()
                Stepper(onIncrement: {
                    if self.bpm < 200 {
                        self.bpm += self.bpmStep
                        self.adjustTimer()
                        self.defaultBpm = self.bpm
                        try? self.managedObjectContext.save()
                    }
                }, onDecrement: {
                    if self.bpm > self.bpmStep, self.bpm > 40 {
                        self.bpm -= self.bpmStep
                        self.adjustTimer()
                        self.defaultBpm = self.bpm
                        try? self.managedObjectContext.save()
                    }
                }) { Text("\(bpm) BPM") }
                Spacer()
                Button(action: {
                    self.play.toggle()
                    self.adjustTimer()
                }) {
                    Image(systemName: self.play ? "pause.fill" : "play.fill")
                        .frame(width: 40, height: 40)
                }
            }
            .padding([.leading, .trailing], 10)
            Color.secondary.frame(height: 1)
        }
        .background(Color(UIColor.systemBackground))
        .transition(.move(edge: .top))
        .onAppear {
            self.bpm = self.defaultBpm == 0 ? 120 : self.defaultBpm
        }
        .onDisappear() {
            self.timer?.cancel()
        }
    }
    
    private func adjustTimer() {
        timer?.cancel()
        if play {
            let queue = DispatchQueue(label: "com.performance.metronome.timer", qos: .userInteractive)
            timer = DispatchSource.makeTimerSource(flags: .strict, queue: queue)
            timer?.schedule(deadline: .now(), repeating: .milliseconds(Int(1000.0 * 60.0 / Double(self.bpm))))
            timer?.setEventHandler {
                self.sound.play()
            }
            timer?.resume()
        }
    }
}

struct MetronomeMenu_Previews: PreviewProvider {
    static var previews: some View {
        MetronomeMenu(defaultBpm: .constant(100))
    }
}
