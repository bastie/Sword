/*
 * SPDX-FileCopyrightText: 2023 - Sebastian Ritter <bastie@users.noreply.github.com>
 * SPDX-License-Identifier: MIT
 */

// "toString()" implementation
extension UInt4: CustomStringConvertible {
    
    //breaking change: using now LosslessStringConvertible
    /*
    public var description: String {
        return "0x" + String(value, radix: 16).uppercased()
    }
    */
}
