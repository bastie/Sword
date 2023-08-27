/*
 * SPDX-FileCopyrightText: 2023 - Sebastian Ritter <bastie@users.noreply.github.com>
 * SPDX-License-Identifier: MIT
 */

///
///  UInt4.swift
///
/// Example UInt4-Array
/// ```Swift
///    var uint4Array: [UInt4] = [2, 3, 1]
/// ```
///
/// Use convert function to [UInt8]
/// ```Swift
///    let uint8Array = uint4Array.convert(to: UInt8.self)
///    print(uint8Array) // Output: [35, 10]
/// ```
///
/// Convert [UInt4] from [UInt8]
/// ```Swift
///    let input : [UInt8] = [255]
///    print(input)
///    uint4Array = input.convertToInt4Array()
///    print(uint4Array)
/// ```
///
/// Use all values over helper range
/// ```Swift
///     for value in UInt4.allValues {
///     }
/// ```
///
public struct UInt4 {
    private var value: UInt8 = 0 // 4-Bit-Field
    
    public init() {} // Init
    
    public mutating func setValue(_ newValue: UInt8) {
        let _ : UInt8 = 255 - 16 + value
        guard newValue <= 0xF else {
            fatalError("Invalid value for UInt4. Value must be between 0 and 15.")
        }
        value = newValue
    }
    
    public func getValue() -> UInt8 {
        return value
    }
    
}

extension UInt4 {
    /// Combine two ```UInt4``` to ```UInt8```
    /// - Parameters:
    ///    - nibble1: ```UInt4``` high value
    ///    - nibble2: ```UInt4``` low value
    /// - Returns: ```UInt8```
    public static func combineNibblesToByte(_ nibble1: UInt4, _ nibble2: UInt4) -> UInt8 {
        let byte: UInt8 = (nibble1.getValue() << 4) | nibble2.getValue()
        return byte
    }
    
    /// Convert a ```UInt8``` to UInt4 Tupel
    ///
    /// - Parameters:
    ///    - byte: ```UInt8```
    /// - Returns: ```(UInt4, UInt4) ```
    public static func splitByteIntoNibbles(_ byte: UInt8) -> (UInt4, UInt4) {
        var nibble1 = UInt4()
        var nibble2 = UInt4()
        
        nibble1.setValue(byte >> 4)       // Erste 4 Bits (höhere Bits)
        nibble2.setValue(byte & 0x0F)     // Letzte 4 Bits (niedrigere Bits)
        
        return (nibble1, nibble2)
    }
    
    /// Convert [UInt4] to [UInt8]
    ///
    /// - Parameters:
    ///   - int4Array: [UInt4]
    ///
    /// - Returns:[UInt8]
    public static func convertUInt4ArrayToUInt8Array(_ int4Array: [UInt4]) -> [UInt8] {
        var uint8Array: [UInt8] = []

        var currentUInt8Value: UInt8 = 0
        var isHighNibble = true

        for int4Value in int4Array {
            if isHighNibble {
                currentUInt8Value = UInt8(int4Value) << 4
            } else {
                currentUInt8Value |= UInt8(int4Value)
                uint8Array.append(currentUInt8Value)
            }
            
            isHighNibble.toggle()
        }

        // Wenn die Schleife beendet ist und isHighNibble noch auf "false" steht,
       // fügen wir den aktuellen Int8-Wert trotzdem hinzu, da er unvollständig ist.
       if !isHighNibble {
           uint8Array.append(currentUInt8Value)
       }

        return uint8Array
    }
}

// needed to use ==
extension UInt4 : Equatable {
    /// Implementing the ```Equatable``` protocol to use ```==``` in Code
    static public func ==(lhs: UInt4, rhs: UInt4) -> Bool {
        return lhs.value == rhs.value
    }
}

// Extending Array for me
extension Array where Element == UInt8 {
    /// Convert ```[UInt8]``` to ```[UInt4]```
    ///
    /// - Returns: ```[UInt4]```
    func convertToInt4Array() -> [UInt4] {
        var uint4Array: [UInt4] = []
        
        for uint8Value in self {
            var nibble1 = UInt4()
            var nibble2 = UInt4()
            
            nibble1.setValue(UInt8(uint8Value) >> 4)
            nibble2.setValue(UInt8(uint8Value) & 0x0F)
            
            uint4Array.append(nibble1)
            uint4Array.append(nibble2)
        }
        
        return uint4Array
    }
}

// Extending Array for me
extension Array where Element == UInt4 {
    /// Convert ```[UInt4]``` to ```[UInt8]```
    ///
    /// - Returns: ```[UInt8]```

