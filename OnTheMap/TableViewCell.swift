//
//  TableViewCell.swift
//  OnTheMap
//
//  Created by Abdulkrum Alatubu on 22/11/1441 AH.
//  Copyright © 1441 AbdulkarimAlotaibi. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

        
        @IBOutlet weak var fullName: UILabel!
        @IBOutlet weak var url: UILabel!
    
        var Info: StudentInformation? {
            didSet{
                if let firstName = Info?.firstName , let lastName = Info?.lastName{
                     fullName.text = firstName + " " + lastName
                }
                
                if let URL = Info?.mediaURL{
                    url.text = URL
                }
               
                
            }
        }
        
        
        override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
        }

        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
          
            // Configure the view for the selected state
        }

    }
