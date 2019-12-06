//
//  ReactiveCategoryListModel.swift
//  Meal Recipes
//
//  Created by Amin faruq on 03/12/19.
//  Copyright © 2019 Amin faruq. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class ReactiveCategoryListModel: ViewModelType {
    let service : MealServiceProtocol
    init(service : MealServiceProtocol = NetworkMealService()) {
        self.service = service
    }
    
    struct Input {
        let didLoadTrigger: Driver<Void>
        let didTapCellTrigger: Driver<IndexPath>
        let pullToRefreshTrigger: Driver<Void>
        
    }
    
    struct Output {
        let mealListCellData: Driver<[CollectionCategoryData]>
        let errorData: Driver<String>
        let selectedIndex: Driver<(index: IndexPath, model: CollectionCategoryData)>
        let isLoading: Driver<Bool>
        
    }
    
    func transform(input: ReactiveCategoryListModel.Input) -> ReactiveCategoryListModel.Output {
        let errorMessage = PublishSubject<String>()
        let isLoading = BehaviorRelay<Bool>(value: false)
        
        let fetchDataTrigger = Driver.merge( input.didLoadTrigger, input.pullToRefreshTrigger)
        
        let fetchData = fetchDataTrigger
            .do(onNext: { _ in
                isLoading.accept(true)
            })
            .flatMapLatest{[service] _ -> Driver<[MealCategory]> in service
                .reactiveFetchMealCategory()
                .do(onNext: { _ in
                    isLoading.accept(false)
                }, onError: {error in
                    errorMessage.onNext(error.localizedDescription)
                    isLoading.accept(true)
                })
                .asDriver{_ -> Driver<[MealCategory]> in
                    Driver.empty()
                }
        }
        let categoryListCellData = fetchData
            .map{ categories -> [CollectionCategoryData] in
                categories.map{ category -> CollectionCategoryData in
                    CollectionCategoryData(idCategory: category.idCategory, strCategory: category.strCategory, strCategoryThumb: category.strCategoryThumb, strCategoryDescription: category.strCategoryDescription)
                }
        }
        
        let errorMessageDriver = errorMessage
            .asDriver{error -> Driver<String> in
                Driver.empty()
        }
        
        let selectedIndexCell = input
            .didTapCellTrigger
            .withLatestFrom(categoryListCellData) {
                index , category -> (index : IndexPath, model : CollectionCategoryData ) in
                return (index: index, model: category[index.row])
        }
        
        return Output(mealListCellData: categoryListCellData, errorData: errorMessageDriver, selectedIndex: selectedIndexCell, isLoading: isLoading.asDriver())
        
    }
    
}
