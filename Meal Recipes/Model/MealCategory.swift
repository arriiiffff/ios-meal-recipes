//
//  Category.swift
//  Meal Recipes
//
//  Created by Amin faruq on 03/12/19.
//  Copyright © 2019 Amin faruq. All rights reserved.
//

import Foundation

struct Category : Decodable {
    let strMeal : String
    let strMealThumb : String
    let idMeal : String
}

struct CategoryResponse : Decodable {
    let meals : [Category]
}
