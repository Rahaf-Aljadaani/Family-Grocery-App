
import Foundation
import Firebase



class DataBaseControl {
    
    public  let root = Database.database().reference()
    static let shared = DataBaseControl()
    private var currentEmail : String!
    static var num : Int = 1
    
    
    public func formatEmail(_ email:String) -> String{
        var emailFormat = email.replacingOccurrences(of: ".", with: "-")
        emailFormat = emailFormat.replacingOccurrences(of: "@", with: "-")
        return emailFormat
    }
    
    public func saveEmail (_ email: String){
        UserDefaults.standard.set(email,forKey: "email")
        addOnlineFamily(email:UserDefaults.standard.value(forKey: "email") as! String )
        currentEmail = formatEmail(email)
        
        
        //updateOnlineUser()
        //GroceryListViewController.sheard.navgationOfOnlineUser()
    }
  
    public func addOnlineFamily(email: String){
        let emailFormat = formatEmail(email)
        let userRef = Database.database().reference(withPath: "Family-Online")
        //key.setValue( email)
      //  key.setValue(emailFormat)
       // userRef.updateChildValues(["\( DataBaseControl.num)": emailFormat])
        userRef.childByAutoId().setValue(emailFormat)
      
   
      

}
  //delet user when log out
    public func deletOnlineFamily(_ email: String){
        print("Start delete email : ---")
     let   userEm = formatEmail(email)
    let foodRef = Database.database().reference(withPath: "Family-Online")
        root.child("Family-Online").observe(.value, with: { (snapshot) in
            if let emails = snapshot.value as?  NSDictionary {
                    for (key, value) in emails {
                   let em = value as? String
                    let id = key
                    print("\(key) -> \(value)")
                        print(email)
                        if (em?.lowercased() == userEm.lowercased()){
                        print("catch eamil")
                        foodRef.child("\(id)").removeValue()
                        break
                    }
                }
        }
        })
        
        }

    public func addFoodItem(itemInfo: [String:[String:Any?]]){
         let foodRef = Database.database().reference(withPath: "grocery-items")
        foodRef.updateChildValues(itemInfo)
      //  foodRef.setValue(itemInfo)
 }
    
    public func deletFoodItem(_ nameOfFood: String){
    let foodRef = Database.database().reference(withPath: "grocery-items")
        foodRef.child(nameOfFood).removeValue()
       
}
    public func UpdateFoodItem(_ nameOfFood: UserChoese ,_ new: [String: [String:Any?]] ,_ completState: Bool ,_ updateFor : updatWichStep){
        let foodRef = Database.database().reference(withPath: "grocery-items")
        switch updateFor {
        case .name:
            deletFoodItem(nameOfFood.foodItem)
            addFoodItem(itemInfo: new)
           
        case .compleate:
            foodRef.child(nameOfFood.foodItem).updateChildValues(["compleate": completState])
        }
}
   
    enum updatWichStep {
        case name
        case compleate
    }


     public func userExists(with email:String, completion: @escaping ((Bool) -> Void)) {
        
       let  newEmail = formatEmail(email)
        
        root.child(newEmail).observeSingleEvent(of: .value) { snapshot in
        
            guard snapshot.value as? String != nil else {
                // otherwise... let's create the account
                completion(false)
                return
            }
           
            completion(true)
        }
    }

    public enum DatabaseError: Error {
        case failedToFetch
    }
    
    
    public func fatchAllItems( completion: @escaping ([UserChoese] ) -> Void){
      root.child("grocery-items").observe(.value, with: { (snapshot) in
        var AllItems = [UserChoese]()
        
        if let foodDict = snapshot.value as? [String:AnyObject] {
            for (_,value) in foodDict {
 
             let emailUser = value["addByUser"] as? String
             let comp = value["compleate"] as? Bool
             let namefood = value["name"] as? String
             
             let food = UserChoese(foodItem: namefood! , email: emailUser!,
                                   forFierbace: [namefood! : ["addByUser": emailUser,
                                                         "compleate" : comp,
                                                         "name": namefood]])
                AllItems.append(food)
            }
            AllItems  = AllItems.sorted(by: { $0.foodItem.lowercased() < $1.foodItem.lowercased() })
        
            completion(AllItems)
            
        }
            
        })
            
    }
    

    
    public func fatchAllOnlineFamily( completion: @escaping ([String] ) -> Void){
        
        root.child("Family-Online").observe(.value, with: { (snapshot) in
            var AllIemails = [String]()
            if let emails = snapshot.value as?  NSDictionary {
                for (key, value) in emails {
                let emailUser = value as? String
                    AllIemails.append(emailUser!)}
        }
            completion(AllIemails)
        })
            
    }
    
    
}
