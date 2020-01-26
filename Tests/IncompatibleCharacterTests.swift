//
//  IncompatibleCharacterTests.swift
//  Tests
//
//  CotEditor
//  https://coteditor.com
//
//  Created by 1024jp on 2016-05-29.
//
//  ---------------------------------------------------------------------------
//
//  © 2016-2020 1024jp
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  https://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import XCTest
@testable import CotEditor

final class IncompatibleCharacterTests: XCTestCase {
    
    func testIncompatibleCharacterScan() {
        
        let string = "abc\\ \n ¥ \n ~"
        let incompatibles = string.scanIncompatibleCharacters(for: .plainShiftJIS)
        
        XCTAssertEqual(incompatibles.count, 2)
        
        let backslash = incompatibles.first!
        
        XCTAssertEqual(backslash.character, "\\")
        XCTAssertEqual(backslash.convertedCharacter, "＼")
        XCTAssertEqual(backslash.location, 3)
        XCTAssertEqual(backslash.lineNumber, 1)
        
        let tilde = incompatibles[1]
        
        XCTAssertEqual(tilde.character, "~")
        XCTAssertEqual(tilde.convertedCharacter, "?")
        XCTAssertEqual(tilde.location, 11)
        XCTAssertEqual(tilde.lineNumber, 3)
    }
    
    
    func testSequencialIncompatibleCharactersScan() {
        
        let string = "~~"
        let incompatibles = string.scanIncompatibleCharacters(for: .plainShiftJIS)
        
        XCTAssertEqual(incompatibles.count, 2)
        
        let tilde = incompatibles[1]
        
        XCTAssertEqual(tilde.character, "~")
        XCTAssertEqual(tilde.convertedCharacter, "?")
        XCTAssertEqual(tilde.location, 1)
        XCTAssertEqual(tilde.lineNumber, 1)
    }
    
    
    func testIncompatibleCharacterScanWithLengthShift() {
        
        let string = "family 👨‍👨‍👦 with 🐕"
        let incompatibles = string.scanIncompatibleCharacters(for: .japaneseEUC)
        
        XCTAssertEqual(incompatibles.count, 2)
        
        XCTAssertEqual(incompatibles[0].character, "👨‍👨‍👦")
        XCTAssertEqual(incompatibles[0].convertedCharacter, "????????")
        XCTAssertEqual(incompatibles[0].location, 7)
        XCTAssertEqual(incompatibles[0].lineNumber, 1)
        
        XCTAssertEqual(incompatibles[1].character, "🐕")
        XCTAssertEqual(incompatibles[1].convertedCharacter, "??")
        XCTAssertEqual(incompatibles[1].location, 21)
        XCTAssertEqual(incompatibles[1].lineNumber, 1)
    }

}



private extension String.Encoding {
    
    static let plainShiftJIS = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.shiftJIS.rawValue)))
}
