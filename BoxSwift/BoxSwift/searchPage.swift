//
//  searchPage.swift
//  BoxSwift
//
//  Created by Christian Grinling on 24/03/2022.
//

import UIKit
import Firebase

class searchPage: UITableViewController, UISearchResultsUpdating {
    
    var ref: DatabaseReference!
    var filteredusers: [userclass]?
    let searchController = UISearchController(searchResultsController: nil)
    var user: String?
    var Unfilteredusers = [userclass]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        self.tableView.register(userCell.self, forCellReuseIdentifier: "usercell")
        tableView.tableHeaderView = searchController.searchBar
        getusers()
    }
    
    func getusers() {
        ref.child("users/").queryOrdered(byChild: "name").observe(DataEventType.value, with: { snapshot in
            //self.Unfilteredusers.removeAll()
            for case let child as DataSnapshot in snapshot.children {
                guard let dict = child.value as? [String:Any] else {
                    print("Error")
                    return
                }
                
                let user = userclass(dictionary: dict)
                if user.uid == Auth.auth().currentUser?.uid {
                    //nothing
                }
                else {
                    self.Unfilteredusers.append(user)
                }
                
                DispatchQueue.main.async {
                    self.filteredusers = self.Unfilteredusers
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filteredusers = Unfilteredusers.filter { user in
                return user.name!.lowercased().contains(searchText.lowercased())
            }
            
        } else {
            filteredusers = Unfilteredusers
        }
    DispatchQueue.main.async {
        self.tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let Unfilteredusers = filteredusers else {
            return 0
        }
        return Unfilteredusers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "usercell") as! userCell
        if let Unfilteredusers = filteredusers {
            let user = Unfilteredusers[indexPath.row]
            cell.textLabel!.text = user.name
        }
        return cell
}
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.showSpinner(onView: self.view)
        guard let uid = Auth.auth().currentUser?.uid else {return}
        searchController.isActive = false
        let user = filteredusers?[indexPath.row]
        self.ref.child("users").child(uid).child("partner-name").setValue(user?.name)
        self.ref.child("users").child(uid).child("partner-uid").setValue(user?.uid)
        self.ref.child("users").child(uid).child("partner-box").setValue(user?.boxcode)
        self.removeSpinner()
        self.dismiss(animated: true, completion: nil)
    }

}


extension String {
    var stringByRemovingWhitespaces: String {
        return components(separatedBy: .whitespaces).joined()
    }
}



class userclass: NSObject {
    
    var boxcode: String?
    var boxname: String?
    var name: String?
    var uid: String?
    var partnername: String?
    var partneruid: String?
    var partnerbox: String?
    
    init(dictionary: [String:Any]) {
        super.init()
        
        boxcode = dictionary["box-code"] as? String
        boxname = dictionary["box-name"] as? String
        name = dictionary["name"] as? String
        uid = dictionary["uid"] as? String
        
        partnername = dictionary["partner-name"] as? String
        partneruid = dictionary["partner-uid"] as? String
        partnerbox = dictionary["partner-box"] as? String
    }
}
