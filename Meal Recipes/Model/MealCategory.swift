//
//  Category.swift
//  Meal Recipes
//
//  Created by Amin faruq on 03/12/19.
//  Copyright © 2019 Amin faruq. All rights reserved.
//

import Foundation

struct MealCategory : Decodable {
    let idCategory : String
    let strCategory : String
    let strCategoryThumb : String
    let strCategoryDescription : String
}

struct CategoryResponse : Decodable {
    let categories : [MealCategory]
}
