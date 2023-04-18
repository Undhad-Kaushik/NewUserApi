//
//  ViewController.swift
//  NewUserApi
//
//  Created by undhad kaushik on 12/02/23.
//



import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var userTableView: UITableView!
    
    var arrUser: [Dictionary<String, AnyObject>] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        getUser()
        nibRegister()
    }
    
    private func nibRegister(){
        let nibFile: UINib = UINib(nibName: "UserTableViewCell", bundle: nil)
        userTableView.register(nibFile, forCellReuseIdentifier: "cell")
        userTableView.separatorStyle = .none
    }
    
    private func getUser(){
        guard let url = URL(string: "https://gorest.co.in/public/v2/todos") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.httpBody = nil
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request){ data, response, error in
            guard let aipdata = data else { return }
            do{
                let json = try JSONSerialization.jsonObject(with: aipdata) as! [Dictionary<String, AnyObject>]
                self.arrUser = json
                DispatchQueue.main.async {
                    self.userTableView.reloadData()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        .resume()
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UserTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UserTableViewCell
        
        let rowDictionary = arrUser[indexPath.row]
        cell.idLabel.text = "\(rowDictionary["id"]as! Double)"
        cell.userIdLabel.text = "\(rowDictionary["userId"]as? Int)"
        cell.titleLabel.text = "\(rowDictionary["title"]as! String)"
        cell.dueOnLabel.text = "\(rowDictionary["dueOn"]as? String)"
        cell.statusLabel.text = "\(rowDictionary["status"]as! String)"
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 0.5
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 16
    }}



class User{
    var id: Double
    var userId: Int
    var title: String
    var dueOn: String
    var status: String
    
    init( userDetails: Dictionary<String, AnyObject>) {
        id = userDetails["id"] as! Double
        userId = userDetails["user_id"] as! Int
        title = userDetails["title"] as! String
        dueOn = userDetails["due_on"] as! String
        status = userDetails["status"] as! String
    }
}
