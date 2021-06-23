//
//  Fruit.swift
//  SpeakFruit
//
//  Created by Brena Amorim on 23/06/21.
//

import Foundation

let fruitNames = [
    ("Apple", 5, "DD2329"), ("Banana", 6, "F8BAC7"), ("Guava", 5, "EDC1A6"),
    ("Kiwi", 4, "ECC100"), ("Mango", 5, "5917AF"), ("Orange", 6, "DDD461"),
    ("Peach", 5, "FB774C"), ("Pear", 4, "B2C300"), ("persimmon", 9, "FFBD3F"),
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
