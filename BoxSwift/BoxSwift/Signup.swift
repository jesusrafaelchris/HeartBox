//
//  SignUpPage.swift
//  KeyloopCarApp
//
//  Created by Christian Grinling on 08/11/2021.
//

import UIKit
import Firebase

class SignUp: UIViewController, UITextFieldDelegate {
    
    
    var ref: DatabaseReference!
    
    lazy var NoteBoxImage: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "NoteBox")
        imageview.contentMode = .scaleAspectFit
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    lazy var namefield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "First Name"
        textfield.returnKeyType = .continue
        textfield.delegate = self
        textfield.autocorrectionType = .no
        textfield.autocapitalizationType = .none
        textfield.spellCheckingType = .no
        textfield.addImage(image: "person.fill", size: 10, colour: .black, weight: .bold, scale: .medium, padding: 40)
        textfield.tag = 0
        return textfield
    }()
    
    lazy var emailfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Email"
        textfield.returnKeyType = .continue
        textfield.delegate = self
        textfield.autocorrectionType = .no
        textfield.autocapitalizationType = .none
        textfield.spellCheckingType = .no
        textfield.addImage(image: "envelope.fill", size: 10, colour: .black, weight: .bold, scale: .medium, padding: 40)
        textfield.tag = 1
        return textfield
    }()
    
    lazy var passwordfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Password"
        textfield.autocorrectionType = .no
        textfield.autocapitalizationType = .none
        textfield.spellCheckingType = .no
        textfield.addImage(image: "lock.open.fill", size: 10, colour: .black, weight: .bold, scale: .medium, padding: 40)
        textfield.isSecureTextEntry = true
        textfield.returnKeyType = .done
        textfield.delegate = self
        textfield.tag = 2
        return textfield
    }()
    
    lazy var SignupTitle: UILabel = {
        let text = UILabel()
        text.layout(colour: .black, size: 23, text: "Sign up", bold: true)
        return text
    }()
    
    lazy var signupButton = darkblackbutton.textstring(text: "Signup")
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismisskeyboard)))
        signupButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        ref = Database.database().reference()
    }
    
    
    @objc func signUp() {
        //define safe textfields
        self.showSpinner(onView: view)
        guard let name = namefield.text else {return}
        guard let email = emailfield.text else {return}
        guard let password = passwordfield.text else {return}
        
        //check if they're empty
        checkIfEmpty(fields: [namefield,emailfield,passwordfield])
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if error != nil {
                self.AlertofError("Please try again", error!.localizedDescription)
                self.removeSpinner()
                return
            }
            else {
                //add display name
                self.addDisplayName(name: name)
                guard let uid = Auth.auth().currentUser?.uid else {return}
                self.ref.child("users").child(uid).child("name").setValue(name)
                self.ref.child("users").child(uid).child("uid").setValue(uid)
                self.removeSpinner()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc func dismisskeyboard() {
        namefield.resignFirstResponder()
        emailfield.resignFirstResponder()
        passwordfield.resignFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        self.namefield.addBottomBorder(colour: UIColor(hexString: "222222").cgColor)
        self.emailfield.addBottomBorder(colour: UIColor(hexString: "222222").cgColor)
        self.passwordfield.addBottomBorder(colour: UIColor(hexString: "222222").cgColor)
    }
    
    func setupView() {
        view.addSubview(NoteBoxImage)
        view.addSubview(namefield)
        view.addSubview(emailfield)
        view.addSubview(passwordfield)
        view.addSubview(SignupTitle)
        view.addSubview(signupButton)
        
        NoteBoxImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 30, bottom: nil, paddingBottom: 30, left: nil, paddingLeft: 20, right: nil, paddingRight: 20, width: 0, height: 0)
        NoteBoxImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            self.NoteBoxImage.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.2).isActive = true
        self.NoteBoxImage.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8).isActive = true
        
        
        SignupTitle.anchor(top: NoteBoxImage.bottomAnchor, paddingTop: 30, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 20, right: nil, paddingRight: 40, width: 0, height: 0)
        
        namefield.anchor(top: SignupTitle.bottomAnchor, paddingTop: 30, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 20, right: nil, paddingRight: 20, width: 0, height: 45)
        namefield.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        namefield.widthAnchor.constraint(equalTo:view.widthAnchor,multiplier: 0.7).isActive = true
        
        emailfield.anchor(top: namefield.bottomAnchor, paddingTop: 30, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 20, right: nil, paddingRight: 20, width: 0, height: 45)
        emailfield.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailfield.widthAnchor.constraint(equalTo:view.widthAnchor,multiplier: 0.7).isActive = true
 
        
        passwordfield.anchor(top: emailfield.bottomAnchor, paddingTop: 30, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 20, right: nil, paddingRight: 20, width: 0, height: 45)
            passwordfield.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordfield.widthAnchor.constraint(equalTo:view.widthAnchor,multiplier: 0.7).isActive = true
        
        
        signupButton.anchor(top: nil, paddingTop: 0, bottom: view.bottomAnchor, paddingBottom: 40, left: nil, paddingLeft: 0, right: nil, paddingRight: 0, width: 0, height: 0)
        signupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signupButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6).isActive = true
        signupButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.06).isActive = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       // Try to find next responder
       if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
          nextField.becomeFirstResponder()
       } else {
          // Not found, so remove keyboard.
          textField.resignFirstResponder()
       }
       // Do not add a line break
       return false
    }
        
}

extension SignUp {
    
    func addDisplayName(name: String) {
        let user = Auth.auth().currentUser
        if let user = user {
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = name
            changeRequest.commitChanges { error in
             if let error = error {
                print(error.localizedDescription)
             } else {
               print("Added Display Name")
             }
           }
        }
    }
    
    
    func checkIfEmpty(fields: [UITextField]) {
        for field in fields {
            if field.text?.isEmpty == true {
                    return self.Alert(field.placeholder!)
                }
            }
        }

}

