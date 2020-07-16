//
//  tableViewController.swift
//  OnTheMap
//
//  Created by Abdulkrum Alatubu on 22/11/1441 AH.
//  Copyright © 1441 AbdulkarimAlotaibi. All rights reserved.
//

import UIKit

class tableViewController: locationDataViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override var locationsData: LocationsData? {
          didSet{
            tableView.reloadData()
          }
      }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

}

extension tableViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationsData?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let viewList:TableViewCell = tableView.dequeueReusableCell(withIdentifier: "table", for: indexPath) as! TableViewCell
        viewList.Info = locationsData?.results[indexPath.row]
        return viewList
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let url = locationsData?.results[indexPath.row].mediaURL {
            let url = URL(string: url)
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)

        }
       
        
    }
    
    
}
