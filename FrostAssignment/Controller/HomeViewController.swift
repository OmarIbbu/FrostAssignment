//
//  HomeViewController.swift
//  FrostAssignment
//
//  Created by Marmeto Developer  on 04/02/20.
//  Copyright © 2020 Marmeto Developer . All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController,UISearchBarDelegate, UISearchDisplayDelegate  {
    
    let model = SingletonManager.model
    
    var managedObject = [NSManagedObject]()
    
    var isfiltered = false
    
    static var value = "Normal"
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        addButton.layer.masksToBounds = true
        addButton.layer.cornerRadius = addButton.frame.width/2
        
        NotificationCenter.default.addObserver(self, selector: #selector(Sort), name:NSNotification.Name(rawValue: "sort"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(SortClear), name:NSNotification.Name(rawValue: "sortclear"), object: nil)
        
       self.hideKeyboardWhenTappedAround()

     
    }
    
   
    @objc func Sort() {
        HomeViewController.value = "Sort"
        model.sort()
        tableView.reloadData()
    }
    
    @objc func SortClear() {
        HomeViewController.value = "Normal"
        tableView.reloadData()
    }
    
    @IBAction func filterBtnTapped(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let Controller = storyboard.instantiateViewController(withIdentifier: "FilterViewController") as! FilterViewController
        
        
        Controller.title = "Filter"
        self.navigationController? .pushViewController(Controller, animated: true)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"Back", style:.plain, target:nil, action:nil)
    }
    
    /* To clear the cart
    
    func clearCartItems() {
        
        
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        
        do
        {
            try managedContext.execute(request)
            try managedContext.save()
        }
        catch let error as NSError
        {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
 
 
 */
    
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let Controller = storyboard.instantiateViewController(withIdentifier: "CreateNotesViewController") as! CreateNotesViewController
        
        Controller.modalPresentationStyle = .fullScreen
        self.present(Controller, animated: true, completion: nil)
        
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        let isFiltered = UserDefaults.standard.bool(forKey: "Filter")
        
        if isFiltered {
            
            self.navigationItem.rightBarButtonItem?.badgeBGColor = .red
            self.navigationItem.rightBarButtonItem?.badgeValue = "1"
            self.navigationItem.rightBarButtonItem?.badge.isHidden = false
            
        }else {
            
            self.navigationItem.rightBarButtonItem?.badge.isHidden = true
            
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        model.Notes.removeAll()
        model.fetchNotes()
        tableView.reloadData()
    }
    
}


extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        switch HomeViewController.value {
        case "Normal":
            return model.Notes.count
            
        case "Search":
            return model.searchedNotes.count
            
        case "Sort":
            return model.sortedNotes.count
            
        default:
            break
        }
        
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch HomeViewController.value {
        case "Normal":
            let data = model.Notes[indexPath.row]
            if data.thumbnail == "Nil" {
            let cell =  populateCellWithThumbnail(note: data)
            return cell
            }else{
            let cell =  populateCellWithoutThumbnail(note: data)
            return cell
            }
            
            
        case "Search" :
            let data = model.searchedNotes[indexPath.row]
            if data.thumbnail == "Nil" {
            let cell =  populateCellWithThumbnail(note: data)
            return cell
            }else{
            let cell =  populateCellWithoutThumbnail(note: data)
            return cell
                
            }
            
            
        case "Sort" :
            let data = model.sortedNotes[indexPath.row]
            if data.thumbnail == "Nil" {
            let cell =  populateCellWithThumbnail(note: data)
            return cell
            }else{
            let cell =  populateCellWithoutThumbnail(note: data)
            return cell
            }
            
        default:
        break
        }
        
        
        let cell = Bundle.main.loadNibNamed("CustomTableCellView2", owner: self, options: nil)?.first as! CustomTableViewCell2
        
        return cell
        
    }
    
    
    func populateCellWithThumbnail( note : Note) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("CustomTableCellView1", owner: self, options: nil)?.first as! CustomTableViewCell1
        
        cell.notes.text = note.description
        cell.title.text = note.title
        cell.tags.text = note.tag
        cell.time.text = compareDate.compareDate(date: note.time )
        
        return cell
        
        
    }
    
    func populateCellWithoutThumbnail(note : Note)  -> UITableViewCell{
        
        let cell = Bundle.main.loadNibNamed("CustomTableCellView2", owner: self, options: nil)?.first as! CustomTableViewCell2
        
        cell.notes.text = note.description
        cell.title.text = note.title
        cell.tags.text = note.tag
        cell.time.text = compareDate.compareDate(date: note.time )
        if let decodedData = Data(base64Encoded: note.thumbnail, options: .ignoreUnknownCharacters) {
            let imagev = UIImage(data: decodedData)
            cell.thumbnail.image = imagev
        }
        
        return cell
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let data = model.Notes[indexPath.row]
        
        if data.thumbnail == "Nil" {
            return 150
        }
        
        return 190
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            
            model.search(text: searchText)
            HomeViewController.value = "Search"
            self.tableView.reloadData()
            
            /*    Can also be done using core data
             var predicate: NSPredicate = NSPredicate()
             predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText)
             
             */
            
        }else {
            HomeViewController.value = "Normal"
            self.tableView.reloadData()
        }
        
    }
    
}

extension HomeViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
