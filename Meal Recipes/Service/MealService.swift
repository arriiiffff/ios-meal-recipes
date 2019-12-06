//
//  MealService.swift
//  Meal Recipes
//
//  Created by Amin faruq on 03/12/19.
//  Copyright © 2019 Amin faruq. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

enum MealServiceError{
    case missingData
}

protocol MealServiceProtocol {
    
    func reactiveFetchMealCategory() -> Observable<[MealCategory]>
    func reactiveFetchListMeal(category : String) -> Observable<[ListMealsModel]>
    func reactiveFetchDetailMeal(id : String) -> Observable<[DetailMealModel]>
}

class NetworkMealService: MealServiceProtocol {
    
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return decoder
    }()
    
    func reactiveFetchDetailMeal(id: String) -> Observable<[DetailMealModel]> {
//        Observable<Any>.empty()
        let url = URL(string: "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(id)")!
        
        let urlRequest = URLRequest(url: url)
        let response = URLSession
            .shared
            .rx
            .data(request: urlRequest)
            .flatMapLatest{(data) -> Observable<DetailMealResponse> in
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                do{
                    let resultData = try decoder.decode(DetailMealResponse.self, from: data)
                    return Observable.just(resultData)
                }catch( let decodeError){
                    return Observable.error(decodeError)
                }
        }
        
        let detailMeal = response.map{ $0.meals}
        return detailMeal
    }
    
    func reactiveFetchListMeal(category: String) -> Observable<[ListMealsModel]> {
        let url = URL(string: "https://www.themealdb.com/api/json/v1/1/filter.php?c=\(category)")!
        
        let urlRequest = URLRequest(url: url)
        let response = URLSession
            .shared
            .rx
            .data(request: urlRequest)
            .flatMapLatest{(data) -> Observable<ListMealsResponse> in
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                do{
                    let resultData = try decoder.decode(ListMealsResponse.self, from: data)
                    return Observable.just(resultData)
                }catch( let decodeError){
                    return Observable.error(decodeError)
                }
        }
        
        let contacts = response.map{ $0.meals }
        return contacts
    }
    
    
    func reactiveFetchMealCategory() -> Observable<[MealCategory]> {
        let url = URL(string: "https://www.themealdb.com/api/json/v1/1/categories.php")!
        
        let urlRequest = URLRequest(url: url)
        let response = URLSession
            .shared
            .rx
            .data(request: urlRequest)
            .flatMapLatest { (data) -> Observable<CategoryResponse> in
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                do{
                    let resultData = try decoder.decode(CategoryResponse.self, from: data)
                    return Observable.just(resultData)
                }catch( let decodeError){
                    return Observable.error(decodeError)
                }
        }
        
        let contacts = response.map{ $0.categories }
        return contacts
    }
    
}
