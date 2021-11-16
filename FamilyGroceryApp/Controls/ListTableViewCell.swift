//
//  ListTableViewCell.swift
//  FamilyGroceryApp
//
//  Created by administrator on 10/11/2021.
//

import UIKit

class ListTableViewCell: UITableViewCell {
       
 
    
    private let checkbutton: UIButton = {
       let check = UIButton()
        check.setTitle(" Done ", for: .normal)
       check.tintColor = #colorLiteral(red: 0.2488779838, green: 0.5874847796, blue: 0.6701030928, alpha: 1)
        check.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        check.backgroundColor = #colorLiteral(red: 0.5168316616, green: 0.8488862672, blue: 0.9690721649, alpha: 1)
        check.layer.cornerRadius = CGFloat(14)
        check.layer.masksToBounds = true
        check.setImage(.checkmark, for: .normal)
        return check
    }()
        
        private let UserNameLabel: UILabel = {
           let label = UILabel()
            label.font = .systemFont(ofSize: 21, weight: .bold)
            return label
        }()
        
        private let UserMassLabel: UILabel = {
           let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            return label
        }()
        
      
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            contentView.addSubview(checkbutton)
            contentView.addSubview(UserNameLabel)
            contentView.addSubview(UserMassLabel)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
           checkbutton.frame = CGRect(x: 270, y: 35, width: 80, height: 30)
            UserNameLabel.frame = CGRect(x: 35,
                                         y:0
                                         , width: contentView.frame.width ,
                                         height: contentView.frame.height-20/2)
            UserMassLabel.frame = CGRect(x: 30,
                                          y:35
                                         , width: contentView.frame.width ,
                                         height: contentView.frame.height-20/2)
    
        }
    
    var currentItem : UserChoese?
    
        public func configure(with model: UserChoese){
            currentItem = model
            var x = currentItem?.forFierbace[currentItem!.foodItem]
            let xx = x?["compleate"]! as? Bool
            if(xx == false){
                self.UserMassLabel.text = model.email
                self.UserNameLabel.text = model.foodItem
                addAtrbuteToText(0,currentItem!.foodItem, false)
                self.checkbutton.isHidden = true
              
                
            }
            else{
                self.UserMassLabel.text = model.email
                self.UserNameLabel.text = model.foodItem
                addAtrbuteToText(2,currentItem!.foodItem , true)
                self.checkbutton.isHidden = false
               
            }
           
         //   checkbutton.addTarget(self, action: #selector(complet), for: .touchUpInside)

    }
    
    static let shared = ListTableViewCell()
    
 
    
    
    func addAtrbuteToText(_ addValue: Int , _ item: String,_ dark: Bool){
        let attributedString = NSMutableAttributedString(string: item)
        attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: addValue, range: NSMakeRange(0, attributedString.length))
        self.UserNameLabel.attributedText = attributedString
        if(dark){
            UserNameLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            UserMassLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }
        else{
            UserNameLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            UserMassLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
      
    }
    
    
    public func com (with x1: UserChoese) -> Bool{
        currentItem = x1
      return complet()
        
    }
    
 public func complet () -> Bool{
    var x = currentItem?.forFierbace[currentItem!.foodItem]
    print(x?["compleate"])
    let xx = x?["compleate"]! as? Bool
    if( xx == false){
        print("it is false")
       checkbutton.isHidden = false
        addAtrbuteToText(2,currentItem!.foodItem , true)
        DataBaseControl.shared.UpdateFoodItem(currentItem!, currentItem!.forFierbace, true , .compleate)
        return true
    }
    else {
        print("it is truu")
       checkbutton.isHidden = true
        addAtrbuteToText(0,currentItem!.foodItem , false)
        x?["compleate"] = false
        DataBaseControl.shared.UpdateFoodItem(currentItem!, currentItem!.forFierbace, false , .compleate)
        return false
    }
    

 }

}


struct UserChoese  {
    var foodItem : String
    let email : String
    var forFierbace : [String:[String:Any?]]
}
