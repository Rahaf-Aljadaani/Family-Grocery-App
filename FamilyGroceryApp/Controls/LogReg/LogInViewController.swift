
import UIKit
import Firebase
import FBSDKLoginKit

//MARK:- for hid the Keyboard after finish
extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
//MARK:- LogInViewController class

class LogInViewController: UIViewController, LoginButtonDelegate {

    var User_email: UITextField!
    var User_pass : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() //to hide keybord after finish
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        creatUI()
        
    }
  // to hidd navgathion
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
//MARK:- UI Desgin part
    func creatUI(){
        
        let frame_label1 = CGRect.init(x: 190, y: 120, width: 300, height: 50 )
        let label1 = CustomLabel(#colorLiteral(red: 0.2021231055, green: 0.6579886675, blue: 0.324999541, alpha: 1),"Family Grocery,",30,frame_label1 )
        label1.font = UIFont.boldSystemFont(ofSize: 35)
        helper.createLabelWithAnchor(label: label1, view: view, frame: frame_label1)
        
        let frame_label2 = CGRect.init(x: 200, y: 159, width: 300, height: 50 )
        let label2 = CustomLabel(#colorLiteral(red: 0.6935898066, green: 0.762383163, blue: 0.8463421464, alpha: 1)," Log in to continue ! ",23,frame_label2 )
        helper.createLabelWithAnchor(label: label2, view: view, frame: frame_label2)
        
        let frame_email = CGRect.init(x: 50, y: 250, width: 300, height: 50 )
        User_email = CustomTextFiled(#colorLiteral(red: 0.2454971075, green: 0.7021718621, blue: 0.9091929197, alpha: 1)," Email Address...",12,frame_email )
        helper.createTextFieldWithAnchor(tf: User_email, view: view, frame: frame_email)
        
        let frame_pass = CGRect.init(x: 50, y: 330, width: 300, height: 50 )
        User_pass = CustomTextFiled(#colorLiteral(red: 0.2454971075, green: 0.7021718621, blue: 0.9091929197, alpha: 1)," Pasword...",12,frame_pass )
        helper.createTextFieldWithAnchor(tf: User_pass, view: view, frame: frame_pass)
        User_pass.isSecureTextEntry = true
        //chang color to let it has 2 coloers
        let x = CAGradientLayer()
        x.colors = [ #colorLiteral(red: 0.9892026782, green: 0.8187041879, blue: 0.4117269516, alpha: 1), UIColor.white.cgColor]
        x.frame = view.frame
      
        let frame_log = CGRect.init(x: 192, y: 410, width: 300, height: 50 )
        let but_log = CustomButton(#colorLiteral(red: 0.03237112984, green: 0.5671246648, blue: 0.506488502, alpha: 1),"Log In",12,frame_log, .login )
        helper.createButtonWithAnchorforLogAndReg(btn: but_log, view: view, frame: frame_log)
        but_log.layer.addSublayer(x)//
        
        let frame_image = CGRect.init(x: 140, y: 570, width: 300, height: 290 )
         let imageView = CustomImage(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1),frame_image )
        helper.createImageWithAnchor(tf:  imageView, view: view, frame: frame_image)

        LogInFaceBock()
       
        let frame_reg = CGRect.init(x: 260, y: 520, width: 300, height: 50 )
        let label_reg = CustomLabel(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)," I'm a new user. ",15,frame_reg )
        helper.createLabelWithAnchor(label: label_reg, view: view, frame: frame_reg)
        
        let fream_but_reg = CGRect.init(x: 250, y: 520, width: 300, height: 50 )
        let but_reg = UIButton(frame: fream_but_reg)
        but_reg.setTitle(" Register ", for: UIControl.State.normal)
        but_reg.setTitleColor(#colorLiteral(red: 0.9736532569, green: 0.2390243411, blue: 0.1905537248, alpha: 1), for: .normal)
        but_reg.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        helper.createButtonWithAnchor(btn: but_reg, view: view, frame: fream_but_reg)
       
        //actions
        but_reg.addTarget(self, action: #selector(GoToHome), for: .touchUpInside)

        but_log.addTarget(self, action: #selector(LogIn), for: .touchUpInside)
            
      
    }
    func dseginForFB(_ but : FBLoginButton , _ frame : CGRect ){
        but.layer.cornerRadius = CGFloat(12)
        but.layer.masksToBounds = true
        but.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        helper.createButtonWithAnchorforLogAndReg(btn: but, view: view, frame: frame)
    }
    
    
    // MARK:- transition Part
    
        @objc func GoToHome(_ sender: UIButton) {
              let reg = RegViewController.init(nibName: "RegViewController", bundle: nil)
              self.navigationController?.pushViewController(reg, animated: true)
          }

        // MARK:- LogIn Part (By email and password) -- > check for wronk format email and password less then 6 digit
    
        @objc func LogIn (_ sender: UIButton) {
                    
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
            
            // Firwbace Log In
            FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: {authResult, error in
                guard let result = authResult, error == nil else {
                    print("Error LogIn")
                    return
                }
                
                let user = result.user
            
                DataBaseControl.shared.saveEmail(email)

                print("Loged user: \(user)")
               let list = GroceryListViewController()
                self.navigationController?.pushViewController(list, animated: true)
            })
         
     
      
        }
        
        func saveLoggedState() {

            let def = UserDefaults.standard
            def.set(true, forKey: "is_authenticated") // save true flag to UserDefaults
            def.synchronize()

        }
        
        func alertUserLoginError (){
            let alert = UIAlertController(title: "Error", message: "plese enter  6 and up letters in your password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
        }
        
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func alertUserLoginError (mass : String = "plese enter all information" ){
            let alert = UIAlertController(title: "Error", message: mass , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
     }

// MARK:- Facebook Part ( logIn )
func LogInFaceBock (){
  if let token = AccessToken.current , !token.isExpired{
            print("Loged user: ")
           let list = GroceryListViewController()
            self.navigationController?.pushViewController(list, animated: true)
    let token = token.tokenString
    let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields":"email, name"],
                                             tokenString: token, version: nil,
                                             httpMethod: .get)
    request.start(completion: {connection , result , error in
        print("\(result)")
        
    })
    
        }
        else {
            let frame_F = CGRect.init(x: 192, y: 490, width: 280, height: 100 )
            let loginButton = FBLoginButton(frame: frame_F)
            dseginForFB(loginButton,frame_F)
            loginButton.delegate = self
            loginButton.permissions = ["public_profile" , "email"]
        }
    }
    
    
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        let token = result?.token?.tokenString
        let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields":"email, name"],
    
                                                 tokenString: token, version: nil,
                                                 httpMethod: .get)
        request.start(completion: {connection , result , error in
            print("\(result)")
            
        })
        
    }
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
    }
    




}
