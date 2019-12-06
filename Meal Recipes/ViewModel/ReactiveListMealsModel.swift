//
//  ReactiveListMealsModel.swift
//  Meal Recipes
//
//  Created by Amin faruq on 04/12/19.
//  Copyright © 2019 Amin faruq. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class ReactiveListMealsModel: ViewModelListMeals {
    let service : MealServiceProtocol
    
    init(service : MealServiceProtocol =
        NetworkMealService()){
        self.service = service
    }
    
    struct Input {
        let didLoadTrigger: Driver<Void>
        let didTapCellTrigger: Driver<IndexPath>
        let pullToRefreshTrigger: Driver<Void>
        
    }
    
    struct Output {
        let mealListCellData: Driver<[ListMealsCellData]>
        let errorData: Driver<String>
        let selectedIndex: Driver<(index: IndexPath, model: ListMealsCellData)>
        let isLoading: Driver<Bool>
    }
    
    func transform(category: String, input: ReactiveListMealsModel.Input) -> ReactiveListMealsModel.Output {
        
        let errorMessage = PublishSubject<String>()
        let isLoading = BehaviorRelay<Bool>(value: false)
        
        let fetchDataTrigger = Driver.merge(
            input.didLoadTrigger, input.pullToRefreshTrigger)
        
        let fetchData = fetchDataTrigger
            .do(onNext: { _ in
                isLoading.accept(true)
            })
            .flatMapLatest{[service] _ -> Driver<[ListMealsModel]> in service
                .reactiveFetchListMeal(category: category)
                .do(onNext: {_ in
                    isLoading.accept(false)
                }, onError: {error in
                    errorMessage.onNext(error
                        .localizedDescription)
                    isLoading.accept(false)
                })
                .asDriver{_ -> Driver<[ListMealsModel]> in
                    Driver.empty()
                    
                }
        }
        
        let listMealsCellData = fetchData
            .map{listMeals -> [ListMealsCellData] in
                listMeals.map{ listMeal ->
                    ListMealsCellData in
                    ListMealsCellData(strMeal: listMeal.strMeal, strMealThumb: listMeal.strMealThumb, idMeal: listMeal.idMeal)
                }
        }
        
        let errorMessageDriver = errorMessage
            .asDriver{error -> Driver<String> in
                Driver.empty()
        }
        
        let selectedIndexCell = input
            .didTapCellTrigger
            .withLatestFrom(listMealsCellData){
                index , listMeal -> (index : IndexPath, model : ListMealsCellData) in
                return (index: index , model : listMeal[index.row])
        }
        
        
        
        return Output(mealListCellData: listMealsCellData, errorData: errorMessageDriver, selectedIndex: selectedIndexCell, isLoading: isLoading.asDriver())
        
    }
    
}

