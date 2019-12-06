//
//  MealCell.swift
//  Meal Recipes
//
//  Created by Amin faruq on 03/12/19.
//  Copyright © 2019 Amin faruq. All rights reserved.
//

import UIKit

struct CollectionCategoryData {
    let idCategory : String
    let strCategory : String
    let strCategoryThumb : String
    let strCategoryDescription : String
}

class MealCell: UICollectionViewCell {
    @IBOutlet weak var imgFood: UIImageView!
    @IBOutlet weak var lbCategory: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(with data : CollectionCategoryData){
        self.lbCategory.text = data.strCategory
        self.getImage(imageUrl: data.strCategoryThumb)
    }
    
    func getImage(imageUrl : String){
        let url = NSURL(string:imageUrl)
        let imagedata = NSData.init(contentsOf: url! as URL)
        if imagedata != nil {
            self.imgFood.image = UIImage(data:imagedata! as Data)
        }
    }
}
