import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var appModel: AppModel
    @Environment(\.dismiss) private var dismiss

    @AppStorage("quickmath.theme") private var themeRaw = AppTheme.system.rawValue
    @State private var showPaywall = false
    @State private var showDeleteConfirm = false

    var body: some View {
        NavigationStack {
            ZStack {
                QMBackground()
                List {
                    // Pro status
                    Section("Subscription") {
                        if store.isPro {
                            HStack {
                                Image(systemName: "checkmark.seal.fill")
                                    .foregroundStyle(Color.qmAccent)
                                Text("Tablescape Pro — Active")
                                    .foregroundStyle(.primary)
                            }
                            Link(destination: URL(string: "https://apps.apple.com/account/subscriptions")!) {
                                HStack {
                                    Text("Manage Subscription")
                                    Spacer()
                                    Image(systemName: "arrow.up.right")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .foregroundStyle(Color.qmAccent)
                        } else {
                            Button {
                                Haptics.tap()
                                showPaywall = true
                            } label: {
                                HStack {
                                    Image(systemName: "lock.open.fill")
                                        .foregroundStyle(Color.qmAccent)
                                    Text("Unlock Tablescape Pro")
                                        .foregroundStyle(.primary)
                                    Spacer()
                                    Text(store.displayPrice + "/mo")
                                        .font(.subheadline)
                                        .foregroundStyle(Color.qmAccent)
                                }
                            }

                            Button("Restore Purchases") {
                                Haptics.tap()
                                Task { await store.restore() }
                            }
                            .foregroundStyle(Color.qmAccent)
                        }
                    }
                    .listRowBackground(Color.qmCard)

                    // Appearance
                    Section("Appearance") {
                        Picker("Theme", selection: $themeRaw) {
                            ForEach(AppTheme.allCases) { theme in
                                Text(theme.label).tag(theme.rawValue)
                            }
                        }
                        .pickerStyle(.segmented)
                        .listRowBackground(Color.qmCard)
                    }
                    .listRowBackground(Color.qmCard)

                    // Legal
                    Section("Legal") {
                        Link(destination: URL(string: "https://shimondeitel.github.io/tablescape-site/privacy.html")!) {
                            HStack {
                                Text("Privacy Policy")
                                    .foregroundStyle(.primary)
                                Spacer()
                                Image(systemName: "arrow.up.right")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .foregroundStyle(.primary)

                        Link(destination: URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!) {
                            HStack {
                                Text("Terms of Use")
                                    .foregroundStyle(.primary)
                                Spacer()
                                Image(systemName: "arrow.up.right")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .foregroundStyle(.primary)
                    }
                    .listRowBackground(Color.qmCard)

                    // Data
                    Section("Data") {
                        Button(role: .destructive) {
                            showDeleteConfirm = true
                        } label: {
                            Text("Delete All Data")
                        }
                    }
                    .listRowBackground(Color.qmCard)
                }
                .listStyle(.insetGrouped)
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") { dismiss() }
                        .foregroundStyle(Color.qmAccent)
                }
            }
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView()
                .environmentObject(store)
        }
        .confirmationDialog("Delete all saved data?", isPresented: $showDeleteConfirm, titleVisibility: .visible) {
            Button("Delete All", role: .destructive) {
                appModel.deleteAllData()
                Haptics.warning()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will remove all saved themes, tried logs, and theme data. This cannot be undone.")
        }
    }
}
