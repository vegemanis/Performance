import SwiftUI

struct AutoScrollIcon: View {
    var body: some View {
        Group {
            RoundedRectangle(cornerRadius: 5.0, style: .continuous)
                .stroke(Color.white, style: StrokeStyle(lineWidth: 2))
            Path { path in
                path.move(to: .init(x: 4, y: 6))
                path.addLine(to: .init(x: 12, y: 6)) }
                .stroke(Color.white, style: StrokeStyle(lineWidth: 2))
            Path { path in
                path.move(to: .init(x: 4, y: 11))
                path.addLine(to: .init(x: 12, y: 11)) }
                .stroke(Color.white, style: StrokeStyle(lineWidth: 2))
            Path { path in
                path.move(to: .init(x: 4, y: 16))
                path.addLine(to: .init(x: 10, y: 16)) }
                .stroke(Color.white, style: StrokeStyle(lineWidth: 2))
            Path { path in
                path.move(to: .init(x: 16, y: 5))
                path.addLine(to: .init(x: 16, y: 18)) }
                .stroke(Color.white, style: StrokeStyle(lineWidth: 2))
            Path { path in
                path.move(to: .init(x: 16, y: 18))
                path.addLine(to: .init(x: 13, y: 14)) }
                .stroke(Color.white, style: StrokeStyle(lineWidth: 2))
            Path { path in
                path.move(to: .init(x: 16, y: 18))
                path.addLine(to: .init(x: 19, y: 14)) }
                .stroke(Color.white, style: StrokeStyle(lineWidth: 2))
        }
    }
}

struct AutoScrollIcon_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
            AutoScrollIcon().frame(width: 22, height: 22)
        }
    }
}
