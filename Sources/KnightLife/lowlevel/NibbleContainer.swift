/*
 * SPDX-FileCopyrightText: 2022 - Sebastian Ritter <bastie@users.noreply.github.com>
 * SPDX-License-Identifier: MIT
 */

public struct NibbleContainer {
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
    
    public static func create (nibbles : (left : UInt8, right : UInt8)) -> UInt8 {
        create(left: nibbles.left, right: nibbles.right)
    }
    
    public static func destroy (container : UInt8) -> (left : UInt8, right : UInt8) {
        let right : UInt8 = (container << 4) >> 4
        let left : UInt8 = (container >> 4)
        
        return (left,right)
    }
    
}
