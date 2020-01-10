import SwiftUI

enum AutoScrollSpeed: String {
    case verySlow = "Very Slow"
    case slow = "Slow"
    case medium = "Medium"
    case fast = "Fast"
    case veryFast = "Very Fast"

    var seconds: Double {
        switch self {
        case .verySlow: return 0.5
        case .slow: return 0.25
        case .medium: return 0.15
        case .fast: return 0.05
        case .veryFast: return 0.025
        }
    }
    var next: AutoScrollSpeed {
        switch self {
        case .verySlow: return .slow
        case .slow: return .medium
        case .medium: return .fast
        case .fast: return .veryFast
        case .veryFast: return .veryFast
        }
    }
    var previous: AutoScrollSpeed {
        switch self {
        case .verySlow: return .verySlow
        case .slow: return .verySlow
        case .medium: return .slow
        case .fast: return .medium
        case .veryFast: return .fast
        }
    }
    
    static func from(seconds: Double) -> AutoScrollSpeed {
        switch seconds {
        case 0.5: return .verySlow
        case 0.25: return .slow
        case 0.15: return .medium
        case 0.05: return .fast
        case 0.025: return .veryFast
        default:
            return .medium
        }
    }
}


