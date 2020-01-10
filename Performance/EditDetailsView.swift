import SwiftUI

struct EditDetailsView<Content: View>: View {
    @Environment(\.presentationMode) var presentationMode
    private let created: Date?
    private let modified: Date?
    private let initialValues: (() -> Void)?
    private let onClose: (Bool) -> Void
    private let content: Content
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
        return formatter
    }()
    
    init(created: Date? = nil,
         modified: Date? = nil,
         initialValues: (() -> Void)? = nil,
         onClose: @escaping (Bool) -> Void,
         @ViewBuilder content: () -> Content) {
        self.created = created
        self.modified = modified
        self.initialValues = initialValues
        self.onClose = onClose
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Color(blueThemeColor).edgesIgnoringSafeArea([.leading, .trailing])
                HStack(alignment: .center) {
                    Button(action: {
                        self.onClose(false)
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "xmark")
                            Text("Close")
                        }
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Button(action: {
                            self.onClose(true)
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            HStack {
                                Image(systemName: "checkmark")
                                Text("Save")
                            }
                        }
                    }
                }
                .foregroundColor(.white)
                .padding()
            }
            .frame(height: 40)
            Form {
                Section {
                    content
                }
                Section {
                    if created != nil {
                        HStack {
                            Text("Created")
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text("\(self.dateFormatter.string(from: created!))")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    if modified != nil {
                        HStack {
                            Text("Modified")
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text("\(self.dateFormatter.string(from: modified!))")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
        }
        .onAppear() {
            self.initialValues?()
        }
    }
}
