//: # A Swift 3 Super Crash Course
import Foundation

//: ## Variables and Constants
let constantA = 13.5
let constantB = "Hello"

var myString = "Apple"
myString = "Banana"

//: ## Data Types
//: ### Int, Double, Float
let aNumber = 10
type(of: aNumber)

let bNumber = 10.0
type(of: bNumber)

let floatNumber: Float = 10.0
type(of: floatNumber)

//: ### String
let aPieceOfText = "Hello world!"
let anotherPieceOfText = "Hello Bob!"

var firstPart = "Hello "
firstPart += "John"

firstPart.characters.count
let charIndex = firstPart.index(firstPart.startIndex, offsetBy: 7)
firstPart.characters[charIndex]

let aDecimalNumber = 12.20631423
let anotherInt = 126
let stringWithFormat = String(format: "%.2f %.3f %.2f", aDecimalNumber, aDecimalNumber, Double(anotherInt))

//: ### Array
let myArray = [1, 2, 15, 20, 22]
var anotherArray = ["Apple", "Banana", "Cat", "Dog"]

type(of: myArray)
type(of: anotherArray)

let anyArray: [Any] = [1, "two", 3, 4.0, "five"]
type(of: anyArray)

anyArray.count
anotherArray.append("Elephant")

myArray[3]
anotherArray[1]
anyArray[4]

if let myStr = anyArray[4] as? String {
    myStr
}

var emptyArray = [Double]()
emptyArray.append(2.5)
emptyArray.insert(1.8, at: 0)
emptyArray.count

//: ### Dictionary
let ages = [
    "Bob": 15,
    "Alice": 20,
    "Michael": 16,
    "Peter": 21,
    "Jane": 17,
    "Mary": 21,
]

for key in ages.keys {
    key
}

type(of: ages)

var emptyDict = [String: Any]()
emptyDict["Hello"] = "World"
emptyDict["Hmm"] = 3.0
emptyDict["Banana"] = "Splits"

emptyDict.count
emptyDict

if let hmm = emptyDict["Hmm"] as? String {
    hmm
} else {
    "key Hmm is not type of String"
}

//: ### Fun with Functional Programming
var inputNumbers = [Int]()
for i in 0..<10 {
    inputNumbers.append(i)
}
inputNumbers

let squaredNumbers = inputNumbers.map { $0 * $0 }
squaredNumbers

let sumOfSquares = inputNumbers.map { $0 * $0 }.reduce(0) { $0 + $1 }
sumOfSquares

let anotherArrayOfInts = Array(1...10)

let sumOfInts = anotherArrayOfInts.reduce(0) { $0 + $1 }
sumOfInts

//: ## Flow Control
//: ### Conditionals

let smallInt = 15

if smallInt < 15 {
    "less than 15"
} else {
    "greater than or equal to 15"
}

let fruitName = "Apple"

if fruitName == "Apple" {
    "PPAP!"
}

switch fruitName {
    case "Apple":
        "PPAP!"
    
    case "Banana":
        "Banana split!"
    
    default:
        "Unknown fruit"
}


//: ### Optional Binding
let anEmptyName: String? = nil

if let unwrappedName = anEmptyName {
    unwrappedName
} else {
    "name is nil"
}

//: ### Optional Chaining
let nameLength = anEmptyName?.characters.count

let anotherName: String? = "Tim"
let anotherNameLength = anotherName?.characters.count
anotherNameLength
type(of: anotherNameLength)

//: ### Loops
let oneToTen = Array(1...10)
for number in oneToTen {
    number
}

var currentCount = 0
while currentCount < 100 {
    currentCount += 1
}

//: ## Functions and Closures
func sumOfTwoNumbers(a: Int, b: Int) -> Int {
    return a + b
}

sumOfTwoNumbers(a: 1, b: 2)

func statisticsForNumbers(numbers: [Int]) -> (sum: Int, average: Double) {
    let sum = numbers.reduce(0) { $0 + $1 }
    let average = Double(sum) / Double(numbers.count)
    
    return (sum, average)
}

statisticsForNumbers(numbers: Array(1...5))

let aClosure = { (number: Int) -> Int in
    return number * 2
}

aClosure(15)
