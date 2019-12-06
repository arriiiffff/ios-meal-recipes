//
//  ViewController.swift
//  Meal Recipes
//
//  Created by Amin faruq on 03/12/19.
//  Copyright © 2019 Amin faruq. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionSlide: UICollectionView!
    @IBOutlet weak var collectionCategory: UICollectionView!
    let refreshControl = UIRefreshControl()
    
    private let viewModel = ReactiveCategoryListModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupCollection()
        self.setupViewModel()
    }
    
    private func setupCollection(){
        self.collectionCategory.register(UINib.init(nibName: "MealCell", bundle: self.nibBundle), forCellWithReuseIdentifier: "MealCell")
        self.collectionCategory.refreshControl = self.refreshControl
    }
    
    private func setupViewModel(){
        /// - input
        let input = ReactiveCategoryListModel.Input(didLoadTrigger: .just(()), didTapCellTrigger: self.collectionCategory.rx.itemSelected.asDriver(), pullToRefreshTrigger: refreshControl.rx.controlEvent(.allEvents).asDriver())
        
        let output = viewModel.transform(input: input)
        
        output.mealListCellData
            .drive(self.collectionCategory.rx.items(cellIdentifier: "MealCell", cellType: MealCell.self)){
                row , model , cell in
                cell.configureCell(with: model)
        }.disposed(by: disposeBag)
        
        output.errorData
            .drive(onNext: {errorMessage in
                print("Error")
            }).disposed(by: disposeBag)
        
        output.selectedIndex.drive(onNext: { (index , model) in
            
        }).disposed(by: disposeBag)
        
        output
            .isLoading
            .drive(refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
    }
}

