//
//  HomeMessagesCell.swift
//  BoxSwift
//
//  Created by Christian Grinling on 19/01/2022.
//

import UIKit

class HomeMessagesCell: UICollectionViewCell {
    
    lazy var note: UILabel = {
        let label = UILabel()
        label.layout(colour: .black, size: 16, text: "", bold: true)
        //label.textAlignment = .center
        //label.font = UIFont(name: "Baskerville-Bold", size: 20)
        return label
    }()
    
    lazy var nametext: UILabel = {
        let label = UILabel()
        label.layout(colour: .black, size: 8, text: "", bold: false)
        label.textAlignment = .center
        //label.font = UIFont(name: "Baskerville-Bold", size: 20)
        return label
    }()
    
    let bubbleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var bubbleViewRightAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    var bubbleWidthAnchor: NSLayoutConstraint?
    
    func setupView() {
        addSubview(bubbleView)
        addSubview(note)
        addSubview(nametext)
        
        //constraints bubble view
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        bubbleViewRightAnchor?.isActive = true
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8)
        //bubbleViewLeftAnchor?.isActive = false
        
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        //bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        bubbleView.bottomAnchor.constraint(equalTo: nametext.topAnchor,constant: 0).isActive = true
        
        nametext.anchor(top: nil, paddingTop: 0, bottom: bottomAnchor, paddingBottom: 0, left: bubbleView.leftAnchor, paddingLeft: 0, right: nil, paddingRight: 8, width: 0, height: 0)
        
        note.anchor(top: topAnchor, paddingTop: 0, bottom: nametext.topAnchor, paddingBottom: 0, left: bubbleView.leftAnchor, paddingLeft: 8, right: bubbleView.rightAnchor, paddingRight: 0, width: 0, height: 0)
       // note.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
    
}

