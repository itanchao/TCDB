//
//  EditViewController.swift
//  TCDB_Example
//
//  Created by 谈超 on 2017/6/22.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var sexSwitch: UISwitch!
    
    @IBOutlet weak var phoneTextField: UITextField!
    var person :Person?
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(segue)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.text = person?.name
        nameTextField.text = person?.name
        sexSwitch.isOn = person?.sex != false
        phoneTextField.text = person?.phone
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveBtnClick(_ sender: Any) {
        TCDBSQLManager.updatePerson(id: person!.id, name: nameTextField.text, sex: sexSwitch.isOn, phone: phoneTextField.text)
        navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
