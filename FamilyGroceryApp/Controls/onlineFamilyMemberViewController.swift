

import UIKit
import Firebase

class onlineFamilyMemberViewController: UIViewController {

    var family = [String]()
    static let shared = onlineFamilyMemberViewController()
     static var  manyOfUsers = 1
  
    // MARK:- UI desgn making and creat view func

    
    private let tabelView: UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.register(onlineFamilyTableViewCell.self, forCellReuseIdentifier: "onlineFamilyTableViewCell")    
        return table
    }()
    
    private let isThereItem: UILabel = {
        let label = UILabel()
        label.text = "There is no one online"
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
        fitchAllOnlineEmails()
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
  
    // MARK:- navgation design
    func setUpNevgationControl (){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "LogOut", style: .plain, target: self, action: #selector(logOut))
        navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
      
        self.title = "Family(Online)"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
       navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Grocery", style: .plain, target: self, action: #selector(goBack))
        navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    private func setupTabel (){
        tabelView.delegate = self
        tabelView.dataSource = self
    }
   
    // MARK:- transition Part

    @objc func goBack(){
        let vc = GroceryListViewController.init(nibName: "GroceryListViewController", bundle: nil)
          self.navigationController?.pushViewController(vc, animated: true)
    }
   
//MARK:- log out func
    @objc func logOut(){
        do {
            DataBaseControl.shared.deletOnlineFamily(UserDefaults.standard.value(forKey: "email") as! String)
            try FirebaseAuth.Auth.auth().signOut()
            let vc = LogInViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            print("Sucssfaly : to log out")
            present(nav, animated: false)
        }
        catch {
            print("Error : Failed to log out")
        }
    }

   
//MARK:- fitch all onile family
    public func fitchAllOnlineEmails(){
        print("Starting emails Fetch...")
        DataBaseControl.shared.fatchAllOnlineFamily{ (AllEmails) in
            print(AllEmails)
            self.family = AllEmails
            print(  self.family)
            self.tabelView.isHidden = false
            self.isThereItem.isHidden = true
                self.tabelView.reloadData()
        }
    }
    
}
//MARK:- tabel view part ( Add data to table view)


extension onlineFamilyMemberViewController:  UITableViewDelegate, UITableViewDataSource {
    
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return family.count
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let model = family[indexPath.row]
   
    let cell = tableView.dequeueReusableCell(withIdentifier: "onlineFamilyTableViewCell", for: indexPath) as! onlineFamilyTableViewCell
   
    cell.configure(with: model)
    return cell
    
}
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    


}
