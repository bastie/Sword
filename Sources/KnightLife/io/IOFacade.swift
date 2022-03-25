/*
 * SPDX-FileCopyrightText: 2022 - Sebastian Ritter <bastie@users.noreply.github.com>
 * SPDX-License-Identifier: MIT
 */
import Foundation

///
/// IOFacade
///
public struct IOFacade {
    
    private static let fileManagerInstance = FileManager()
    
    static public func exists (atPath: String) -> Bool {
        return fileManagerInstance.fileExists (atPath: atPath)
    }
    
    static public func isDirectory (atPath: String) -> Bool {
        return fileManagerInstance.isDirectory(atPath: atPath)
    }
}

// MARK: FileManager extension
/// Extension of file manager
extension FileManager {
    func isDirectory(atPath: String) -> Bool {
        var check: ObjCBool = false
        if fileExists(atPath: atPath, isDirectory: &check) {
            return check.boolValue
        } else {
            return false
        }
    }
}
