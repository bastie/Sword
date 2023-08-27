/*
 * SPDX-FileCopyrightText: 2022-2023 - Sebastian Ritter <bastie@users.noreply.github.com>
 * SPDX-License-Identifier: MIT
 */
@available(*, deprecated, message: "Please use UInt4 instead.")
public struct NibbleContainer {
    @available(*, deprecated, renamed: "NibbleContainer.combine", message: "Please use UInt4 instead.")
    public static func create (left : UInt8, right : UInt8) -> UInt8 {
        #if DEBUG
        guard left < 16, right < 16 else {
            print("E-@NC-#001 § Nibble overflow with left=\(left) and right=\(right)")
            return 0
        }
        #endif
        
        let container : UInt8 = (left << 4) + right
        
        return container
    }
    
    public static func combine (left: UInt4, right: UInt4) -> UInt8 {
        return UInt4.combineNibblesToByte(left, right)
    }
    
    @available(*, deprecated, renamed: "NibbleContainer.combine", message: "Please use UInt4 instead.")
    public static func create (nibbles : (left : UInt8, right : UInt8)) -> UInt8 {
        create(left: nibbles.left, right: nibbles.right)
    }
    public static func combine (nibbles : (left: UInt4, right: UInt4)) -> UInt8 {
        return UInt4.combineNibblesToByte(nibbles.left, nibbles.right)
    }
    

    @available(*, deprecated, renamed: "NibbleContainer.split", message: "Please use UInt4 instead.")
    public static func destroy (container : UInt8) -> (left : UInt8, right : UInt8) {
        let right : UInt8 = (container << 4) >> 4
        let left : UInt8 = (container >> 4)
        
        return (left,right)
    }
    public static func split (container: UInt8) -> (left: UInt4, right: UInt4) {
        return UInt4.splitByteIntoNibbles(container)
    }
    
}
