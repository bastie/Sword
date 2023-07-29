/*
 * SPDX-FileCopyrightText: 2022-2023 - Sebastian Ritter <bastie@users.noreply.github.com>
 * SPDX-License-Identifier: MIT
 */
import Foundation

@available(macOS 10.15.4, *)
public struct File {
    
    public static func readFully (contentsOf fileName : String) -> [UInt8] {
        let url = URL(fileURLWithPath: fileName)
        let content = [UInt8](try! Data(contentsOf: url))
        return content
    }

    public static func saveFully (contentsOf contents: [UInt8], into fileName: String) {
        FileManager.default.createFile(atPath: "./\(fileName)", contents: Data(contents))
    }
    
}
