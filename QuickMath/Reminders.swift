import Foundation
import UserNotifications

/// Optional local daily reminder to play the grid. Non-core (the puzzles work without it) and
/// purely on-device — no servers.
enum Reminders {
    private static let identifier = "tablescape.daily.reminder"

    static func requestAuthorization() async -> Bool {
        do { return try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) }
        catch { return false }
    }

    static func schedule(hour: Int, minute: Int) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [identifier])

        let content = UNMutableNotificationContent()
        content.title = "New tablescape idea this week!"
        content.body = "Open Tablescape to see this week's fresh table-setting theme."
        content.sound = .default

        var components = DateComponents()
        components.hour = hour
        components.minute = minute
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        center.add(UNNotificationRequest(identifier: identifier, content: content, trigger: trigger))
    }

    static func cancel() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
}
