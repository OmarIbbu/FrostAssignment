//
//  CompareDate.swift
//  FrostAssignment
//
//  Created by Marmeto Developer  on 06/02/20.
//  Copyright © 2020 Marmeto Developer . All rights reserved.
//

import Foundation
import SystemConfiguration

public class compareDate {


   class func compareDate(date:String)->String{
          
          let dateFormatter = DateFormatter()
          
          var dateS = date.components(separatedBy: ".")
          dateS.removeLast()
          dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
          
          let datee = dateFormatter.date(from: date)
          let calan = Calendar(identifier: .gregorian)
          let myDate = Date()
          let componets:Set<Calendar.Component> = [.year,.month,.day,.hour,.minute,.second]
          let finalSystemDate = calan.dateComponents(componets, from: myDate)
          let notifyCompDate = Calendar.current.dateComponents(componets, from: datee!)
          let differenceDate = Calendar.current.dateComponents(componets, from: notifyCompDate, to: finalSystemDate)
          var returnDate:String = String()
          
          if ((differenceDate.hour == 0)&&((differenceDate.minute! > 0)&&(differenceDate.day! == 0))){
              
              returnDate = String(describing: differenceDate.minute!) + "  minutes ago"
            
          }
          
          if (differenceDate.hour! > 0)&&(differenceDate.day == 0){
           
          returnDate = String(describing: differenceDate.hour!) + "  hours ago"
              
          }
          
          if ((differenceDate.day!>0)&&(differenceDate.day!<6)){
         
          returnDate = String(describing: differenceDate.day!) + "  day ago"
              
          }
          if (differenceDate.day!>5){
              
              let lastDate:[String]! = String(describing: datee).components(separatedBy: " ")
              
              let time = lastDate.first!.components(separatedBy: "(")
              let retunStr:String! = time.last!
              returnDate = retunStr
          }
          
          
          return returnDate
          
      }
      
    
}
