//
//  ViewModelType.swift
//  Meal Recipes
//
//  Created by Amin faruq on 03/12/19.
//  Copyright © 2019 Amin faruq. All rights reserved.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

protocol ViewModelListMeals {
    associatedtype Input
    associatedtype Output
    
    func transform(category : String ,input: Input) -> Output
}

protocol ViewModelDetailMeal {
    associatedtype Input
    associatedtype Output
    
    func transform(id : String ,input: Input) -> Output
}

