//
//  AddBoxPage.swift
//  BoxSwift
//
//  Created by Christian Grinling on 19/01/2022.
//

import UIKit
import AEOTPTextField

class AddBoxPage: UIViewController {
    
    lazy var addboxtitle: UILabel = {
        let label = UILabel()
        label.layout(colour: UIColor(hexString: "222222"), size: 20, text: "Enter the code displayed\non your box", bold: true)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var otpTextField = AEOTPTextField()
    lazy var nextButton = darkblackbutton.textstring(text: "Next")
    var code:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        otpTextField.otpDelegate = self
        otpTextField.configure(with:6)
        //otpTextField.otpFilledBorderColor = .clear
        setupnavbar()
        setupView()
        nextButton.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
    }
    
    @objc func nextPage() {
        if code == "" {
            self.AlertofError("Sorry", "Please enter a code first")
        }
        else {
            let pickname = AddboxPickName()
            pickname.code = self.code
            self.navigationController?.pushViewController(pickname, animated: true)
        }
    }
    
    func setupView() {
        view.addSubview(otpTextField)
        view.addSubview(addboxtitle)
        view.addSubview(nextButton)
        
        addboxtitle.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 100, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 0, right: nil, paddingRight: 0, width: 0, height: 0)
        addboxtitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        otpTextField.anchor(top: addboxtitle.bottomAnchor, paddingTop: 30, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 5, right: nil, paddingRight: 5, width: 0, height: 0)
        otpTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        otpTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        otpTextField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07).isActive = true
        
        nextButton.anchor(top: nil, paddingTop: 0, bottom: view.bottomAnchor, paddingBottom: 40, left: nil, paddingLeft: 0, right: nil, paddingRight: 0, width: 0, height: 0)
        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nextButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6).isActive = true
        nextButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.06).isActive = true
            
    }
    
    func setupnavbar() {
        let dismissbutton = UIBarButtonItem(image: UIImage(systemName: "multiply.circle.fill")?.withTintColor(UIColor(hexString: "222222")).withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(dismisspage))
        self.navigationItem.rightBarButtonItem  = dismissbutton
        self.title = "Add NoteBox"
    }
    
    @objc func dismisspage() {
        self.dismiss(animated: true, completion: nil)
    }
    

}

extension AddBoxPage: AEOTPTextFieldDelegate {
    func didUserFinishEnter(the code: String) {
        print(code)
        self.code = code
    }
}
