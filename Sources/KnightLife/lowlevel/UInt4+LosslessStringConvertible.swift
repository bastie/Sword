extension UInt4: LosslessStringConvertible {
    public init?(_ description: String) {
        guard let intValue = UInt8(description, radix: 16), intValue <= UInt8(UInt4.max) else {
            return nil
        }
        self.init(intValue)
    }

    public var description: String {
        return String(value, radix: 16).uppercased()
    }
}
