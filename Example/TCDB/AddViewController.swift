//
//  AddViewController.swift
//  TCDB_Example
//
//  Created by 谈超 on 2017/6/22.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var sexSwitch: UISwitch!
    
    @IBAction func saveBtnClicked(_ sender: UIButton) {
        TCDBSQLManager.inSertPerson(name: nameTextField.text ?? "", sex: sexSwitch.isOn, phone: phoneTextField.text ?? "")
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
