//
//  DetailMealVC.swift
//  Meal Recipes
//
//  Created by Amin faruq on 05/12/19.
//  Copyright © 2019 Amin faruq. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class DetailMealVC: UIViewController {
    /// - Variable
    @IBOutlet weak var imgDetail: UIImageView!
    @IBOutlet weak var lbCategory: UILabel!
    @IBOutlet weak var lbFoodCountry: UILabel!
    @IBOutlet weak var lbInstructions: UILabel!
    /// - Variable for Ingredient
    @IBOutlet weak var lbIngredient1: UILabel!
    @IBOutlet weak var lbIngredient2: UILabel!
    @IBOutlet weak var lbIngredient3: UILabel!
    @IBOutlet weak var lbIngredient4: UILabel!
    @IBOutlet weak var lbIngredient5: UILabel!
    @IBOutlet weak var lbIngredient6: UILabel!
    @IBOutlet weak var lbIngredient7: UILabel!
    @IBOutlet weak var lbIngredient8: UILabel!
    @IBOutlet weak var lbIngredient9: UILabel!
    /// - Variable for Measure
    @IBOutlet weak var lbMeasure1: UILabel!
    @IBOutlet weak var lbMeasure2: UILabel!
    @IBOutlet weak var lbMeasure3: UILabel!
    @IBOutlet weak var lbMeasure4: UILabel!
    @IBOutlet weak var lbMeasure5: UILabel!
    @IBOutlet weak var lbMeasure6: UILabel!
    @IBOutlet weak var lbMeasure7: UILabel!
    @IBOutlet weak var lbMeasure8: UILabel!
    @IBOutlet weak var lbMeasure9: UILabel!
    
    var idMeal = ""
    let refreshControl = UIRefreshControl()
    private let viewModel = ReactiveDetailMealModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupViewModel()
    }
    
    private func setupViewModel(){
        let input = ReactiveDetailMealModel.Input(didLoadTrigger: .just(()), pullToRefreshTrigger: refreshControl.rx.controlEvent(.allEvents).asDriver())
        
        let output = viewModel.transform(id: idMeal, input: input)
        
        output
            .mealListCellData
        
        output
            .errorData
            .drive(onNext : {
                errorMessage in
                print("Error")
            }).disposed(by: disposeBag)
        
        output
            .isLoading
            .drive(refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
    }
    
    func getImage(imageUrl : String){
           let url = NSURL(string:imageUrl)
           let imagedata = NSData.init(contentsOf: url! as URL)
           if imagedata != nil {
               self.imgDetail.image = UIImage(data:imagedata! as Data)
           }
       }
    
    
}
