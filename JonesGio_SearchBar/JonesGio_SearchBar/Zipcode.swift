//
//  Zipcode.swift
//  JonesGio_SearchBar
//
//  Created by Gio on 1/30/26.
//

import Foundation

class Zipcode {
    let city: String
    let location: [Double]
    let population: Int
    let state: String
    let id: String
    
    init(city: String, location: [Double], population: Int, state: String, id: String) {
        self.city = city
        self.location = location
        self.population = population
        self.state = state
        self.id = id
    }
}
