import Foundation
import Testing
@testable import CodexBar

struct AutomaticUpdateInstallMigrationTests {
    @Test
    func `migration clears the install flag earlier builds forced on`() throws {
        try self.withDefaults { defaults in
            defaults.set(true, forKey: AutomaticUpdateInstallMigration.sparkleAutomaticallyUpdateKey)

            AutomaticUpdateInstallMigration.migrateIfNeeded(defaults: defaults)

            #expect(defaults.object(forKey: AutomaticUpdateInstallMigration.sparkleAutomaticallyUpdateKey) == nil)
            #expect(defaults.bool(forKey: AutomaticUpdateInstallMigration.completedKey))
        }
    }

    @Test
    func `a later opt in survives subsequent launches`() throws {
        try self.withDefaults { defaults in
            AutomaticUpdateInstallMigration.migrateIfNeeded(defaults: defaults)
            defaults.set(true, forKey: AutomaticUpdateInstallMigration.sparkleAutomaticallyUpdateKey)

            AutomaticUpdateInstallMigration.migrateIfNeeded(defaults: defaults)

            #expect(defaults.bool(forKey: AutomaticUpdateInstallMigration.sparkleAutomaticallyUpdateKey))
        }
    }

    @Test
    func `a later opt out survives subsequent launches`() throws {
        try self.withDefaults { defaults in
            AutomaticUpdateInstallMigration.migrateIfNeeded(defaults: defaults)
            defaults.set(false, forKey: AutomaticUpdateInstallMigration.sparkleAutomaticallyUpdateKey)

            AutomaticUpdateInstallMigration.migrateIfNeeded(defaults: defaults)

            #expect(defaults.object(forKey: AutomaticUpdateInstallMigration.sparkleAutomaticallyUpdateKey) as? Bool
                == false)
        }
    }

    @Test
    func `a fresh install keeps the opt in default`() throws {
        try self.withDefaults { defaults in
            AutomaticUpdateInstallMigration.migrateIfNeeded(defaults: defaults)

            #expect(defaults.object(forKey: AutomaticUpdateInstallMigration.sparkleAutomaticallyUpdateKey) == nil)
        }
    }

    private func withDefaults(_ body: (UserDefaults) throws -> Void) throws {
        let suite = "AutomaticUpdateInstallMigrationTests-\(UUID().uuidString)"
        let defaults = try #require(UserDefaults(suiteName: suite))
        defaults.removePersistentDomain(forName: suite)
        defer { defaults.removePersistentDomain(forName: suite) }
        try body(defaults)
    }
}
