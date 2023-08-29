/*
 * SPDX-FileCopyrightText: 2023 - Sebastian Ritter <bastie@users.noreply.github.com>
 * SPDX-License-Identifier: MIT
 */

// ClosedRange working today - this is deprecated
/// Helper ```ClosedRange```Implementation
///
/// Example:
/// ```Swift
/// let myRange = UInt4Range (start: UInt4(0), end: UInt4(8))
/// ```
///
@available(*, deprecated,  message: "use default syntax like 0...15 as ClosedRange<UInt4> instead of allValues")
public struct UInt4Range: Sequence, IteratorProtocol {
    private var current: Int
    private let end: Int

    init(start: UInt4, end: UInt4) {
        self.current = Int(start)
        self.end = Int(end)
    }

    public mutating func next() -> UInt4? {
        guard current <= end else {
            return nil
        }
        defer { current = current.advanced(by: 1) }
        return UInt4(current)
    }
}

// Helper Range to use like
// for next in UInt4.allValues {}
extension UInt4 {
    @available(*, deprecated,  message: "use default syntax like 0...15 as ClosedRange<UInt4> instead of allValues")
    public static var allValues: UInt4Range {
        return UInt4Range(start: UInt4(0), end: UInt4(15))
    }
}
