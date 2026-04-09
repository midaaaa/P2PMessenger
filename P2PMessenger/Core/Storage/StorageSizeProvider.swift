import Foundation

protocol StorageSizeProviding {
    func calculateSize() async -> Int64
}

final class AppStorageSizeProvider: StorageSizeProviding {
    func calculateSize() async -> Int64 {
        await Task.detached(priority: .utility) {
            guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                return 0
            }
            let containerURL = documentsURL.deletingLastPathComponent()
            return Self.directorySize(at: containerURL)
        }.value
    }

    private static func directorySize(at url: URL) -> Int64 {
        let fileManager = FileManager.default
        guard let enumerator = fileManager.enumerator(
            at: url,
            includingPropertiesForKeys: [.fileSizeKey, .isRegularFileKey]
        ) else { return 0 }

        var total: Int64 = 0
        for case let fileURL as URL in enumerator {
            guard let values = try? fileURL.resourceValues(forKeys: [.fileSizeKey, .isRegularFileKey]),
                  values.isRegularFile == true,
                  let fileSize = values.fileSize else { continue }
            total += Int64(fileSize)
        }
        return total
    }
}
