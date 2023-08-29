/*
 * SPDX-FileCopyrightText: 2023 - Sebastian Ritter <bastie@users.noreply.github.com>
 * SPDX-License-Identifier: MIT
 */

// extends Int8 with constructor for UInt4
extension Int8 {
    init (_ int4: UInt4) {
        self.init(int4.getValue())
    }
}
