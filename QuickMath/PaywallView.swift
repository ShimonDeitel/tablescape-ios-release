import SwiftUI

struct PaywallView: View {
    @EnvironmentObject var store: Store
    @Environment(\.dismiss) private var dismiss

    private let benefits: [String] = [
        "Browse the full archive of past weekly themes any time",
        "Save unlimited themes for holidays and dinner parties",
        "Filter themes by season, occasion and color palette"
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                QMBackground()
                ScrollView {
                    VStack(spacing: 28) {
                        // Icon
                        ZStack {
                            Circle()
                                .fill(Color.qmCard)
                                .frame(width: 88, height: 88)
                            Image(systemName: "fork.knife")
                                .font(.system(size: 38, weight: .light))
                                .foregroundStyle(Color.qmAccent)
                        }
                        .padding(.top, 32)

                        // Title
                        VStack(spacing: 8) {
                            Text("Tablescape Pro")
                                .font(.title.weight(.bold))
                                .foregroundStyle(.primary)
                            Text("$0.99 / month. Auto-renews until you cancel.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal)

                        // Benefits
                        VStack(alignment: .leading, spacing: 16) {
                            ForEach(benefits, id: \.self) { benefit in
                                HStack(alignment: .top, spacing: 14) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(Color.qmAccent)
                                        .font(.body)
                                        .padding(.top, 1)
                                    Text(benefit)
                                        .font(.body)
                                        .foregroundStyle(.primary)
                                    Spacer()
                                }
                            }
                        }
                        .qmCard()
                        .padding(.horizontal)

                        // CTA
                        VStack(spacing: 12) {
                            Button {
                                Haptics.tap()
                                Task { await store.purchase() }
                            } label: {
                                Group {
                                    if store.purchaseInFlight {
                                        ProgressView().tint(.white)
                                    } else {
                                        Text("Unlock for \(store.displayPrice)/month")
                                    }
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .prominentButton()
                            .disabled(store.purchaseInFlight)

                            Button {
                                Haptics.tap()
                                Task { await store.restore() }
                            } label: {
                                Text("Restore Purchases")
                                    .frame(maxWidth: .infinity)
                            }
                            .softButton()
                        }
                        .padding(.horizontal)

                        // Disclosure
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Subscription automatically renews at \(store.displayPrice)/month unless cancelled at least 24 hours before the end of the current period. Your account will be charged at confirmation of purchase. Manage or cancel at any time in your Apple Account settings.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)

                            HStack(spacing: 16) {
                                Link("Terms of Use", destination: URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!)
                                    .font(.caption.weight(.medium))
                                    .foregroundStyle(Color.qmAccent)
                                Link("Privacy Policy", destination: URL(string: "https://shimondeitel.github.io/tablescape-site/privacy.html")!)
                                    .font(.caption.weight(.medium))
                                    .foregroundStyle(Color.qmAccent)
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 32)
                    }
                }
            }
            .navigationTitle("Tablescape Pro")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") { dismiss() }
                        .foregroundStyle(Color.qmAccent)
                }
            }
            .onChange(of: store.isPro) { _, newValue in
                if newValue { dismiss() }
            }
        }
    }
}
