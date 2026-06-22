import SwiftUI

struct HomeView: View {
    var forceScreen: String? = nil
    @EnvironmentObject var appModel: AppModel
    @EnvironmentObject var store: Store

    @State private var showSettings = false
    @State private var showPaywall = false
    @State private var showInsights = false
    @State private var showThemeDetail = false

    var body: some View {
        NavigationStack {
            ZStack {
                QMBackground()
                ScrollView {
                    VStack(spacing: 24) {
                        // Hero: this week's theme
                        if let theme = appModel.currentWeekTheme {
                            thisWeekCard(theme: theme)
                        } else {
                            Text("No theme available this week.")
                                .foregroundStyle(.secondary)
                                .padding()
                        }

                        // Stats row
                        HStack(spacing: 12) {
                            MetricTile(value: "\(appModel.allThemes.count)", label: "Themes")
                            MetricTile(value: "\(appModel.savedThemes.count)", label: "Saved")
                            MetricTile(value: "\(appModel.triedLogs.count)", label: "Tried")
                        }
                        .padding(.horizontal)

                        // Pro unlock tile
                        proTile

                        Spacer(minLength: 32)
                    }
                    .padding(.top, 8)
                }
            }
            .navigationTitle("Tablescape")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        Haptics.tap()
                        showSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                            .foregroundStyle(Color.qmAccent)
                    }
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
                    .environmentObject(store)
                    .environmentObject(appModel)
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView()
                    .environmentObject(store)
            }
            .sheet(isPresented: $showInsights) {
                InsightsView()
                    .environmentObject(appModel)
                    .environmentObject(store)
            }
            .sheet(isPresented: $showThemeDetail) {
                if let theme = appModel.currentWeekTheme {
                    ThemeDetailView(theme: theme)
                        .environmentObject(appModel)
                        .environmentObject(store)
                }
            }
            .onAppear {
                if let screen = forceScreen {
                    switch screen {
                    case "paywall": showPaywall = true
                    case "insights": showInsights = true
                    case "settings": showSettings = true
                    default: break
                    }
                }
            }
        }
    }

    // MARK: - This Week Card

    private func thisWeekCard(theme: TableTheme) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("THIS WEEK")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                    Text(theme.title)
                        .font(.title2.weight(.bold))
                        .foregroundStyle(.primary)
                    Text(theme.season)
                        .font(.subheadline)
                        .foregroundStyle(Color.qmAccent)
                }
                Spacer()
                // Palette swatches
                HStack(spacing: 6) {
                    ForEach(theme.palette.prefix(4), id: \.self) { hex in
                        Circle()
                            .fill(Color(hex: hex))
                            .frame(width: 22, height: 22)
                            .overlay(Circle().stroke(Color.qmHair, lineWidth: 0.5))
                    }
                }
            }

            Divider()

            // Items needed
            VStack(alignment: .leading, spacing: 8) {
                Text("What you'll need")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
                ForEach(theme.items, id: \.self) { item in
                    HStack(spacing: 10) {
                        Image(systemName: "circle.fill")
                            .font(.system(size: 5))
                            .foregroundStyle(Color.qmAccent)
                        Text(item)
                            .font(.subheadline)
                            .foregroundStyle(.primary)
                    }
                }
            }

            Divider()

            Button {
                Haptics.tap()
                showThemeDetail = true
            } label: {
                Text("See How-To Steps")
                    .frame(maxWidth: .infinity)
            }
            .prominentButton()
        }
        .qmCard()
        .padding(.horizontal)
    }

    // MARK: - Pro Tile

    private var proTile: some View {
        Button {
            Haptics.tap()
            if store.isPro {
                showInsights = true
            } else {
                showPaywall = true
            }
        } label: {
            HStack(spacing: 16) {
                Image(systemName: store.isPro ? "archivebox.fill" : "lock.fill")
                    .font(.title2)
                    .foregroundStyle(Color.qmAccent)
                    .frame(width: 36)

                VStack(alignment: .leading, spacing: 3) {
                    Text(store.isPro ? "Browse the Archive" : "Unlock Tablescape Pro")
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(.primary)
                    Text(store.isPro ? "All past themes, filters & saved sets" : "Full archive, saves, filters — \(store.displayPrice)/mo")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(Color.qmAccent)
            }
            .qmCard()
            .padding(.horizontal)
        }
        .buttonStyle(.plain)
    }
}