    func convertToUInt8Array() -> [UInt8] {
        var uint8Array: [UInt8] = []

        var currentUInt8Value: UInt8 = 0
        var isHighNibble = true

        for int4Value in self {
            if isHighNibble {
                currentUInt8Value = UInt8(int4Value) << 4
            } else {
                currentUInt8Value |= UInt8(int4Value)
                uint8Array.append(currentUInt8Value)
            }
            
            isHighNibble.toggle()
        }

        // Wenn die Schleife beendet ist und isHighNibble noch auf "false" steht,
       // fügen wir den aktuellen Int8-Wert trotzdem hinzu, da er unvollständig ist.
       if !isHighNibble {
           uint8Array.append(currentUInt8Value)
       }

        return uint8Array
    }
    
}

// Other Extending Array with a littlebit mor generic
extension Array where Element == UInt4 {
    /// Convert ```[UInt4]``` to other BinaryInteger type
    func convert<T : BinaryInteger>(to targetType: T.Type) -> [T] {
        let uint8Array = self.convertToUInt8Array()
        return uint8Array.map { T($0) }
    }
}

// "toString()" implementation
extension UInt4: CustomStringConvertible {
    public var description: String {
        return "0x" + String(value, radix: 16).uppercased()
    }
}


extension UInt4: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "\(value)"
    }
}

extension UInt4: FixedWidthInteger, UnsignedInteger {
    
    public static var bitWidth: Int {
        return 4
    }
    
    public var trailingZeroBitCount: Int {
        return value.trailingZeroBitCount
    }
    
    public init<T>(_ source: T) where T: BinaryInteger {
        let clampedValue = UInt8(truncatingIfNeeded: source) & 0x0F
        value = clampedValue
    }
    
    public func addingReportingOverflow(_ rhs: UInt4) -> (partialValue: UInt4, overflow: Bool) {
        let result = UInt4(truncatingIfNeeded: UInt(self) + UInt(rhs))
        let overflow = (result.value & 0xF0) != 0
        return (result, overflow)
    }
    
    public func subtractingReportingOverflow(_ rhs: UInt4) -> (partialValue: UInt4, overflow: Bool) {
        let result = UInt4(truncatingIfNeeded: UInt(self) - UInt(rhs))
        let overflow = (result.value & 0xF0) != 0
        return (result, overflow)
    }
    
    public func multipliedReportingOverflow(by rhs: UInt4) -> (partialValue: UInt4, overflow: Bool) {
        let result = UInt4(truncatingIfNeeded: UInt(self) * UInt(rhs))
        let overflow = (result.value & 0xF0) != 0
        return (result, overflow)
    }
    
    public func dividedReportingOverflow(by rhs: UInt4) -> (partialValue: UInt4, overflow: Bool) {
        if rhs == 0 {
            return (0, true) // Division by zero
        }
        let result = UInt4(truncatingIfNeeded: UInt(self) / UInt(rhs))
        return (result, false)
    }
    
    public func remainderReportingOverflow(dividingBy rhs: UInt4) -> (partialValue: UInt4, overflow: Bool) {
        if rhs == 0 {
            return (0, true) // Division by zero
        }
        let result = UInt4(truncatingIfNeeded: UInt(self) % UInt(rhs))
        return (result, false)
    }
    
    public func dividingFullWidth(_ dividend: (high: UInt4, low: UInt8)) -> (quotient: UInt4, remainder: UInt4) {
        let dividendValue = UInt(dividend.high) << 8 + UInt(dividend.low)
        let quotient = UInt4(truncatingIfNeeded: dividendValue / UInt(self))
        let remainder = UInt4(truncatingIfNeeded: dividendValue % UInt(self))
        return (quotient, remainder)
    }
    
    public var nonzeroBitCount: Int {
        return value.nonzeroBitCount
    }
    
    public var leadingZeroBitCount: Int {
        return value.leadingZeroBitCount
    }
    
    public var byteSwapped: UInt4 {
        return UInt4(truncatingIfNeeded: value.byteSwapped)
    }
}

// some trouble here
extension UInt4: BinaryInteger {
    public typealias Words = UInt8.Words
    //public typealias Words = [UInt]
    // for ClosedRange<UInt4>
    static public var min: UInt4 { return UInt4(0) }
    // for ClosedRange<UInt4>
    static public var max: UInt4 { return UInt4(15) }
    public static var isSigned: Bool {
        return false
    }
    
    public init<T>(_truncatingBits bits: T) where T: BinaryInteger {
            let clampedValue = UInt8(truncatingIfNeeded: bits) & 0x0F
            value = clampedValue
        }
    
