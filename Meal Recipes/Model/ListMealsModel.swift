//
//  ListMealsModel.swift
//  Meal Recipes
//
//  Created by Amin faruq on 04/12/19.
//  Copyright © 2019 Amin faruq. All rights reserved.
//

import Foundation

struct ListMealsModel : Decodable {
    let strMeal : String
    let strMealThumb : String
    let idMeal : String
}

struct ListMealsResponse : Decodable {
    let meals : [ListMealsModel]
}
