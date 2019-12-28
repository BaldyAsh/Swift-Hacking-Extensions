import Foundation
import XCTest

extension String {
    func onlyUniqueChars() -> Bool {
        return Set(self).count == self.count
    }
    
    func isPalindrome() -> Bool {
        return String(self.reversed()).lowercased() == self.lowercased()
    }
    
    func fuzzyContains(_ string: String) -> Bool {
        return range(of: string, options: .caseInsensitive) != nil
    }
    
    func sameChars(_ string: String) -> Bool {
        return self.filter({ $0 != " "}).sorted() == string.filter({ $0 != " "}).sorted()
    }
    
    func charCount(char: Character) -> Int {
        return self.filter({ $0 == char }).count
    }
    
    func removeDuplicate() -> String {
        var used = [Character]()
        for letter in self {
            if !used.contains(letter) {
                used.append(letter)
            }
        }
        return String(used)
        // worse performance
//        var used = [Character: Bool]()
//        return self.filter {
//            used.updateValue(true, forKey: $0) == nil
//        }
    }
    
    func condenceWhitespace() -> String {
        return self.replacingOccurrences(of: " +", with: " ", options: .regularExpression).replacingOccurrences(of: "\n+", with: " ", options: .regularExpression)
    }
    
    func isRotated(rotated: String) -> Bool {
        return (self+self).contains(rotated) && self.count == rotated.count
    }
    
    func isPangram() -> Bool {
        let set = Set(self)
            .filter { $0 >= "a" && $0 <= "z" }
            .sorted()
        return set.count == 26
    }
    
    func countVowelsAndConsonants() -> (vowels: Int, consonants: Int) {
        let vowelsList = "aeiou"
        let consonantsList = "bcdfghjklmnpqrstvwxyz"
        var vowelsCount = 0
        var consonantsCount = 0
        for letter in self.lowercased() {
            if vowelsList.contains(letter) {
                vowelsCount += 1
            } else if consonantsList.contains(letter) {
                consonantsCount += 1
            }
        }
        return (vowelsCount, consonantsCount)
    }
    
    func threeDifferentLetters(_ string: String) -> Bool {
        guard self.count == string.count else {return false}
        let sArray = Array(string)
        var diffs = 0
        for (i, char) in self.enumerated() {
            if sArray[i] != char {
                diffs += 1
                if diffs > 3 {
                    return false
                }
            }
        }
        return true
    }
    
    func longestPrefix() -> String {
        let components = self.components(separatedBy: " ").map { Array($0) }
        guard let _ = components.first else { return "" }
        var result = ""
        for (i, char) in components.first!.enumerated() {
            for word in components {
                if word[i] != char {
                    return result
                }
            }
            result.append(char)
        }
        return result
    }
    
    func characterRepeats() -> String {
        var currentLetter: Character?
        var returnValue = ""
        var letterCounter = 0
        for letter in self {
            if letter == currentLetter {
                letterCounter += 1
            } else {
                if let current = currentLetter {
                    returnValue.append("\(current)\(letterCounter)")
                }
                currentLetter = letter
                letterCounter = 1
            }
        }
        if let current = currentLetter {
            returnValue.append("\(current)\(letterCounter)")
        }
        return returnValue
    }
    
    func permutations(current: String = "", result: inout [String]) {
        let length = self.count
        let strArray = Array(self)
        if length == 0 {
            result.append(current)
        } else {
            for i in 0 ..< length {
                let left = String(strArray[0 ..< i])
                let right = String(strArray[i+1 ..< length])
                let string = left + right
                string.permutations(current: current + String(strArray[i]), result: &result)
            }
        }
    }
    
    func reverseWords() -> String {
        return self.components(separatedBy: " ").map { String($0.reversed()) }.joined(separator: " ")
    }
}


