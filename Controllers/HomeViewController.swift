//
//  HomeViewController.swift
//  CoreDataDemo
//
//  Created by Khánh on 30/04/2021.
//

import UIKit
import CoreData
import Foundation

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    var fetchedResultsController: NSFetchedResultsController<User>!

    
    @IBOutlet weak var tableview: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fetchedResultsController.fetchedObjects!.count
    }
    		
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeCell
        
        let user = fetchedResultsController.object(at: indexPath)
        
        cell.nameLabel.text = user.name
        cell.ageLabel.text = "\(user.age)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = EditViewController()
//
//        //lấy đối tượng và gán
//        vc.user = fetchedResultsController.object(at: indexPath)
//
//        self.navigationController?.pushViewController(vc, animated: true)
        
        // lấy AppDelegate
           guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
           
           // lấy Managed Object Context
           let managedContext = appDelegate.persistentContainer.viewContext
           
           // lấy item ra để xoá
           let user = fetchedResultsController.object(at: indexPath)
           
           // delete
           managedContext.delete(user)
           
           //save context
           do {
               try managedContext.save()
           } catch let error as NSError {
               print("Could not save. \(error), \(error.userInfo)")
           }
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // lấy AppDelegate
//            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//
//            // lấy Managed Object Context
//            let managedContext = appDelegate.persistentContainer.viewContext
//
//            // lấy item ra để xoá
//            let user = fetchedResultsController.object(at: indexPath)
//
//            // delete
//            managedContext.delete(user)
//
//            //save context
//            do {
//                try managedContext.save()
//            } catch let error as NSError {
//                print("Could not save. \(error), \(error.userInfo)")
//            }
//        }
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
//        save(name: "Tí", age: 10, gender: true)
        initializeFetchedResultsController()
    }
    
    func setupUI(){
        tableview.delegate = self
        tableview.dataSource = self
        
        let nib = UINib(nibName: "HomeCell", bundle: .main)
        tableview.register(nib, forCellReuseIdentifier: "cell")
        
        //navigation bar
        let addNewBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(gotoAddNew))
        self.navigationItem.rightBarButtonItem = addNewBarButtonItem
        
        let deleteBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleleAll))
        self.navigationItem.leftBarButtonItem = deleteBarButtonItem
    }
    
    @objc func gotoAddNew(){
        let vc = NewViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func deleleAll(){
        let alert = UIAlertController(title: "Confirm", message: "Do you want to delete all item?", preferredStyle: .alert)
         
        let saveAction = UIAlertAction(title: "OK", style: .default) { (alert) in
            print("DELETE ALL")
            
            // lấy AppDelegate
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            
            // lấy Managed Object Context
            let managedContext = appDelegate.persistentContainer.viewContext
            
            // Create Fetch Request
            let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
            
            // Initialize Batch Delete Request
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
            
            do {
                // execute delete
                try managedContext.execute(deleteRequest)
                
                // save
                try managedContext.save()
                
                // Perform Fetch
                try self.fetchedResultsController.performFetch()
                
                // Reload Table View
                self.tableview.reloadData()
                
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            
        }
         
         let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
         
         alert.addAction(saveAction)
         alert.addAction(cancelAction)
         
         present(alert, animated: true)
    }
    

    //init fetch result
    func initializeFetchedResultsController() {
        
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        // lấy AppDelegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        // lấy Managed Object Context
        let managedContext = appDelegate.persistentContainer.viewContext
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
    func save(name: String, age: Int, gender: Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)!
        
        let user = NSManagedObject(entity: entity, insertInto: managedContext)
        
        user.setValue(name, forKeyPath: "name")
        user.setValue(age, forKeyPath: "age")
        user.setValue(gender, forKeyPath: "gender")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            print("insert")
            if let indexPath = newIndexPath {
                tableview.insertRows(at: [indexPath], with: .fade)
            }
            break;
        case .delete:
            print("delete")
            if let indexPath = indexPath {
                tableview.deleteRows(at: [indexPath], with: .fade)
            }
            break;
        case .update:
            print("update")
            tableview.reloadRows(at: [indexPath!], with: .automatic)
            break;
        default:
            print("default")
        }
    }
}
