//
//  NewMessageTableViewController.swift
//  FirebaseChatApp
//
//  Created by kiran on 7/18/18.
//  Copyright © 2018 kiran. All rights reserved.
//
import UIKit
import Firebase

class NewMessageTableViewController: UITableViewController {
    //this is cell identifier
    let cellId = "cellId"
    //user array takes refrences from User.swift where its properties are decleared
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        fetchUser()
    }
    
    // fetch all users from databse to xcode console
    func fetchUser(){
        Database.database().reference().child("users").queryOrderedByKey().observe(DataEventType.childAdded) { (snapshot) in
            if !snapshot.exists(){
                print("cant get value from snapshot")
                return
            }
            //            print(snapshot)
            //            print(snapshot.value!)
            let user = User()
            user.email = (snapshot.value as? NSDictionary)?["email"] as? String ?? ""
            user.name = (snapshot.value as? NSDictionary)?["name"] as? String ?? ""
            self.users.append(user)
            print(user.email as Any)
            print(user.name as Any)
            
            
            //            if  let dictionary = snapshot.value as? [String: AnyObject] {
            //                let user = User()
            //                user.setValuesForKeys(dictionary)
            //                self.users.append(user)
            //                print(user.name!, user.email!)
            //
            DispatchQueue.global().async(execute: {
                print("teste")
                DispatchQueue.main.sync{
                    self.tableView.reloadData()
                    
                }
            })
        }
        
    }
    
    @objc func handleCancel()  {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        //        cell.textLabel?.text = "thsi ssdfasdfa"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
        cell.imageView?.image = UIImage(named: "msg")
        if let profileImageUrl = user.profileImageUrl{
            let url = URL(string: profileImageUrl)
            URLSession.shared.dataTask(with: url!) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                DispatchQueue.main.async {
                    cell.imageView?.image = UIImage(data: data!)
                    
                }
                
            }
        }
        return cell
    }
    
}
class UserCell:UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