class UserManagerTests: XCTestCase {
    func testOnlyUniqueChars() {
        XCTAssertTrue("No duplicates".onlyUniqueChars())
        XCTAssertTrue("abcdefghijklmnopqrstuvwyz".onlyUniqueChars())
        XCTAssertTrue("AaBbCc".onlyUniqueChars())
        XCTAssertFalse("Hello, world".onlyUniqueChars())
    }
    func testIsPalindrome() {
        XCTAssertTrue("rotator".isPalindrome())
        XCTAssertTrue("Rats live on no evil star".isPalindrome())
        XCTAssertFalse("Never odd or even".isPalindrome())
        XCTAssertFalse("Hello, world".isPalindrome())
    }
    func testSameChars() {
        XCTAssertTrue("abca".sameChars("abca"))
        XCTAssertTrue("abc".sameChars("cba"))
        XCTAssertTrue(" a1 b2 ".sameChars("b 1 a 2"))
        XCTAssertFalse("abc".sameChars("abca"))
        XCTAssertFalse("abc".sameChars("Abc"))
        XCTAssertFalse("abc".sameChars("cbAa"))
    }
    func testFuzzyContains() {
        let string = "Hello, world"
        XCTAssertTrue(string.fuzzyContains("Hello"))
        XCTAssertTrue(string.fuzzyContains("WORLD"))
        XCTAssertFalse(string.fuzzyContains("Goodbye"))
    }
    func testCharCount() {
        XCTAssertEqual("The rain in Spain".charCount(char: "a"), 2)
        XCTAssertEqual("Mississippi".charCount(char: "i"), 4)
        XCTAssertEqual("Hacking with Swift".charCount(char: "i"), 3)
    }
    func testRemoveDuplicate() {
        XCTAssertEqual("wombat".removeDuplicate(), "wombat")
        XCTAssertEqual("hello".removeDuplicate(), "helo")
        XCTAssertEqual("Mississippi".removeDuplicate(), "Misp")
    }
    func testCondenceWhitespace() {
        XCTAssertEqual("a   b   c".condenceWhitespace(), "a b c")
        XCTAssertEqual("    a".condenceWhitespace(), " a")
        XCTAssertEqual("abc".condenceWhitespace(), "abc")
    }
    func testIsRotated() {
        XCTAssertTrue("abcde".isRotated(rotated: "eabcd"))
        XCTAssertTrue("abcde".isRotated(rotated: "cdeab"))
        XCTAssertFalse("abcde".isRotated(rotated: "abced"))
        XCTAssertFalse("abc".isRotated(rotated: "a"))
    }
    func testIsPangram() {
        XCTAssertTrue("The quick brown fox jumps over the lazy dog".isPangram())
        XCTAssertFalse("The quick brown fox jumped over the lazy dog".isPangram())
    }
    func testCountVowelsAndConsonants() {
        XCTAssertEqual("Swift Coding Challenges".countVowelsAndConsonants().vowels, 6)
        XCTAssertEqual("Swift Coding Challenges".countVowelsAndConsonants().consonants, 15)
        XCTAssertEqual("Mississippi".countVowelsAndConsonants().vowels, 4)
        XCTAssertEqual("Mississippi".countVowelsAndConsonants().consonants, 7)
    }
    func testThreeDifferentLetters() {
        XCTAssertTrue("Clamp".threeDifferentLetters("Cramp"))
        XCTAssertTrue("Clamp".threeDifferentLetters("Crams"))
        XCTAssertTrue("Clamp".threeDifferentLetters("Grams"))
        XCTAssertFalse("Clamp".threeDifferentLetters("Grans"))
        XCTAssertFalse("Clamp".threeDifferentLetters("Clam"))
        XCTAssertFalse("clamp".threeDifferentLetters("maple"))
    }
    func testLongestPrefix() {
        XCTAssertEqual("swift switch swill swim".longestPrefix(), "swi")
        XCTAssertEqual("flip flap flop".longestPrefix(), "fl")
    }
    func testCharacterRepeats() {
        XCTAssertEqual("aabbcc".characterRepeats(), "a2b2c2")
        XCTAssertEqual("aaabaaabaaa".characterRepeats(), "a3b1a3b1a3")
        XCTAssertEqual("aaAAaa".characterRepeats(), "a2A2a2")
    }
    func testPermutations() {
        var result: [String] = []
        "wombat".permutations(result: &result)
        XCTAssertEqual(result.count, 720)

        result = []
        "a".permutations(result: &result)
        XCTAssertEqual(result, ["a"])

        result = []
        "ab".permutations(result: &result)
        XCTAssertEqual(result, ["ab", "ba"])

        result = []
        "abc".permutations(result: &result)
        XCTAssertEqual(result, ["abc", "acb", "bac", "bca", "cab", "cba"])
    }
    func testReverseWords() {
        XCTAssertEqual("Swift Coding Challenges".reverseWords(), "tfiwS gnidoC segnellahC")
        XCTAssertEqual("The quick brown fox".reverseWords(), "ehT kciuq nworb xof")
    }
}

class TestObserver: NSObject, XCTestObservation {
    func testCase(_ testCase: XCTestCase,
                  didFailWithDescription description: String,
                  inFile filePath: String?,
                  atLine lineNumber: Int) {
        assertionFailure(description, line: UInt(lineNumber))
    }
}
let testObserver = TestObserver()
XCTestObservationCenter.shared.addTestObserver(testObserver)
UserManagerTests.defaultTestSuite.run()
