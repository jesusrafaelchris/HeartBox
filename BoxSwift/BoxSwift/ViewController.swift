//
//  ViewController.swift
//  BoxSwift
//
//  Created by Christian Grinling on 19/01/2022.
//

import UIKit

class ViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let searchbutton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchbutton))
        let addboxbutton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addboxbutton))
        self.navigationItem.rightBarButtonItem  = searchbutton
        self.navigationItem.leftBarButtonItem  = addboxbutton
        navigationController?.title = "Christian"

    }
    
    @objc func searchbutton() {
        
    }
    
    @objc func addboxbutton() {
        
    }


}

