//
//  ListMealsVC.swift
//  Meal Recipes
//
//  Created by Amin faruq on 03/12/19.
//  Copyright © 2019 Amin faruq. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ListMealsVC: UIViewController {
    @IBOutlet weak var tbMeal: UITableView!
    let refreshControl = UIRefreshControl()
    var category = ""
    private let viewModel = ReactiveListMealsModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupTableview()
        self.setupViewModel()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    private func setupTableview(){
        self.tbMeal.register(UINib.init(nibName: "ListCell", bundle: self.nibBundle), forCellReuseIdentifier: "ListCell")
        self.tbMeal.refreshControl = self.refreshControl
    }
    
    private func setupViewModel(){
        let input = ReactiveListMealsModel.Input(didLoadTrigger: .just(()), didTapCellTrigger: self.tbMeal.rx.itemSelected.asDriver(), pullToRefreshTrigger: refreshControl.rx.controlEvent(.allEvents).asDriver())
        
        let output = viewModel.transform(category: category, input: input)
        
        output
            .mealListCellData
            .drive(self.tbMeal.rx.items(cellIdentifier: "ListCell" , cellType: ListCell.self)){
                row, model , cell in
                cell.configureCell(with: model)
                cell.selectionStyle = .none
        }.disposed(by: disposeBag)
        
        output
            .errorData
            .drive(onNext : {
                errorMessage in
                print("Error")
            }).disposed(by: disposeBag)
        
        output
            .selectedIndex
            .drive(onNext : {
                (index , model) in
                
                let storyBoard = UIStoryboard(name: "DetailMeal", bundle: nil)
                guard let vc = storyBoard
                    .instantiateViewController(withIdentifier: "DetailMeal") as? DetailMealVC else {return}
                
                vc.idMeal = model.idMeal
                vc.title = model.strMeal
                self.navigationController?.pushViewController(vc, animated: true)
                
            }).disposed(by: disposeBag)
        
        output
            .isLoading
            .drive(refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
    }
}
