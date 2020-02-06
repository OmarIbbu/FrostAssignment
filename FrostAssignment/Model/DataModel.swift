//
//  DataModel.swift
//  FrostAssignment
//
//  Created by Marmeto Developer  on 04/02/20.
//  Copyright © 2020 Marmeto Developer . All rights reserved.
//

import Foundation
import CoreData
import UIKit

struct Note {
    var description : String
    var tag : String
    var title : String
    var thumbnail : String
    var time : String
}


class Model {
    
    var Notes = [Note]()
    var searchedNotes = [Note]()
    var sortedNotes = [Note]()
    
    
    func sort(){
     sortedNotes = Notes.sorted(by: { $0.time > $1.time })
    }
    
    func search(text: String) {
        searchedNotes = Notes.filter { $0.title.localizedCaseInsensitiveContains(text)  }

    }
    
    
    func createNote(descrtiption:String, tags: String,thumbnail: String, time: String,  title: String, completion : (_ Success:Bool) -> Void) {
        
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let Notes = NSEntityDescription.entity(forEntityName: "Notes", in: managedContext)
        let Note = NSManagedObject(entity: Notes!, insertInto: managedContext)
        
        Note.setValue(descrtiption, forKey: "descrtiption")
        Note.setValue(tags, forKey: "tags")
        Note.setValue(thumbnail, forKey: "thumbnail")
        Note.setValue(time, forKey: "time")
        Note.setValue(title, forKey: "title")
        
        do
        {
            try managedContext.save()
            completion(true)
        }
        catch let error as NSError
        {
            print("Could not save. \(error), \(error.userInfo)")
            completion(false)
        }
    }
    
    
    func fetchNotes() {
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        var data = [NSManagedObject]()
        
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
        
        do {
            
            let result = try managedContext.fetch(fetchRequest)
            data = result as! [NSManagedObject]
            
            if data.count > 0 {
                
                for index in 0...data.count - 1 {
                    
                    let tags = data[index].value(forKey: "tags") as! String
                    let thumbnail = data[index].value(forKey: "thumbnail") as! String
                    let time = data[index].value(forKey: "time") as! String
                    let title = data[index].value(forKey: "title") as! String
                    let descrtiption = data[index].value(forKey: "descrtiption") as! String
                    
                    
                    let temp = Note(description: descrtiption, tag: tags, title: title, thumbnail: thumbnail, time: time)
                    
                    Notes.append(temp)
                    
                }
            }else {
                print("No Notes Available")
            }
        }
        catch let error as NSError
        {
            print("Could not load. \(error), \(error.userInfo)")
        }
        
    }
    
}

