//
//  FilterViewController.swift
//  FrostAssignment
//
//  Created by Marmeto Developer  on 05/02/20.
//  Copyright © 2020 Marmeto Developer . All rights reserved.
//

import UIKit
import CoreData

class FilterViewController: UIViewController {
    
    @IBOutlet weak var checkMark: UIImageView!
    
    let model = SingletonManager.model
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addRightButtonItem()
        
        let isFiltered = UserDefaults.standard.bool(forKey: "Filter")
        
        
        if isFiltered  {
            checkMark.isHidden = false
        }else {
            checkMark.isHidden = true
            
        }
    }
    
    @IBAction func filterBtnTapped(_ sender: Any) {
        
        let isFiltered = UserDefaults.standard.bool(forKey: "Filter")
        
        
        if isFiltered  {
            checkMark.isHidden = true
            UserDefaults.standard.set(false, forKey: "Filter")
        }else {
            checkMark.isHidden = false
            NotificationCenter.default.post(name: Notification.Name("sortclear"), object: nil)
            UserDefaults.standard.set(true, forKey: "Filter")
            
        }
    }
    
    @IBAction func applyBtnTapped(_ sender: Any) {
        
        NotificationCenter.default.post(name: Notification.Name("sort"), object: nil)
        
        for viewcontroller in self.navigationController!.viewControllers as Array {
            if viewcontroller.isKind(of:HomeViewController.self) {
                self.navigationController?.popToViewController(viewcontroller , animated: true)
                
            }
        }
    }
    
}

extension FilterViewController {
    
    
    func addRightButtonItem() {
        
        let customBarItem = UIBarButtonItem(title: "Clear all", style: .plain ,target: self, action: #selector(barButtonMethod(_:)))
        
        
        self.navigationItem.rightBarButtonItem = customBarItem
        
        
    }
    
    @objc func barButtonMethod(_ sender: UIBarButtonItem) {
        
        checkMark.isHidden = true
        NotificationCenter.default.post(name: Notification.Name("sortclear"), object: nil)
        
        UserDefaults.standard.set(false, forKey: "Filter")
        
        
    }
    
}
