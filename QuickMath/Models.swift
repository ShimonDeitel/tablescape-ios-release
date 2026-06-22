import SwiftUI
import SwiftData

// MARK: - SwiftData Models

@Model
final class TableTheme {
    var id: String
    var title: String
    var season: String
    var palette: [String]
    var items: [String]
    var steps: [String]
    var weekFeatured: Int

    init(id: String, title: String, season: String, palette: [String], items: [String], steps: [String], weekFeatured: Int) {
        self.id = id
        self.title = title
        self.season = season
        self.palette = palette
        self.items = items
        self.steps = steps
        self.weekFeatured = weekFeatured
    }
}

@Model
final class SavedTheme {
    var id: String
    var themeId: String
    var savedDate: Date

    init(id: String, themeId: String, savedDate: Date) {
        self.id = id
        self.themeId = themeId
        self.savedDate = savedDate
    }
}

@Model
final class TriedLog {
    var id: String
    var themeId: String
    var triedDate: Date
    var notes: String

    init(id: String, themeId: String, triedDate: Date, notes: String) {
        self.id = id
        self.themeId = themeId
        self.triedDate = triedDate
        self.notes = notes
    }
}

// MARK: - Seed Data

extension TableTheme {
    static let seed: [TableTheme] = [
        TableTheme(
            id: "w01",
            title: "Autumn Harvest",
            season: "Fall",
            palette: ["#8B4513", "#D2691E", "#F4A460", "#FAEBD7"],
            items: ["Linen napkins", "Wooden charger plates", "Taper candles", "Mini pumpkins", "Dried wheat bundle"],
            steps: [
                "Lay the linen runner down the center of the table.",
                "Place wooden charger plates at each setting.",
                "Arrange mini pumpkins and dried wheat as a centerpiece.",
                "Set taper candles in brass holders between the pumpkins.",
                "Fold napkins into a bishop's hat and place on each plate."
            ],
            weekFeatured: 1
        ),
        TableTheme(
            id: "w02",
            title: "Winter Whites",
            season: "Winter",
            palette: ["#FFFFFF", "#F5F5F5", "#C0C0C0", "#007AFF"],
            items: ["White linen tablecloth", "Silver candlesticks", "Frosted pine branches", "White pillar candles", "Crystal glasses"],
            steps: [
                "Spread the white linen tablecloth smoothly.",
                "Place silver candlesticks at varying heights for drama.",
                "Tuck frosted pine branches and eucalyptus around the base.",
                "Set crystal glasses at each place for sparkle.",
                "Add a single blue napkin fold accent per place setting."
            ],
            weekFeatured: 2
        ),
        TableTheme(
            id: "w03",
            title: "Spring Garden Party",
            season: "Spring",
            palette: ["#FFB7C5", "#E8F5E9", "#FFF9C4", "#FFFFFF"],
            items: ["Pastel napkins", "Mason jar vases", "Fresh wildflowers", "Wicker placemats", "Twine-wrapped cutlery"],
            steps: [
                "Set wicker placemats at each place.",
                "Fill mason jars with fresh wildflowers for scattered centerpieces.",
                "Bundle cutlery with twine and tuck in a small sprig.",
                "Fold pastel napkins into simple triangles.",
                "Scatter a few loose petals around the table for a garden feel."
            ],
            weekFeatured: 3
        ),
        TableTheme(
            id: "w04",
            title: "Summer Shore",
            season: "Summer",
            palette: ["#E3F2FD", "#B3E5FC", "#F9A825", "#FFFFFF"],
            items: ["Blue striped runner", "Seashells", "Driftwood pieces", "Citrus slices", "White plates"],
            steps: [
                "Lay the blue striped runner lengthwise.",
                "Arrange driftwood and seashells as a natural centerpiece.",
                "Slice lemons and limes and scatter among the shells.",
                "Set clean white plates for contrast.",
                "Roll napkins and secure with a shell-adorned ring."
            ],
            weekFeatured: 4
        ),
        TableTheme(
            id: "w05",
            title: "Moody Midnight",
            season: "Winter",
            palette: ["#1A1A2E", "#16213E", "#E94560", "#F5F5F5"],
            items: ["Dark linen tablecloth", "Black taper candles", "Red roses", "Brass accents", "White charger plates"],
            steps: [
                "Cover the table with a deep navy or charcoal linen.",
                "Set white charger plates as a bold contrast.",
                "Place black taper candles in brass holders centrally.",
                "Arrange red roses low in small black vases.",
                "Fold white napkins crisply and place to the left of each plate."
            ],
            weekFeatured: 5
        ),
        TableTheme(
            id: "w06",
            title: "Provencal Lavender",
            season: "Summer",
            palette: ["#9B59B6", "#D7BDE2", "#F9E79F", "#FFFFFF"],
            items: ["Purple table runner", "Dried lavender bundles", "Yellow wildflowers", "Terracotta pots", "Cream linen napkins"],
            steps: [
                "Drape the purple runner down the center.",
                "Group small terracotta pots with dried lavender along the center.",
                "Add yellow wildflowers between the pots for warmth.",
                "Lay cream linen napkins flat with a simple lavender sprig on top.",
                "Use rustic wooden boards as placemats for an earthy feel."
            ],
            weekFeatured: 6
        ),
        TableTheme(
            id: "w07",
            title: "Nordic Hygge",
            season: "Winter",
            palette: ["#F5F5F5", "#D3D3D3", "#8B7355", "#007AFF"],
            items: ["Chunky knit table runner", "Pillar candles", "Pine cones", "Warm wool napkins", "Wooden serving boards"],
            steps: [
                "Lay the chunky knit runner for texture and warmth.",
                "Group pillar candles of different heights in the center.",
                "Scatter pine cones and small branches between candles.",
                "Fold wool napkins loosely and place at each setting.",
                "Set wooden serving boards as rustic charger plates."
            ],
            weekFeatured: 7
        ),
        TableTheme(
            id: "w08",
            title: "Citrus Brunch",
            season: "Spring",
            palette: ["#FFF176", "#FFE0B2", "#F48FB1", "#FFFFFF"],
            items: ["Yellow tablecloth", "Fresh orange and lemon halves", "White plates", "Striped linen napkins", "Small bud vases"],
            steps: [
                "Spread the bright yellow tablecloth.",
                "Halve citrus fruits and arrange in a line down the center.",
                "Tuck fresh herb sprigs between the citrus.",
                "Set a small bud vase with a single bloom at each place.",
                "Roll striped napkins and slide into a napkin ring."
            ],
            weekFeatured: 8
        ),
    ]
}

