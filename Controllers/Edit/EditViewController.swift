//
//  EditViewController.swift
//  CoreDataDemo
//
//  Created by Khánh on 30/04/2021.
//

import UIKit

class EditViewController: UIViewController {

    var user: User!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    func setupUI(){
        title = "Edit"
        
        //navigation bar
        let doneBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        self.navigationItem.rightBarButtonItem = doneBarButtonItem
    }
    
    func setupData() {
        if let user = user {
            nameTextField.text = user.name
            ageTextField.text = "\(user.age)"
        }
    }

    @objc func done() {
        // lấy AppDelegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        // lấy Managed Object Context
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // set giá trị cho Object
        user.name = nameTextField.text
        user.age = Int16(ageTextField.text!) ?? 0
        
        //save context
        do {
            try managedContext.save()
            self.navigationController?.popViewController(animated: true)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

}
