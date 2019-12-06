//
//  ListCell.swift
//  Meal Recipes
//
//  Created by Amin faruq on 04/12/19.
//  Copyright © 2019 Amin faruq. All rights reserved.
//

import UIKit

struct ListMealsCellData {
    let strMeal : String
    let strMealThumb : String
    let idMeal : String
}

class ListCell: UITableViewCell {
    @IBOutlet weak var imgFood: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(with data : ListMealsCellData){
        self.lbName.text = data.strMeal
        self.getImage(imageUrl: data.strMealThumb)
    }
    
    func getImage(imageUrl : String){
        let url = NSURL(string:imageUrl)
        let imagedata = NSData.init(contentsOf: url! as URL)
        if imagedata != nil {
            self.imgFood.image = UIImage(data:imagedata! as Data)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
