//
//  ViewController.swift
//  TCDB
//
//  Created by itanchao on 06/22/2017.
//  Copyright (c) 2017 itanchao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    weak var editVC: EditViewController?
    var currentPerson : Person?{
        didSet{
            editVC?.person = currentPerson
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        requestData(str: "")
    }
    var persons = [Person](){
        didSet{
            tableView.reloadData()
        }
    }
    
    func requestData(str: String ) {
        TCDBSQLManager.selectPerson(str: nil) { [weak self](array) in
            self?.persons =  array.map({ (dic) in
                print(dic)
                return Person(dic: dic)
            })
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestData(str: "")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "edite" {
            editVC = segue.destination as? EditViewController
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension ViewController:UITableViewDelegate,UITableViewDataSource{
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let view = tableView.dequeueReusableCell(withIdentifier: "UITableView") as! TableViewCell
        view.person = persons[indexPath.row]
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentPerson = persons[indexPath.row]
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let person = persons[indexPath.row]
        TCDBSQLManager.deletePerson(person.id)
        requestData(str: "")
    }
}

