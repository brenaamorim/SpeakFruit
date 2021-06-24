//
//  Fruit.swift
//  SpeakFruit
//
//  Created by Brena Amorim on 23/06/21.
//

import Foundation

let fruitNames = [
    ("apple", 5, "DD2329"), ("banana", 6, "F8BAC7"), ("guava", 5, "EDC1A6"),
    ("kiwi", 4, "ECC100"), ("mango", 5, "5917AF"), ("orange", 6, "DDD461"),
    ("peach", 5, "FB774C"), ("pear", 4, "B2C300"), ("persimmon", 9, "FFBD3F"),
    ("plum", 4, "321421"), ("pomegranate", 11, "C32C2F"), ("tomato", 6, "499A62")]

struct Fruit {
    let name: String
    let numberOfLetters: Int
    let color: String
    
    init(name: String, numberOfLetters: Int, color: String) {
        self.name = name
        self.numberOfLetters = numberOfLetters
        self.color = color
    }
    
    static func defaultFuits() -> [Fruit] {
      return fruitNames.map({ let (name, numberOfLetters, color) = $0

        return Fruit(name: name, numberOfLetters: numberOfLetters, color: color)
      })
    }
}
