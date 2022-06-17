
import UIKit
import SwiftyKeychainKit

class LoginViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var titleLable: UILabel!
    
    
    // MARK: - Properties
    let keychain = Keychain(service: "Entrance")
    let accessTokenKey = KeychainKey<String>(key: "password")
    
    
    // MARK: - View Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.titleLableConfigure()
    }
    
    func titleLableConfigure(){
        var index = 0.0
        titleLable.text = ""
        let titleText = Constants.appName
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.1 * index, repeats: false) { (timer) in
                self.titleLable.text?.append(letter)
            }
            index += 1
        }
    }
    
    
    // MARK: - IBActions
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        let userPassword = userPasswordTextField.text
        let userRepeatPassword = repeatPasswordTextField.text
        
        // Check for empty fields
        if (userPassword!.isEmpty || userRepeatPassword!.isEmpty) {
            self.showAlert(title: "", message: "All fields are required", complition: nil)
            return
        }
        // Check if passwords match
        if(userPassword != userRepeatPassword){
            self.showAlert(title: "", message: "Passwords do not match", complition: nil)
            return
        }
        // Check username and password in the data
        let value = try? keychain.get(accessTokenKey)
        
        if userPassword == value {
            guard let controller = self.storyboard?.instantiateViewController(withIdentifier: Constants.startViewController) as? StartViewController else {return}
            self.navigationController?.pushViewController(controller, animated: true)
        } else {
            self.showAlert(title: "Try again!", message: "Incorrect password!", complition: nil)
        }
    }
    
    @IBAction func createButtonPressed(_ sender: UIButton) {
        
        let userPassword = userPasswordTextField.text
        let userRepeatPassword = repeatPasswordTextField.text
        
        // Check for empty fields
        if (userPassword!.isEmpty || userRepeatPassword!.isEmpty) {
            self.showAlert(title: "", message: "All fields are required", complition: nil)
            return
        }
        // Check the word length
        if userPassword!.count < 3 {
            self.showAlert(title: "Sorry!", message: "The password must be greater that 2 characters.", complition: nil)
        }
        // Check if passwords match
        if(userPassword != userRepeatPassword){
            self.showAlert(title: "", message: "Passwords do not match", complition: nil)
            return
        }
        // Store data
        if let password = userPassword {
            try? keychain.set(password, for : accessTokenKey)
        }
        
        // Display alert message with confirmation
        self.showAlert(title: "", message: "Registration successful, Thank you!") {
            guard let controller = self.storyboard?.instantiateViewController(withIdentifier: Constants.startViewController) as? StartViewController else {return}
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

