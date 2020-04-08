import Foundation

/**
```
import Percentage

10% + 5.5%
//=> 15.5%

-10% / 2
//=> -5%

(40% + 93%) * 3
//=> 399%

50% * 50%
//=> 25%

30% > 25%
//=> true

50%.of(200)
//=> 100

Percentage(50)
//=> 50%

Percentage(fraction: 0.5)
//=> 50%

50%.fraction
//=> 0.5

10%.rawValue
//=> 10

print("\(1%)")
//=> "1%"
```
*/
public struct Percentage: Hashable, Codable {
	/**
	The raw percentage number.

	```
	10%.rawValue
	//=> 10
	```
	*/
	public let rawValue: Double

	/**
	Get the percentage as a fraction.

	```
	50%.fraction
	//=> 0.5
	```
	*/
	public var fraction: Double { rawValue / 100 }

	/**
	Create a `Percentage` from a `BinaryFloatingPoint`, for example, `Double` or `CGFloat`.

	```
	let cgFloat: CGFloat = 50.5
	Percentage(cgFloat)
	//=> 50.5%
	```
	*/
	public init<T>(_ percentage: T) where T: BinaryFloatingPoint {
		self.rawValue = Double(percentage)
	}

	/**
	Create a `Percentage` from a `BinaryInteger`, for example, `Int`.

	```
	let int = 50
	Percentage(int)
	//=> 50%
	```
	*/
	public init<T>(_ percentage: T) where T: BinaryInteger {
		self.rawValue = Double(percentage)
	}

	/**
	Create a `Percentage` from a fraction.

	```
	Percentage(fraction: 0.5)
	//=> "50%"
	```
	*/
	public init(fraction: Double) {
		self.rawValue = fraction * 100
	}

	/**
	Returns how much the percentage of the given value is.

	```
	50%.of(200)
	//=> 100
	```
	*/
	public func of(_ value: Double) -> Double { value * rawValue / 100 }
    
    /**
    Returns a random value within the specified range.

    ```
    Percent.random(in: 10%...20%)
    //=> can be 10%, 11%, 12%, 19.98%, etc.
    ```
     */
    static func random(in range: ClosedRange<Percentage>) -> Percentage {
        return Percentage(fraction: Double.random(in: range.lowerBound.fraction...range.upperBound.fraction))
    }
}

extension Percentage: RawRepresentable {
	public init(rawValue: Double) {
		self.rawValue = rawValue
	}
}

extension Percentage: Comparable {
	public static func < (lhs: Self, rhs: Self) -> Bool {
		lhs.rawValue < rhs.rawValue
	}
}

extension Percentage: CustomStringConvertible {
	internal static var formatter: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.numberStyle = .percent
		return formatter
	}()

	public var description: String {
		Self.formatter.string(for: fraction) ?? "\(String(format: "%g", rawValue))%"
	}
}

// swiftlint:disable static_operator
prefix operator -

public prefix func - (percentage: Percentage) -> Percentage {
	Percentage(-percentage.rawValue)
}

postfix operator %

public postfix func % (value: Double) -> Percentage {
	Percentage(value)
}

public postfix func % (value: Int) -> Percentage {
	Percentage(Double(value))
}
// swiftlint:enable static_operator

extension Percentage: ExpressibleByFloatLiteral {
	public init(floatLiteral value: Double) {
		self.rawValue = value
	}
}

extension Percentage: ExpressibleByIntegerLiteral {
	public init(integerLiteral value: Double) {
		self.rawValue = value
	}
}

extension Percentage: Numeric {
	public typealias Magnitude = Double.Magnitude

	public static var zero: Self { 0 }

	public static func + (lhs: Self, rhs: Self) -> Self {
		self.init(lhs.rawValue + rhs.rawValue)
	}

	public static func += (lhs: inout Self, rhs: Self) {
		lhs = lhs + rhs
	}

	public static func - (lhs: Self, rhs: Self) -> Self {
		self.init(lhs.rawValue - rhs.rawValue)
	}

	public static func -= (lhs: inout Self, rhs: Self) {
		lhs = lhs - rhs
	}

	public static func * (lhs: Self, rhs: Self) -> Self {
		self.init(fraction: lhs.fraction * rhs.fraction)
	}

	public static func *= (lhs: inout Self, rhs: Self) {
		lhs = lhs * rhs
	}

	public var magnitude: Magnitude { rawValue.magnitude }

	public init?<T>(exactly source: T) where T: BinaryInteger {
		guard let value = Double(exactly: source) else {
			return nil
		}

		self.init(value)
	}
}

extension Percentage {
	public static func / (lhs: Self, rhs: Self) -> Self {
		self.init(fraction: lhs.fraction / rhs.fraction)
	}

	public static func /= (lhs: inout Self, rhs: Self) {
		lhs = lhs / rhs
	}
}
