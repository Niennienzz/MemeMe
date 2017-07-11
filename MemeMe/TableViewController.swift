//
//  TableViewController.swift
//  MemeMe
//
//  Created by Zhehui Zhou on 7/10/17.
//  Copyright © 2017 ZhehuiZhou. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    // Mark: Share Data Model
    
    let memes = (UIApplication.shared.delegate as! AppDelegate).memes
    
    
    // MARK: Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("MEMEMEs : >>>>>> \(memes)")
        return memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeMeListCell")!
        let meme = memes[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = meme.textTop
        cell.detailTextLabel?.text = meme.textBottom
        
        return cell
    }
    
}
