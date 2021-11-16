

import UIKit
import Firebase

class GroceryListViewController: UIViewController {
    private var items = [UserChoese]()
    var FoodName: String?
// MARK:- table view making
    private let tabelView: UITableView = {
        let table = UITableView()
        table.isHidden = true
      table.register(ListTableViewCell.self, forCellReuseIdentifier: "ListTableViewCell")
        return table
    }()
    
    private let isThereItem: UILabel = {
        let label = UILabel()
        label.text = "There is no item, you want to buy! "
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.isHidden = false
        return label
    }()
    
    var titleView = UIView(frame: CGRect(x: 0, y: 0, width: 170, height: 40))
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tabelView)
        view.addSubview(isThereItem)
      
        isThereItem.frame = CGRect(x: 40, y: 150, width: 300, height: 80)
        setupTabel()
        fetchItems()
    
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabelView.frame = view.bounds
    }
    // let nivigation on
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        setUpNevgationControl()
       
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    private func setupTabel (){
        print("Start set up tabel")
        tabelView.delegate = self
        tabelView.dataSource = self
  
    }
    
//MARK :- unhidd the navgation
    func setUpNevgationControl (){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFood))
        navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.title = "Groceries To Buy"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
       navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.26347211, green: 0.6660528779, blue: 0.3595944047, alpha: 1)
     
        let myimage = UIImage(systemName: "person")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: myimage, style: .plain, target: self, action: #selector(GoToFamilyOnline))
        
    navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
       
   }
    
    
//MARK:- dilog of add food item
    
    @objc func addFood() {
        let alert = UIAlertController(title: "Grosery List",message: "Add an item", preferredStyle: .alert)
                let saveAction = UIAlertAction(title: "Save", style: .default) {
          [unowned self] action in
                                        
          guard let textField = alert.textFields?.first,
                let nameToSave = textField.text else {
              return
          }
            FoodName = nameToSave
          let x = UserChoese( foodItem: nameToSave, email: UserDefaults.standard.value(forKey: "email") as! String,
                              forFierbace:[nameToSave : [
                                            "addByUser": UserDefaults.standard.value(forKey: "email") as! String,
                                            "compleate" : false,
                                            "name":nameToSave
                              ]]  )
                  
                    self.items.append(x)
            isThereItem.isHidden = true
            DataBaseControl.shared.addFoodItem(itemInfo: x.forFierbace)
            //self.tabelView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }

    //MARK:- transition part
    @objc func GoToFamilyOnline() {
     let vc = onlineFamilyMemberViewController.init(nibName: "onlineFamilyMemberViewController", bundle: nil)
       self.navigationController?.pushViewController(vc, animated: true)
       }

//MARK:- fatch All items andd add them in tabel view

private func fetchItems(){
    self.items.removeAll()
    print("Starting items Fetch...")
    DataBaseControl.shared.fatchAllItems{ (AllItems) in
        self.items = AllItems
        self.tabelView.isHidden = false
        self.isThereItem.isHidden = true
        DispatchQueue.main.async {
            self.tabelView.reloadData()
        }
        
       
    }

}

//MARK:- check if he's still log in or log out
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateAuth()
   }


private func validateAuth(){
        // current user is set automatically when you log a user in
    if FirebaseAuth.Auth.auth().currentUser == nil {
            // present login view controller
            let vc = LogInViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false)
        }
    }
}
//MARK:- tabel view part ( Add data to table view , updte And delet part)

extension GroceryListViewController:  UITableViewDelegate, UITableViewDataSource {
    
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let model = items[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
    cell.configure(with: model)
    return cell
}
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let x =  ListTableViewCell.shared.com(with: items[indexPath.row])
    self.items[indexPath.row].forFierbace[self.items[indexPath.row].foodItem]?["compleate"]! = x
  }
func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
  
func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let update = UIContextualAction(style: .normal, title:  "Update", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
           
            self.updateItem(self.items[indexPath.row],indexPath.row)
                print("Update Done.")
            success(true)
        })
        update.backgroundColor = .blue
        
        return UISwipeActionsConfiguration(actions: [update])
    }
    
func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let delete = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
           print(self.items[indexPath.row].foodItem)
            DataBaseControl.shared.deletFoodItem(self.items[indexPath.row].foodItem)
            print(indexPath.row)
            self.items.remove(at: indexPath.row)
            self.tabelView.reloadData()
            success(true)
            print("Delet Done")
            
        })
        delete.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [delete])
    
    }

    func updateItem (_ itemInfo: UserChoese,_ index :Int) {
        let alert = UIAlertController(title: "Grosery List",message: "Updaet the \(itemInfo.foodItem)", preferredStyle: .alert)
        var newName: String?
        let saveAction = UIAlertAction(title: "Updaet", style: .default) {
          [unowned self] action in
                                        
          guard let textField = alert.textFields?.first,
                let nameToSave = textField.text else {
              return
          }
            let completeState = itemInfo.forFierbace[itemInfo.foodItem]?["compleate"]!
            print(nameToSave)
            
            let food =   [nameToSave :["addByUser": UserDefaults.standard.value(forKey: "email") as! String,
                                       "compleate" : completeState!,
                                       "name": nameToSave] as [String : Any]]
            
            self.items.remove(at: index)
            
            let newItem = UserChoese(foodItem: nameToSave , email: UserDefaults.standard.value(forKey: "email") as! String,
                                     forFierbace: food)
            self.items.append(newItem)
            DataBaseControl.shared.UpdateFoodItem(itemInfo, food, completeState as! Bool , .name)

        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
        
    }
}

