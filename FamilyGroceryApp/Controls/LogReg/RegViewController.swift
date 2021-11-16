

import UIKit
import Firebase
class RegViewController: UIViewController {
    var imageView : UIImageView!
    var User_name : UITextField!
    var User_email: UITextField!
    var User_pass : UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() //to hide keybord after finish
                creatUI()
               
            }
    //MARK:- UI Desgin part

            func creatUI(){
                let frame_label1 = CGRect.init(x: 200, y: 140, width: 300, height: 50 )
                let label1 = CustomLabel(#colorLiteral(red: 0.26347211, green: 0.6660528779, blue: 0.3595944047, alpha: 1),"Create Account,",30,frame_label1 )
                label1.font = UIFont.boldSystemFont(ofSize: 35)
                helper.createLabelWithAnchor(label: label1, view: view, frame: frame_label1)
                
                let frame_label2 = CGRect.init(x: 205, y: 180, width: 300, height: 50 )
                let label2 = CustomLabel(#colorLiteral(red: 0.6620889306, green: 0.7351868749, blue: 0.8310958147, alpha: 1)," To join your family grocery!",23,frame_label2 )
                helper.createLabelWithAnchor(label: label2, view: view, frame: frame_label2)
                
                let frame_image = CGRect.init(x: 140, y: 570, width: 300, height: 290 )
                 imageView = CustomImage(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1),frame_image )
                helper.createImageWithAnchor(tf:  imageView, view: view, frame: frame_image)
        
                
                let frame_email = CGRect.init(x: 50, y: 270, width: 300, height: 50 )
                 User_email = CustomTextFiled(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)," Email Address...",12,frame_email )
                helper.createTextFieldWithAnchor(tf: User_email, view: view, frame: frame_email)
                
                let frame_pass = CGRect.init(x: 50, y: 350, width: 300, height: 50 )
                 User_pass = CustomTextFiled(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)," Password...",12,frame_pass )
                helper.createTextFieldWithAnchor(tf: User_pass, view: view, frame: frame_pass)
                User_pass.isSecureTextEntry = true
                
                let frame_log = CGRect.init(x: 192, y: 430, width: 300, height: 50 )
                let but_log = CustomButton(#colorLiteral(red: 0.03237112984, green: 0.5671246648, blue: 0.506488502, alpha: 1),"Sing Up",12,frame_log, .login )
                helper.createButtonWithAnchorforLogAndReg(btn: but_log, view: view, frame: frame_log)
                
                let frame_reg = CGRect.init(x: 235, y: 490, width: 300, height: 50 )
                let label_reg = CustomLabel(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)," I'm already a member, ",15,frame_reg )
                helper.createLabelWithAnchor(label: label_reg, view: view, frame: frame_reg)
                
                let fream_but_reg = CGRect.init(x: 265, y: 490, width: 300, height: 50 )
                let but_reg = UIButton(frame: fream_but_reg)
                but_reg.setTitle(" LogIn ", for: UIControl.State.normal)
                but_reg.setTitleColor(#colorLiteral(red: 0.9658085704, green: 0.2314590812, blue: 0.1949381828, alpha: 1), for: .normal)
                but_reg.titleLabel?.font = UIFont.systemFont(ofSize: 15)
                helper.createButtonWithAnchor(btn: but_reg, view: view, frame: fream_but_reg)
                
                //Action
                but_reg.addTarget(self, action: #selector(GoTologin), for: .touchUpInside)
                but_log.addTarget(self, action: #selector(SingUp), for: .touchUpInside)
                
            }
   
    // MARK:- Transfor Part

@objc func GoTologin(_ sender: UIButton) {
 let log = LogInViewController.init(nibName: "LogInViewController", bundle: nil)
                  self.navigationController?.pushViewController(log, animated: true)
   }

          


    // MARK:- sing up Part (By email and password) -- > check for wronk format email and password less then 6 digit
    
    @objc func SingUp (_ sender: UIButton) {
           guard let email = User_email.text,
              let password = User_pass.text,
              password.count >= 6 else{
            alertUserLoginError(mass:"plese enter  6 and up letters in your password")
            return
        }
        if(isValidEmail(email: email) == false){
           alertUserLoginError(mass:"Email Format is Wrong")
           return
        }
        
        // Firwbace sing up
        DataBaseControl.shared.userExists(with: email, completion: { [weak self]exists in
                    guard let strongSelf = self else {
                        return
                    }
            guard !exists else {
                strongSelf.alertUserLoginError(mass: "The email is already in the system")
                return
            }
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: {authResult, error in
 
                guard authResult != nil, error == nil else {
                    print("Error creating User")
                    return
                }
                strongSelf.saveLoggedState()
                DataBaseControl.shared.saveEmail(email)
                let list = GroceryListViewController()
                strongSelf.navigationController?.pushViewController(list, animated: true)
            })
        })
     
   
    }
    
    func saveLoggedState() {

            let def = UserDefaults.standard
            def.set(true, forKey: "is_authenticated") // save true flag to UserDefaults
            def.synchronize()

    }
                
    func alertUserLoginError (mass : String = "plese enter all information" ){
            let alert = UIAlertController(title: "Error", message: mass , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
     }
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    
    
}
