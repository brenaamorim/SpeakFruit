//
//  Fruit.swift
//  SpeakFruit
//
//  Created by Brena Amorim on 23/06/21.
//

import Foundation

let fruitNames = [
    ("apple", 5, 1), ("banana", 6, 2), ("guava", 5, 3),
    ("kiwi", 4, 4), ("mango", 5, 5), ("orange", 6, 6),
    ("peach", 5, 7), ("persimmon", 9, 8), ("plum", 4, 9),
    ("pomegranate", 11, 10), ("tomato", 6, 11)]

struct Fruit {
    let name: String
    let numberOfLetters: Int
    let colorNumber: Int
    
    init(name: String, numberOfLetters: Int, colorNumber: Int) {
        self.name = name
        self.numberOfLetters = numberOfLetters
        self.colorNumber = colorNumber
    }
}
