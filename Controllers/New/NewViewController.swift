//
//  NewViewController.swift
//  CoreDataDemo
//
//  Created by Khánh on 30/04/2021.
//

import UIKit
import CoreData
import Foundation

class NewViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    func setupUI(){
        title = "New"
    let doneBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        self.navigationItem.rightBarButtonItem = doneBarButtonItem
    }


    @objc func done() {
        // lấy AppDelegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        // lấy Managed Object Context
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // lấy Entity name
        let entity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)!
        
        // tạo 1 Managed Object --> insert
        let user = User(entity: entity, insertInto: managedContext)
        
        // set giá trị cho Object
        user.name = nameTextField.text
        user.age = Int16(ageTextField.text!) ?? 0
//        user.gender = genderSegmentedControl.selectedSegmentIndex == 0 ? true : false
        
        //save context
        do {
            try managedContext.save()
            self.navigationController?.popViewController(animated: true)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

}
