import Foundation

/// Moves existing Sparkle installs onto the opt-in default for automatic update installs.
///
/// Earlier builds wrote the "Check for updates automatically" preference into both Sparkle flags on every launch,
/// so updates were downloaded and installed silently by default, and unticking Sparkle's "Automatically download
/// and install updates" checkbox was reverted on the next launch. Sparkle now owns the install choice through its
/// `SUAutomaticallyUpdate` default. Because the value CodexBar forced on cannot be told apart from a deliberate
/// choice, this runs once to clear it; anything the user chooses afterwards is left untouched.
enum AutomaticUpdateInstallMigration {
    /// Sparkle's user-defaults key behind `SPUUpdater.automaticallyDownloadsUpdates`.
    static let sparkleAutomaticallyUpdateKey = "SUAutomaticallyUpdate"
    static let completedKey = "automaticUpdateInstallOptInMigrated"

    static func migrateIfNeeded(defaults: UserDefaults = .standard) {
        guard !defaults.bool(forKey: self.completedKey) else { return }
        // Removing the key (rather than writing `false`) lets Sparkle fall back to the Info.plist default.
        defaults.removeObject(forKey: self.sparkleAutomaticallyUpdateKey)
        defaults.set(true, forKey: self.completedKey)
    }
}
