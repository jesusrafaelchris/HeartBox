//
//  AddboxPickName.swift
//  BoxSwift
//
//  Created by Christian Grinling on 19/01/2022.
//

import UIKit
import Firebase

class AddboxPickName: UIViewController, UITextFieldDelegate {
    
    var code:String = ""
    var ref: DatabaseReference!
    
    lazy var picknametitle: UILabel = {
        let label = UILabel()
        label.layout(colour: UIColor(hexString: "222222"), size: 20, text: "Pick a name for your box", bold: true)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var namefield: UITextField = {
        let field = UITextField()
        field.layout(placeholder: "name", backgroundcolour: .clear, bordercolour: .clear, borderWidth: 0, cornerRadius: 0)
        field.returnKeyType = .done
        return field
    }()

    lazy var doneButton = darkblackbutton.textstring(text: "Next")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        print(code)
        setupView()
        namefield.becomeFirstResponder()
        namefield.delegate = self
        doneButton.addTarget(self, action: #selector(addbox), for: .touchUpInside)
        setupnavbar()
        ref = Database.database().reference()
    }
    
    func setupnavbar() {
        let dismissbutton = UIBarButtonItem(image: UIImage(systemName: "multiply.circle.fill")?.withTintColor(UIColor(hexString: "222222")).withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(dismisspage))
        self.navigationItem.rightBarButtonItem  = dismissbutton
        self.title = "Add NoteBox"
    }
    
    @objc func dismisspage() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func addbox() {
        //add box to firebase then dismiss
        if namefield.text?.isEmpty == true{
            self.AlertofError("Sorry", "Please enter a name for your box")
        }
        else {
            //add box to firebase
            
            guard let uid = Auth.auth().currentUser?.uid else {return}
            self.ref.child("users").child(uid).child("box-code").setValue(self.code)
            self.ref.child("users").child(uid).child("box-name").setValue(namefield.text)
            self.ref.child("test").child(code).setValue("Setup Complete")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidLayoutSubviews() {
        self.namefield.addBottomBorder(colour: UIColor(hexString: "222222").cgColor)
    }

    func setupView() {
        view.addSubview(picknametitle)
        view.addSubview(namefield)
        view.addSubview(doneButton)
        
        picknametitle.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 100, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 0, right: nil, paddingRight: 0, width: 0, height: 0)
        picknametitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        namefield.anchor(top: picknametitle.bottomAnchor, paddingTop: 30, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 5, right: nil, paddingRight: 5, width: 0, height: 0)
        namefield.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        namefield.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        namefield.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07).isActive = true
        
        doneButton.anchor(top: nil, paddingTop: 0, bottom: view.bottomAnchor, paddingBottom: 40, left: nil, paddingLeft: 0, right: nil, paddingRight: 0, width: 0, height: 0)
        doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        doneButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6).isActive = true
        doneButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.06).isActive = true
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }

}
