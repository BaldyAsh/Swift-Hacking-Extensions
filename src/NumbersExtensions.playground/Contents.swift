import Foundation
import XCTest

func fizzBuzz() -> [String] {
    var array = [String]()
    for i in 1...100 {
        if (i % 3 == 0) {
            if (i % 5 == 0) {
                array.append("Fizz Buzz")
            } else {
                array.append("Fizz")
            }
        } else if (i % 5 == 0) {
            array.append("Buzz")
        } else {
            array.append(String(i))
        }
    }
    return array
}

func randInRange(_ min: UInt, _ max: UInt) -> UInt {
    return UInt(arc4random_uniform(UInt32(max - min + 1))) + min
}

func mySwap(_ a: inout Int, _ b: inout Int) {
    a = a + b
    b = a - b
    a = a - b
}

extension Int {
    func myPow(_ power: Int) -> Int {
        guard self > 0, power >= 0 else { return 0 }
        var result = 1
        for _ in 0..<power {
            result *= self
        }
        return result
    }
    
    func isPrime() -> Bool {
        guard self >= 2 else { return false }
        guard self != 2 else { return true }
        let max = Int(ceil(sqrt(Double(self))))
        for i in 2 ... max {
            if self % i == 0 {
                return false
            }
        }
        return true
    }
    
    func countBinaryOnesSame() -> (nextHighest: Int?, nexLowest: Int?) {
        let binaryString = String(self, radix: 2)
        let onesCount = binaryString.filter{$0 == "1"}.count
        var nextHighest: Int? = nil
        var nextLowest: Int? = nil
        for i in self + 1 ... Int.max {
            let localOnesCount = String(i, radix: 2).filter{$0 == "1"}.count
            if localOnesCount == onesCount {
                nextHighest = i
                break;
            }
        }
        for i in (0 ..< self).reversed() {
            let localOnesCount = String(i, radix: 2).filter{$0 == "1"}.count
            if localOnesCount == onesCount {
                nextLowest = i
                break
            }
        }
        return (nextHighest, nextLowest)
    }
    
    func binaryReverse() -> Int {
        let sign = self >= 0 ? 1 : -1
        let binaryString = String(self >= 0 ? self : -self, radix: 2)
        let paddingAmount = 8 - binaryString.count
        let paddedBinaryString = String(repeating: "0", count: paddingAmount) + binaryString
        return sign * Int(String(paddedBinaryString.reversed()), radix: 2)!
    }
}

class UserManagerTests: XCTestCase {
    func testFizzBuzz() {
        let array = fizzBuzz()
        XCTAssertEqual(array[0], "1")
        XCTAssertEqual(array[1], "2")
        XCTAssertEqual(array[2], "Fizz")
        XCTAssertEqual(array[3], "4")
        XCTAssertEqual(array[4], "Buzz")
        XCTAssertEqual(array[14], "Fizz Buzz")
    }
    
    func testRandInRange() {
        let randInRange_1_5 = randInRange(1, 5)
        XCTAssertTrue(randInRange_1_5 > 0 && randInRange_1_5 < 6)
        let randInRange_8_10 = randInRange(8, 10)
        XCTAssertTrue(randInRange_8_10 > 7 && randInRange_8_10 < 11)
        let randInRange_12_12 = randInRange(12, 12)
        XCTAssertTrue(randInRange_12_12 > 11 && randInRange_12_12 < 13)
        let randInRange_12_18 = randInRange(12, 18)
        XCTAssertTrue(randInRange_12_18 > 11 && randInRange_12_18 < 19)
    }
    
    func testMyPow() {
        XCTAssertEqual(4.myPow(3), 64)
        XCTAssertEqual(2.myPow(8), 256)
    }
    
    func testMySwap() {
        var a = 4
        var b = 5
        mySwap(&a, &b)
        XCTAssertEqual(a, 5)
        XCTAssertEqual(b, 4)
    }
    
    func testIsPrime() {
        XCTAssertTrue(11.isPrime())
        XCTAssertTrue(13.isPrime())
        XCTAssertFalse(4.isPrime())
        XCTAssertFalse(9.isPrime())
        XCTAssertTrue(16777259.isPrime())
    }
    
    func testCountBinaryOnesSame() {
        let (res11, res12) = 12.countBinaryOnesSame()
        XCTAssertEqual(res11, 17)
        XCTAssertEqual(res12, 10)
        let (res21, res22) = 28.countBinaryOnesSame()
        XCTAssertEqual(res21, 35)
        XCTAssertEqual(res22, 26)
    }
    
    func testBinaryReverse() {
        XCTAssertEqual(32.binaryReverse(), 4)
        XCTAssertEqual(4.binaryReverse(), 32)
        XCTAssertEqual(41.binaryReverse(), 148)
        XCTAssertEqual(148.binaryReverse(), 41)
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
