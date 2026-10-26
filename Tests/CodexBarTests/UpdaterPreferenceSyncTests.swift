import Testing
@testable import CodexBar

@MainActor
struct UpdaterPreferenceSyncTests {
    @Test
    func `launch keeps a persisted install opt out while checks stay on`() {
        let updater = RecordingUpdater(automaticallyDownloadsUpdates: false)

        UpdaterPreferenceSync.applyAutomaticChecks(true, to: updater)

        #expect(updater.automaticallyChecksForUpdates)
        #expect(!updater.automaticallyDownloadsUpdates)
        #expect(updater.downloadWrites == 0)
    }

    @Test
    func `toggling automatic checks keeps an explicit install opt in`() {
        let updater = RecordingUpdater(automaticallyDownloadsUpdates: true)

        UpdaterPreferenceSync.applyAutomaticChecks(false, to: updater)
        UpdaterPreferenceSync.applyAutomaticChecks(true, to: updater)

        #expect(updater.automaticallyChecksForUpdates)
        #expect(updater.automaticallyDownloadsUpdates)
        #expect(updater.downloadWrites == 0)
    }

    @MainActor
    private final class RecordingUpdater: UpdaterProviding {
        var automaticallyChecksForUpdates = false
        var automaticallyDownloadsUpdates: Bool {
            didSet { self.downloadWrites += 1 }
        }

        /// Counts writes so a test also catches a write that happens to store the same value.
        private(set) var downloadWrites = 0
        let isAvailable = true
        let unavailableReason: String? = nil
        let updateStatus = UpdateStatus()

        init(automaticallyDownloadsUpdates: Bool) {
            self.automaticallyDownloadsUpdates = automaticallyDownloadsUpdates
        }

        func checkForUpdates(_ sender: Any?) {
            _ = sender
        }

        func installUpdate() {}
    }
}
