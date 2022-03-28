//
//  sendmessage.swift
//  BoxSwift
//
//  Created by Christian Grinling on 19/01/2022.
//

import UIKit
//import SwiftyDraw
import Firebase
import SwiftMessages

class sendmessage: UIViewController, UITextViewDelegate{
    
    var ref: DatabaseReference!
    var code: String = ""
    var userid: String = "test"
    
    lazy var textview: UITextView = {
        let textview = UITextView()
        textview.backgroundColor = UIColor(hexString: "222222")
        textview.layer.cornerRadius = 10
        textview.layer.masksToBounds = true
        textview.textColor = .white
        textview.textAlignment = .center
        textview.textContainer.maximumNumberOfLines = 1
        textview.textContainer.lineBreakMode = .byTruncatingTail
        textview.font = UIFont(name: "Baskerville-Bold", size: 20)
        return textview
    }()
    
//    lazy var drawView: SwiftyDrawView = {
//        let drawview = SwiftyDrawView()
//        drawview.backgroundColor = UIColor(hexString: "222222")
//        drawview.brush.color = Color(.white)
//        return drawview
//    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        addAccessoryView()
        textview.delegate = self
        ref = Database.database().reference()
        getnameandcode()
        let dismissbutton = UIBarButtonItem(image: UIImage(systemName: "multiply.circle.fill")?.withTintColor(UIColor(hexString: "222222")).withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(dismisspage))
        self.navigationItem.rightBarButtonItem = dismissbutton
    }
    
    @objc func dismisspage() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getuserdata(completion: @escaping(_ user: userclass) -> ()) {
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        ref.child("users").child(uid).observe(DataEventType.value, with: { snapshot in
          // Get user value
            guard let value = snapshot.value as? [String:Any] else {return}
            let user = userclass(dictionary: value)
            completion(user)
        })
    }
    
    func getnameandcode() {
        getuserdata { user in
        guard let partnername = user.partnername else {return}
        guard let partnerbox = user.partnerbox else {return}
        guard let partneruid = user.partneruid else {return}
         
        self.code = partnerbox
        self.title = partnername
        self.userid = partneruid
        }
    }
    
    override func viewDidLayoutSubviews() {
        textview.centerVertically()
    }
    
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        return text != "\n"
//    }
    
    let CharacterLimit = 26
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        //CharacterCount.text = "\(textview.text.count) / \(CharacterLimit)"
        let currentText = textview.text as NSString
        let updatedText = currentText.replacingCharacters(in: range, with: text)

        return updatedText.count <= CharacterLimit
    }
    
    func addAccessoryView() -> Void {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        toolBar.setBackgroundImage(UIImage(),
                                        forToolbarPosition: .any,
                                        barMetrics: .default)
        toolBar.setShadowImage(UIImage(), forToolbarPosition: .any)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let sendbutton = UIButton()
        sendbutton.frame = CGRect(x:0, y:0, width:120, height:40)
        sendbutton.layout(textcolour: .white, backgroundColour: UIColor(hexString: "0165FF"), size: 15, text: "Send ♡", image: nil, cornerRadius: 20)
        sendbutton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        
        let keyboardbutton = UIButton()
        keyboardbutton.frame = CGRect(x:0, y:0, width:40, height:40)
        keyboardbutton.layout(textcolour: nil, backgroundColour: UIColor(hexString: "0165FF"), size: nil, text: nil, image: UIImage(systemName: "textformat")?.withTintColor(.white).withRenderingMode(.alwaysOriginal), cornerRadius: 20)
        
        let spacerbutton = UIButton()
        spacerbutton.frame = CGRect(x:0, y:0, width:0, height:20)
        spacerbutton.layout(textcolour: nil, backgroundColour: .clear, size: nil, text: nil, image: UIImage(systemName: "textformat")?.withTintColor(.clear).withRenderingMode(.alwaysOriginal), cornerRadius: 0)
        
//        let drawbutton = UIButton()
//        drawbutton.frame = CGRect(x:0, y:0, width:40, height:40)
//        drawbutton.layout(textcolour: nil, backgroundColour: .blue, size: nil, text: nil, image: UIImage(systemName: "pencil")?.withTintColor(.white).withRenderingMode(.alwaysOriginal), cornerRadius: 20)
//        drawbutton.addTarget(self, action: #selector(showdrawing), for: .touchUpInside)
        
        let doneButton = UIBarButtonItem(customView: sendbutton)
        let keyboardButton = UIBarButtonItem(customView: keyboardbutton)
        let spacerButton = UIBarButtonItem(customView: spacerbutton)
        //let drawButton = UIBarButtonItem(customView: drawbutton)
        
       // let doneButton = UIBarButtonItem(title: "Send <3", style: .plain, target: self, action: #selector(self.doneButtonTapped(button:)))
        
        toolBar.items = [keyboardButton,spacerButton,flexibleSpace, doneButton]
        toolBar.tintColor = UIColor.blue
        textview.inputAccessoryView = toolBar
    }
    
    func successpopup() {
        let messageView: MessageView = MessageView.viewFromNib(layout: .centeredView)
        messageView.configureBackgroundView(width: 250)
        messageView.configureContent(title: "Succcess", body: "Your note has been sent.", iconImage: nil, iconText: "❤️", buttonImage: nil, buttonTitle: "Dismiss") { _ in
            SwiftMessages.hide()
        }
        messageView.backgroundView.backgroundColor = UIColor.init(white: 0.97, alpha: 1)
        messageView.backgroundView.layer.cornerRadius = 10
        var config = SwiftMessages.defaultConfig
        config.presentationStyle = .center
        config.duration = .forever
        config.dimMode = .blur(style: .dark, alpha: 1, interactive: true)
        config.presentationContext  = .window(windowLevel: UIWindow.Level.statusBar)
        SwiftMessages.show(config: config, view: messageView)
    }
    
    @objc func sendMessage() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let name = Auth.auth().currentUser?.displayName else {return}
        guard let text = textview.text else {return}
        
        let data = ["message": text, "timestamp": ServerValue.timestamp(),"name":name, "uid": uid] as [String : Any]
        
        self.ref.child("messages").child(uid).child(userid).childByAutoId().setValue(data)
        
        self.ref.child("messages").child(userid).child(uid).childByAutoId().setValue(data)
        
        self.ref.child("test").child(self.code).setValue(text){
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
              print("Data could not be saved: \(error).")
            } else {
              print("Data saved successfully!")
                self.dismiss(animated: true, completion: nil)
                self.successpopup()
            }
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textview.becomeFirstResponder()
    }
    
    func setupView() {
        view.addSubview(textview)
//        view.addSubview(drawView)
//        view.addSubview(mainImageView)
        
        textview.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 40, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 20, right: view.rightAnchor, paddingRight: 20, width: 0, height: 0)
        textview.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25).isActive = true
        
//        mainImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 40, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 20, right: view.rightAnchor, paddingRight: 20, width: 0, height: 0)
//        mainImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25).isActive = true
//
//        drawView.anchor(top: nil, paddingTop: 0, bottom: view.bottomAnchor, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 0, right: view.rightAnchor, paddingRight: 0, width: 0, height: 0)
//        drawView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4).isActive = true
        
    }
    

}
