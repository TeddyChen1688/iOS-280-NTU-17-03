//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

let a = 1
let b = 3
 a + b

func sayGoodbye(personName: String) {
    print("Goodbye, \(personName)!")
}
sayGoodbye(personName: "Dave")

let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]

func backwards(s1: String, s2: String) -> Bool {
    return s1 > s2
}
var reversed = sorted(names, backwards)
