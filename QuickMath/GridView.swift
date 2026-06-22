import SwiftUI

// MARK: - Theme Detail View (primary entry/action screen)

struct ThemeDetailView: View {
    let theme: TableTheme
    @EnvironmentObject var appModel: AppModel
    @EnvironmentObject var store: Store
    @Environment(\.dismiss) private var dismiss

    @State private var showNoteEntry = false
    @State private var noteText = ""
    @State private var showTriedConfirm = false

    private var isSaved: Bool { appModel.isSaved(theme.id) }
    private var triedEntry: TriedLog? { appModel.triedEntry(for: theme.id) }

    var body: some View {
        NavigationStack {
            ZStack {
                QMBackground()
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Header
                        VStack(alignment: .leading, spacing: 6) {
                            Text(theme.season.uppercased())
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(Color.qmAccent)
                            Text(theme.title)
                                .font(.largeTitle.weight(.bold))
                                .foregroundStyle(.primary)
                        }

                        // Palette
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Palette")
                                .font(.headline.weight(.semibold))
                                .foregroundStyle(.secondary)
                            HStack(spacing: 12) {
                                ForEach(theme.palette, id: \.self) { hex in
                                    VStack(spacing: 4) {
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .fill(Color(hex: hex))
                                            .frame(height: 52)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                    .stroke(Color.qmHair, lineWidth: 0.5)
                                            )
                                        Text(hex)
                                            .font(.system(size: 9, design: .monospaced))
                                            .foregroundStyle(.secondary)
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                            }
                        }
                        .qmCard()

                        // Items needed
                        VStack(alignment: .leading, spacing: 12) {
                            Text("What You'll Need")
                                .font(.headline.weight(.semibold))
                                .foregroundStyle(.secondary)
                            ForEach(Array(theme.items.enumerated()), id: \.offset) { _, item in
                                HStack(alignment: .top, spacing: 12) {
                                    Image(systemName: "circle.fill")
                                        .font(.system(size: 6))
                                        .foregroundStyle(Color.qmAccent)
                                        .padding(.top, 6)
                                    Text(item)
                                        .font(.body)
                                        .foregroundStyle(.primary)
                                }
                            }
                        }
                        .qmCard()

                        // How-to steps
                        VStack(alignment: .leading, spacing: 16) {
                            Text("How To Set It")
                                .font(.headline.weight(.semibold))
                                .foregroundStyle(.secondary)
                            ForEach(Array(theme.steps.enumerated()), id: \.offset) { index, step in
                                HStack(alignment: .top, spacing: 14) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.qmAccent)
                                            .frame(width: 28, height: 28)
                                        Text("\(index + 1)")
                                            .font(.subheadline.weight(.bold))
                                            .foregroundStyle(.white)
                                    }
                                    Text(step)
                                        .font(.body)
                                        .foregroundStyle(.primary)
                                        .fixedSize(horizontal: false, vertical: true)
                                    Spacer()
                                }
                            }
                        }
                        .qmCard()

                        // Actions
                        VStack(spacing: 12) {
                            // Save button (Pro gate)
                            Button {
                                Haptics.tap()
                                if store.isPro || isSaved {
                                    appModel.toggleSave(theme.id)
                                } else {
                                    // allow saving free theme, but archive is pro
                                    appModel.toggleSave(theme.id)
                                }
                            } label: {
                                HStack {
                                    Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                                    Text(isSaved ? "Saved" : "Save This Theme")
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .prominentButton()

                            // Mark as tried
                            Button {
                                Haptics.tap()
                                if triedEntry != nil {
                                    showTriedConfirm = true
                                } else {
                                    showNoteEntry = true
                                }
                            } label: {
                                HStack {
                                    Image(systemName: triedEntry != nil ? "checkmark.circle.fill" : "checkmark.circle")
                                    Text(triedEntry != nil ? "You tried this" : "Mark as Tried")
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .softButton()

                            if let entry = triedEntry, !entry.notes.isEmpty {
                                Text("Your note: \(entry.notes)")
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                                    .padding(.horizontal, 4)
                            }
                        }

                        Spacer(minLength: 40)
                    }
                    .padding()
                }
            }
            .navigationTitle("Theme")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") { dismiss() }
                        .foregroundStyle(Color.qmAccent)
                }
            }
        }
        .sheet(isPresented: $showNoteEntry) {
            NoteEntryView(themeId: theme.id, noteText: $noteText)
                .environmentObject(appModel)
        }
        .confirmationDialog("You tried this!", isPresented: $showTriedConfirm, titleVisibility: .visible) {
            Button("Remove log", role: .destructive) {
                // no direct delete API, just do nothing for now
            }
            Button("Cancel", role: .cancel) {}
        }
    }
}

// MARK: - Note Entry View

struct NoteEntryView: View {
    let themeId: String
    @Binding var noteText: String
    @EnvironmentObject var appModel: AppModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                QMBackground()
                VStack(alignment: .leading, spacing: 16) {
                    Text("How did it go?")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    TextEditor(text: $noteText)
                        .frame(height: 140)
                        .padding(8)
                        .background(Color.qmCard, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                    Spacer()
                    Button {
                        appModel.logTried(themeId: themeId, notes: noteText)
                        Haptics.success()
                        dismiss()
                    } label: {
                        Text("Save Note")
                            .frame(maxWidth: .infinity)
                    }
                    .prominentButton()
                }
                .padding()
            }
            .navigationTitle("Mark as Tried")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundStyle(Color.qmAccent)
                }
            }
        }
    }
}

