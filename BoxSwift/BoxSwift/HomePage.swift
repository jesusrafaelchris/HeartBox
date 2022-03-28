//
//  HomePage.swift
//  BoxSwift
//
//  Created by Christian Grinling on 19/01/2022.
//

import UIKit
import Firebase

class HomePage: UIViewController {
    
    var ref: DatabaseReference!
    var partnername: String?
    var groupSorted = [[pastmessageclass]]()
    var pastMessages = [pastmessageclass]()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = true
        scrollView.isScrollEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    lazy var heartImage: UIImageView = {
        let imageview = UIImageView()
        imageview.layer.shadowColor = UIColor.black.cgColor
        imageview.layer.shadowOffset = CGSize(width: 0, height: 5)
        imageview.layer.shadowOpacity = 0.2
        imageview.layer.shadowRadius = 15
        imageview.clipsToBounds = false
        let pulseAnimation = CABasicAnimation(keyPath: "opacity")
        pulseAnimation.duration = 3
        pulseAnimation.fromValue = 0.3
        pulseAnimation.toValue = 1
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .infinity
        imageview.layer.add(pulseAnimation, forKey: nil)
        imageview.image = UIImage(named:"heart_test.png")
        imageview.contentMode = .scaleAspectFit
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    lazy var HomeMessagesCV: SelfSizedCollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionview = SelfSizedCollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionview.register(HomeMessagesCell.self, forCellWithReuseIdentifier: "homemessagecell")
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.backgroundColor = .clear
        collectionview.layer.cornerRadius = 20
        collectionview.layer.masksToBounds = true
        collectionview.isScrollEnabled = false
        return collectionview
    }()
    
    lazy var newMessageButton = darkblackbutton.textstring(text: "Send a message <3")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexString: "F5F5F8")
        setupnavbar()
        setupview()
        isLoggedIn()
        newMessageButton.isUserInteractionEnabled = true
        newMessageButton.addTarget(self, action: #selector(gotonewmessagepage), for: .touchUpInside)
        ref = Database.database().reference()
        getpastmessages()
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
    
    func getpastmessages() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        getuserdata { user in
            guard let partnername = user.partnername else {return}
            guard let partnerbox = user.partnerbox else {return}
            guard let partneruid = user.partneruid else {return}
            self.title = partnername
            
            self.ref.child("messages/\(uid)/\(partneruid)").observe(DataEventType.value, with: { snapshot in
                self.pastMessages.removeAll()
                for case let child as DataSnapshot in snapshot.children {
                    guard let dict = child.value as? [String:Any] else {
                        print("Error")
                        return
                    }
                    var message = pastmessageclass(dictionary: dict)
                    self.pastMessages.append(message)
                    self.pastMessages = self.pastMessages.sorted(by: { $0.timestamp! > $1.timestamp! })
                    self.groupSorted = self.pastMessages.groupSort(ascending: false, byDate: {Date(timeIntervalSince1970: $0.timestamp ?? 0.0)})
                    
                    DispatchQueue.main.async {
                        self.HomeMessagesCV.reloadData()
                    }
                }
            })
        }
    }
    
    @objc func gotonewmessagepage() {
        let newMessage = UINavigationController(rootViewController: sendmessage())
        newMessage.modalPresentationStyle = .fullScreen
        navigationController?.present(newMessage, animated: true, completion: nil)
    }
    
    func isLoggedIn() {
        if Auth.auth().currentUser == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
        else {
           //load the pictures
        }
    }

    @objc func handleLogout() {
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print("logout error", logoutError)
        }
        
        let signup = SignUp()
        signup.modalPresentationStyle = .fullScreen
        present(signup, animated: false)
    }
    
    func setupnavbar() {
        let searchbutton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass")?.withTintColor(UIColor(hexString: "222222")).withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(searchbutton))
        let addboxbutton = UIBarButtonItem(image: UIImage(systemName: "plus")?.withTintColor(UIColor(hexString: "222222")).withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(addboxbutton))
        self.navigationItem.rightBarButtonItem  = searchbutton
        self.navigationItem.leftBarButtonItem  = addboxbutton
    }
    
    @objc func searchbutton() {
        let search = searchPage()
        self.navigationController?.present(search, animated: true, completion: nil)
    }
    
    @objc func addboxbutton() {
        let addboxpage = UINavigationController(rootViewController: AddBoxPage())
        addboxpage.modalPresentationStyle = .fullScreen
        navigationController?.present(addboxpage, animated: true, completion: nil)
    }
    
    func setupview() {
        view.addSubview(scrollView)
        scrollView.addSubview(heartImage)
        scrollView.addSubview(HomeMessagesCV)
        view.addSubview(newMessageButton)
        
        newMessageButton.anchor(top: nil, paddingTop: 0, bottom: view.bottomAnchor, paddingBottom: 40, left: nil, paddingLeft: 0, right: nil, paddingRight: 0, width: 0, height: 0)
        newMessageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        newMessageButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6).isActive = true
        newMessageButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.06).isActive = true
        
        scrollView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 0, bottom: view.bottomAnchor, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 0, right: view.rightAnchor, paddingRight: 0, width: 0, height: 0)
        
        heartImage.anchor(top: scrollView.topAnchor, paddingTop: 10, bottom: nil, paddingBottom: 0, left: nil, paddingLeft: 0, right: nil, paddingRight: 0, width: 250, height: 250)
        heartImage.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        HomeMessagesCV.anchor(top: heartImage.bottomAnchor, paddingTop: 10, bottom: scrollView.bottomAnchor, paddingBottom: 0, left: scrollView.leftAnchor, paddingLeft: 30, right: scrollView.rightAnchor, paddingRight: 30, width: 0, height: 0)
    }

}

extension HomePage:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pastMessages.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homemessagecell", for: indexPath) as! HomeMessagesCell
        
        let message = pastMessages[indexPath.row]
        
        //if message.uid != Auth.auth().currentUser?.uid {
        
        if let message = message.message {
            cell.bubbleWidthAnchor?.constant = EstimatedFrame(text: message).width + 40
            cell.note.text = "  \(message)  "
            cell.note.isHidden = false
        }
        
        cell.bubbleView.backgroundColor = .white//UIColor(red: 0.09, green: 0.64, blue: 0.68, alpha: 1.00)
        cell.note.textColor = .black
        cell.bubbleViewLeftAnchor?.isActive = true
        cell.bubbleViewRightAnchor?.isActive = false
        
        //}
        //cell.nametext.text = message.name
        //cell.note.setTextSpacingBy(value: 0.5)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height:CGFloat = 60
        
        let message = pastMessages[indexPath.item]
        
        height = EstimatedFrame(text: message.message!).height + 30
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height)
    }
    
    private func EstimatedFrame(text:String) -> CGRect {
        
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)], context: nil)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 20

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //let time = times[indexPath.item]
    }

    
}


class pastmessageclass: NSObject {
    
    var message: String?
    var name: String?
    var timestamp: Double?
    var uid: String?
    
    init(dictionary: [String:Any]) {
        super.init()
        
        message = dictionary["message"] as? String
        uid = dictionary["uid"] as? String
        name = dictionary["name"] as? String
        timestamp = dictionary["timestamp"] as? Double
    }
}
