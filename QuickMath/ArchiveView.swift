import SwiftUI

struct InsightsView: View {
    @EnvironmentObject var appModel: AppModel
    @EnvironmentObject var store: Store
    @Environment(\.dismiss) private var dismiss

    @State private var selectedSeason: String? = nil
    @State private var selectedTheme: TableTheme? = nil
    @State private var showDetail = false
    @State private var tab: InsightsTab = .archive

    enum InsightsTab: String, CaseIterable {
        case archive = "Archive"
        case saved = "Saved"
        case tried = "Tried"
    }

    var filteredThemes: [TableTheme] {
        appModel.themes(forSeason: selectedSeason)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                QMBackground()
                VStack(spacing: 0) {
                    // Segment picker
                    Picker("Tab", selection: $tab) {
                        ForEach(InsightsTab.allCases, id: \.self) { t in
                            Text(t.rawValue).tag(t)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    .padding(.top, 8)
                    .padding(.bottom, 12)

                    switch tab {
                    case .archive:
                        archiveList
                    case .saved:
                        savedList
                    case .tried:
                        triedList
                    }
                }
            }
            .navigationTitle("Tablescape Pro")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") { dismiss() }
                        .foregroundStyle(Color.qmAccent)
                }
            }
        }
        .sheet(isPresented: $showDetail) {
            if let t = selectedTheme {
                ThemeDetailView(theme: t)
                    .environmentObject(appModel)
                    .environmentObject(store)
            }
        }
    }

    // MARK: - Archive Tab

    private var archiveList: some View {
        VStack(spacing: 0) {
            // Season filter
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    filterPill("All", isSelected: selectedSeason == nil) {
                        selectedSeason = nil
                    }
                    ForEach(appModel.allSeasons, id: \.self) { season in
                        filterPill(season, isSelected: selectedSeason == season) {
                            selectedSeason = selectedSeason == season ? nil : season
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
            }

            if filteredThemes.isEmpty {
                Spacer()
                Text("No themes found.")
                    .foregroundStyle(.secondary)
                Spacer()
            } else {
                List {
                    ForEach(filteredThemes, id: \.id) { theme in
                        themeRow(theme)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                Haptics.tap()
                                selectedTheme = theme
                                showDetail = true
                            }
                    }
                    .listRowBackground(Color.qmCard)
                }
                .listStyle(.insetGrouped)
                .scrollContentBackground(.hidden)
            }
        }
    }

    // MARK: - Saved Tab

    private var savedList: some View {
        Group {
            if appModel.savedThemes.isEmpty {
                VStack(spacing: 16) {
                    Spacer()
                    Image(systemName: "bookmark")
                        .font(.system(size: 44, weight: .light))
                        .foregroundStyle(Color.qmAccent)
                    Text("No saved themes yet.")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    Text("Tap the bookmark on any theme to save it here.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    Spacer()
                }
            } else {
                List {
                    ForEach(appModel.savedThemes, id: \.id) { saved in
                        if let theme = appModel.allThemes.first(where: { $0.id == saved.themeId }) {
                            themeRow(theme)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    Haptics.tap()
                                    selectedTheme = theme
                                    showDetail = true
                                }
                        }
                    }
                    .listRowBackground(Color.qmCard)
                }
                .listStyle(.insetGrouped)
                .scrollContentBackground(.hidden)
            }
        }
    }

    // MARK: - Tried Tab

    private var triedList: some View {
        Group {
            if appModel.triedLogs.isEmpty {
                VStack(spacing: 16) {
                    Spacer()
                    Image(systemName: "checkmark.circle")
                        .font(.system(size: 44, weight: .light))
                        .foregroundStyle(Color.qmAccent)
                    Text("Nothing tried yet.")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    Text("Open a theme and mark it as tried to track your hosting history.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    Spacer()
                }
            } else {
                List {
                    ForEach(appModel.triedLogs, id: \.id) { log in
                        if let theme = appModel.allThemes.first(where: { $0.id == log.themeId }) {
                            VStack(alignment: .leading, spacing: 4) {
                                themeRow(theme)
                                if !log.notes.isEmpty {
                                    Text(log.notes)
                                        .font(.footnote)
                                        .foregroundStyle(.secondary)
                                        .lineLimit(2)
                                }
                                Text(log.triedDate.formatted(date: .abbreviated, time: .omitted))
                                    .font(.caption)
                                    .foregroundStyle(.tertiary)
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                Haptics.tap()
                                selectedTheme = theme
                                showDetail = true
                            }
                        }
                    }
                    .listRowBackground(Color.qmCard)
                }
                .listStyle(.insetGrouped)
                .scrollContentBackground(.hidden)
            }
        }
    }

    // MARK: - Helpers

    private func themeRow(_ theme: TableTheme) -> some View {
        HStack(spacing: 14) {
            // Mini palette
            HStack(spacing: 4) {
                ForEach(theme.palette.prefix(3), id: \.self) { hex in
                    Circle()
                        .fill(Color(hex: hex))
                        .frame(width: 14, height: 14)
                }
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(theme.title)
                    .font(.body.weight(.medium))
                    .foregroundStyle(.primary)
                Text(theme.season)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            if appModel.isSaved(theme.id) {
                Image(systemName: "bookmark.fill")
                    .font(.caption)
                    .foregroundStyle(Color.qmAccent)
            }
            Image(systemName: "chevron.right")
                .font(.caption.weight(.medium))
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 4)
    }

    private func filterPill(_ title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.weight(isSelected ? .semibold : .regular))
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(isSelected ? Color.qmAccent : Color.qmCard, in: Capsule())
                .foregroundStyle(isSelected ? .white : .primary)
        }
        .buttonStyle(.plain)
    }
}
