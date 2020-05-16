import Foundation

public enum ConversionType {
    case binary,decimal
}

public enum OperatorType {
    case addition,subtraction,multiplication
}
public struct QuesionModel {
    public var num1 : Int = 0
    public var num2 : Int = 0
    public var correctAnswer : String = ""
    public var conversionType : ConversionType?
    public var operatorType : OperatorType?
    
    public init() {
        print("Question Model")
    }
    public mutating func getNextQuesion() {
        let oprand = Int.random(in: 1...3)
        let conprand = Int.random(in:1...2)
        let upperBound = 75
        var res = 0
        switch oprand {
        case 1:
            operatorType = .addition
            num1 = Int.random(in: 1...upperBound)
            num2 = Int.random(in: 1...upperBound)
            res = num1 + num2
        case 2:
            operatorType = .subtraction
            num1 = Int.random(in: 1...upperBound)
            num2 = Int.random(in: 1...upperBound)
            while(num1 <= num2) {
                num1 = Int.random(in: 1...upperBound)
                num2 = Int.random(in: 1...upperBound)
            }
            res = num1 - num2
        default:
            operatorType = .multiplication
            num1 = Int.random(in: 1...upperBound)
            num2 = Int.random(in: 1...upperBound)
            res = num1 * num2
        }
        
        switch conprand {
        case 1:
            //Answer in Binary, Question in Decimal
            conversionType = .binary
            correctAnswer = inBinary(number: res)
        default:
            //Answer in Decimal, Question in Binary
            conversionType = .decimal
            num1 = Int(inBinary(number: num1))!
            num2 = Int(inBinary(number: num2))!
            correctAnswer = String(res)
        }
    }
    
    public func inBinary(number : Int)-> String {
        var n = number
        var res = ""
        while(n>0) {
            res = "\(n%2)" + res
            n = n / 2
        }
        return res
    }
}
