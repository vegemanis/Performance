import Foundation
import SwiftUI
import MobileCoreServices

struct UIDocumentPickerViewControllerWrapper: UIViewControllerRepresentable {
    var callback: ([URL]) -> ()
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: UIViewControllerRepresentableContext<UIDocumentPickerViewControllerWrapper>) { }
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let controller = UIDocumentPickerViewController(documentTypes: [String(kUTTypeText)], in: .open)
        controller.allowsMultipleSelection = true
        controller.delegate = context.coordinator
        return controller
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: UIDocumentPickerViewControllerWrapper
        
        init(_ pickerController: UIDocumentPickerViewControllerWrapper) {
            self.parent = pickerController
        }
       
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            parent.callback(urls)
        }
    }
}

struct SongImportPicker: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Song.entity(), sortDescriptors: []) private var songList: FetchedResults<Song>

    var body: some View {
        UIDocumentPickerViewControllerWrapper { urls in
            var list = [Song]()
            for remoteUrl in urls {
                if self.songList.contains(where: { $0.source == remoteUrl }) {
                    continue
                }
                let isSecure = remoteUrl.startAccessingSecurityScopedResource()
                
                let song = Song(context: self.managedObjectContext)
                song.id = UUID()
                song.source = remoteUrl
                do {
                    song.text = try String(contentsOf: remoteUrl)
                 } catch {
                    print(error)
                    song.text = "<Unrecognized file encoding>"
                }
                song.createdDate = Date()
                song.modifiedDate = Date()
                
                let filename = remoteUrl.deletingPathExtension().lastPathComponent
                #if DEBUG
                let parts = filename.split(separator: "-")
                if parts.count == 2 {
                    song.artist = parts.first?.trimmingCharacters(in: .whitespaces).capitalized
                    song.title = parts.last?.trimmingCharacters(in: .whitespaces).capitalized
                } else {
                    song.title = filename
                }
                #else
                song.title = filename
                #endif

                list.append(song)
                
                if isSecure {
                    remoteUrl.stopAccessingSecurityScopedResource()
                }
            }
            try? self.managedObjectContext.save()
        }
    }
}
