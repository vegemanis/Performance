import SwiftUI

enum SongSorting: String {
    case titleAsc = "Title A->Z"
    case titleDesc = "Title Z->A"
    case artistAsc = "Artist A->Z"
    case artistDesc = "Artist Z->A"
    case createdAsc = "Created Date Old->New"
    case createdDesc = "Created Date New->Old"
    case modifiedAsc = "Modified Date Old->New"
    case modifiedDesc = "Modified Date New->Old"
    
    func sortDescriptor() -> NSSortDescriptor {
        switch self {
        case .titleAsc:
            return NSSortDescriptor(key: NSExpression(forKeyPath: \Song.title).keyPath, ascending: true, selector: #selector(NSString.caseInsensitiveCompare))
        case .titleDesc:
            return NSSortDescriptor(key: NSExpression(forKeyPath: \Song.title).keyPath, ascending: false, selector: #selector(NSString.caseInsensitiveCompare))
        case .artistAsc:
            return NSSortDescriptor(key: NSExpression(forKeyPath: \Song.artist).keyPath, ascending: true, selector: #selector(NSString.caseInsensitiveCompare))
        case .artistDesc:
            return NSSortDescriptor(key: NSExpression(forKeyPath: \Song.artist).keyPath, ascending: false, selector: #selector(NSString.caseInsensitiveCompare))
        case .createdAsc:
            return NSSortDescriptor(keyPath: \Song.createdDate, ascending: true)
        case .createdDesc:
            return NSSortDescriptor(keyPath: \Song.createdDate, ascending: false)
        case .modifiedAsc:
            return NSSortDescriptor(keyPath: \Song.modifiedDate, ascending: true)
        case .modifiedDesc:
            return NSSortDescriptor(keyPath: \Song.modifiedDate, ascending: false)
        }
    }

    func actionTitle(_ value: SongSorting) -> Text {
        Text(value == self ? "[ \(value.rawValue) ]" : value.rawValue)
    }
}