    /*public init<T>(clamping source: T) where T: BinaryInteger {
        let clampedValue = UInt8(clamping: source) & 0x0F
        value = clampedValue
    }*/
    
    public init<T>(clamping source: T) where T: BinaryInteger {
        let clampedValue = Swift.max(UInt8(0), Swift.min(UInt8(source), UInt8(UInt4.max)))
        self.init(clampedValue)
    }
    public init<T>(exactly source: T) where T: BinaryInteger {
        guard let UIntValue = UInt8(exactly: source), UIntValue <= 0x0F else {
            fatalError("Invalid value for Nibble. Value must be between 0 and 15.")
        }
        value = UIntValue
    }

    public var words: UInt8.Words {
        return UInt8(value).words
    }
        
    public func wordsFullWidth() -> UInt8.Words {
        return words
    }
    
    
    public static func / (lhs: UInt4, rhs: UInt4) -> UInt4 {
        var result = lhs
        result.value = (lhs.value / rhs.value) & 0x0F
        return result
    }
    public static func /= (lhs: inout UInt4, rhs: UInt4) {
        lhs = lhs / rhs
    }
    
    public static func % (lhs: UInt4, rhs: UInt4) -> UInt4 {
        guard rhs != 0 else {
                fatalError("Division by zero")
            }
            
            let result = UInt4(truncatingIfNeeded: UInt(lhs) % UInt(rhs))
            return result
    }
    
    public static func %= (lhs: inout UInt4, rhs: UInt4) {
        lhs = lhs % rhs
    }
    
    public static func & (lhs: UInt4, rhs: UInt4) -> UInt4 {
        let result = UInt4(truncatingIfNeeded: UInt(lhs) & UInt(rhs))
        return result
    }
    
    public static func &= (lhs: inout UInt4, rhs: UInt4) {
        lhs = lhs & rhs
    }
    
    public static func | (lhs: UInt4, rhs: UInt4) -> UInt4 {
            let result = UInt4(truncatingIfNeeded: UInt(lhs) | UInt(rhs))
            return result
        }
    public static func |= (lhs: inout UInt4, rhs: UInt4) {
        lhs = lhs | rhs
    }
    
    public static func ^ (lhs: UInt4, rhs: UInt4) -> UInt4 {
        let result = UInt4(truncatingIfNeeded: UInt(lhs) ^ UInt(rhs))
        return result
    }
    public static func ^= (lhs: inout UInt4, rhs: UInt4) {
        lhs = lhs ^ rhs
    }
    
}

// this helps also in the IDE but only on one side :-(
extension UInt4: ExpressibleByIntegerLiteral {
    public typealias UIntegerLiteralType = UInt8
    
    public init(integerLiteral value: UIntegerLiteralType) {
        guard value <= 0x0F else {
            fatalError("Invalid value for UInt4. Value must be between 0 and 15.")
        }
        self.value = value
    }
}

extension UInt4: Numeric {
    public typealias Magnitude = UInt8
    
    public var magnitude: Magnitude {
        return value
    }
    
    public static func + (lhs: UInt4, rhs: UInt4) -> UInt4 {
        var result = lhs
        result.value = (lhs.value + rhs.value) & 0x0F
        return result
    }
    
    public static func - (lhs: UInt4, rhs: UInt4) -> UInt4 {
        var result = lhs
        result.value = (lhs.value - rhs.value) & 0x0F
        return result
    }
    
    public static func * (lhs: UInt4, rhs: UInt4) -> UInt4 {
        var result = lhs
        result.value = (lhs.value * rhs.value) & 0x0F
        return result
    }
    
    public static func *= (lhs: inout UInt4, rhs: UInt4) {
        lhs = lhs * rhs
    }
    
    public init?<T>(exactly source: T) where T: BinaryFloatingPoint {
        guard let UIntValue = UInt8(exactly: source), UIntValue <= UInt4.max else {
            return nil
        }
        value = UIntValue
    }
}

// Implement Codable protocol
extension UInt4: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let intValue = try container.decode(UInt8.self)
        self.init(intValue)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.value)
    }
}


// extends UInt8 with constructor for UInt4
extension UInt8 {
    init(_ int4: UInt4) {
        self.init(int4.getValue())
    }
}
// extends Int8 with constructor for UInt4
extension Int8 {
    init (_ int4: UInt4) {
        self.init(int4.getValue())
    }
}



// ClosedRange not working today
/// Helper ```ClosedRange```Implementation
///
/// Example:
/// ```Swift
/// let myRange = UInt4Range (start: UInt4(0), end: UInt4(8))
/// ```
///
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
    static var allValues: UInt4Range {
        return UInt4Range(start: UInt4(0), end: UInt4(15))
    }
}