// MARK: - App Model

@MainActor
final class AppModel: ObservableObject {
    let container: ModelContainer
    weak var store: Store?

    @Published private(set) var allThemes: [TableTheme] = []
    @Published private(set) var savedThemes: [SavedTheme] = []
    @Published private(set) var triedLogs: [TriedLog] = []

    init(container: ModelContainer) {
        self.container = container
        reload()
    }

    static func makeContainer() -> ModelContainer {
        let schema = Schema([TableTheme.self, SavedTheme.self, TriedLog.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            let fallback = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
            return (try? ModelContainer(for: schema, configurations: [fallback])) ?? {
                fatalError("Cannot create ModelContainer: \(error)")
            }()
        }
    }

    func reload() {
        let ctx = container.mainContext
        do {
            let themes = try ctx.fetch(FetchDescriptor<TableTheme>(sortBy: [SortDescriptor(\.weekFeatured)]))
            if themes.isEmpty {
                for t in TableTheme.seed { ctx.insert(t) }
                try ctx.save()
                allThemes = try ctx.fetch(FetchDescriptor<TableTheme>(sortBy: [SortDescriptor(\.weekFeatured)]))
            } else {
                allThemes = themes
            }
            savedThemes = try ctx.fetch(FetchDescriptor<SavedTheme>(sortBy: [SortDescriptor(\.savedDate, order: .reverse)]))
            triedLogs = try ctx.fetch(FetchDescriptor<TriedLog>(sortBy: [SortDescriptor(\.triedDate, order: .reverse)]))
        } catch {
            allThemes = TableTheme.seed
        }
    }

    func refresh() { reload() }

    // MARK: - Current week theme

    var currentWeekTheme: TableTheme? {
        let week = Calendar.current.component(.weekOfYear, from: Date())
        return allThemes.first(where: { $0.weekFeatured == week }) ?? allThemes.first
    }

    // MARK: - Save / unsave

    func isSaved(_ themeId: String) -> Bool {
        savedThemes.contains(where: { $0.themeId == themeId })
    }

    func toggleSave(_ themeId: String) {
        let ctx = container.mainContext
        if let existing = savedThemes.first(where: { $0.themeId == themeId }) {
            ctx.delete(existing)
        } else {
            ctx.insert(SavedTheme(id: UUID().uuidString, themeId: themeId, savedDate: Date()))
        }
        try? ctx.save()
        reload()
    }

    // MARK: - Tried log

    func logTried(themeId: String, notes: String) {
        let ctx = container.mainContext
        ctx.insert(TriedLog(id: UUID().uuidString, themeId: themeId, triedDate: Date(), notes: notes))
        try? ctx.save()
        reload()
    }

    func triedEntry(for themeId: String) -> TriedLog? {
        triedLogs.first(where: { $0.themeId == themeId })
    }

    // MARK: - Filters

    func themes(forSeason season: String?) -> [TableTheme] {
        guard let season else { return allThemes }
        return allThemes.filter { $0.season == season }
    }

    var allSeasons: [String] {
        Array(Set(allThemes.map(\.season))).sorted()
    }

    // MARK: - Delete all

    func deleteAllData() {
        let ctx = container.mainContext
        for t in allThemes { ctx.delete(t) }
        for s in savedThemes { ctx.delete(s) }
        for l in triedLogs { ctx.delete(l) }
        try? ctx.save()
        reload()
    }
}
