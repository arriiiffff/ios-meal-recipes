//
//  ReactiveDetailMealModel.swift
//  Meal Recipes
//
//  Created by Amin faruq on 05/12/19.
//  Copyright © 2019 Amin faruq. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ReactiveDetailMealModel: ViewModelDetailMeal {
    
    let service : MealServiceProtocol
    
    init(service : MealServiceProtocol =
        NetworkMealService()){
        self.service = service
    }
    
    struct Input {
        let didLoadTrigger: Driver<Void>
        let pullToRefreshTrigger: Driver<Void>
        
    }
    
    struct Output {
        let mealListCellData: Driver<[DetailModelStruct]>
        let errorData: Driver<String>
        let isLoading: Driver<Bool>
        
    }
    
    func transform(id: String, input: ReactiveDetailMealModel.Input) -> ReactiveDetailMealModel.Output {
        
        let errorMessage = PublishSubject<String>()
        let isLoading = BehaviorRelay<Bool>(value: false)
        
        let fetchDataTringger = Driver.merge(
            input.didLoadTrigger , input.pullToRefreshTrigger)
        
        let fetchData = fetchDataTringger
            .do(onNext: {_ in
                isLoading.accept(true)
            })
            .flatMapLatest{[service] _->
                Driver<[DetailMealModel]> in service
                    .reactiveFetchDetailMeal(id: id)
                    .do(onNext: {_ in
                        isLoading.accept(false)
                    }, onError: {error in
                        errorMessage.onNext(error
                            .localizedDescription)
                        isLoading.accept(false)
                    })
                    .asDriver{_ -> Driver<[DetailMealModel]> in
                        Driver.empty()
                        
                }
        }
        
        let detailMealData = fetchData
            .map{listDetail -> [DetailModelStruct] in
                listDetail.map{ detailMeal ->
                    DetailModelStruct in DetailModelStruct(idMeal:detailMeal.idMeal, strMeal: detailMeal.strMeal, strCategory: detailMeal.strCategory, strArea: detailMeal.strArea, strInstructions: detailMeal.strInstructions, strMealThumb: detailMeal.strMealThumb, strTags: detailMeal.strTags, strYoutube: detailMeal.strYoutube, strIngredient1: detailMeal.strIngredient1, strIngredient2: detailMeal.strIngredient2, strIngredient3: detailMeal.strIngredient3, strIngredient4: detailMeal.strIngredient4, strIngredient5: detailMeal.strIngredient5, strIngredient6: detailMeal.strIngredient6, strIngredient7: detailMeal.strIngredient7, strIngredient8: detailMeal.strIngredient8, strIngredient9: detailMeal.strIngredient9, strMeasure1: detailMeal.strMeasure1, strMeasure2: detailMeal.strMeasure2, strMeasure3: detailMeal.strMeasure3, strMeasure4: detailMeal.strMeasure4, strMeasure5: detailMeal.strMeasure5, strMeasure6: detailMeal.strMeasure6, strMeasure7: detailMeal.strMeasure7, strMeasure8: detailMeal.strMeasure8, strMeasure9: detailMeal.strMeasure9)
                }
        }
        
        let errorMessageDriver = errorMessage
            .asDriver{error -> Driver<String> in Driver.empty()
                
        }
        
//        let selectedIndex = input
//            .didTapCellTrigger
//            .withLatestFrom(detailMealData){
//                index , meal -> (index : IndexPath , model : DetailModelStruct) in
//                return (index : index , model : meal[index.row])
//        }
        
        return Output(mealListCellData: detailMealData, errorData: errorMessageDriver, isLoading: isLoading.asDriver())
        
    }
    
}
