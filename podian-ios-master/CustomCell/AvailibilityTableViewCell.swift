//
//  AvailibilityTableViewCell.swift
//  PODPhotographer
//
//  Created by Apple on 15/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class AvailibilityTableViewCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource  {
    @IBOutlet var timeCollection:UICollectionView?
    @IBOutlet var btnSelectAll:UIButton!
    @IBOutlet var lblTitle:UILabel!
    @IBOutlet var heightConstain:NSLayoutConstraint!
    var arrTime:[[String:AnyObject]] =  [[String:AnyObject]]()
    var timeObj:[String:AnyObject] =  [String:AnyObject]()
    var indexPath:IndexPath?
    fileprivate let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.5, bottom: 0.0, right: 1)
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        let screenWidth = timeCollection!.frame.size.width
        let paddingSpace = sectionInsets.left * 4
        let availableWidth = screenWidth - paddingSpace
        let widthPerItem  = availableWidth/3
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: widthPerItem, height: 45)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 4
        timeCollection!.collectionViewLayout = layout
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func btnSelectAll_Click(sender:UIButton){
        sender.isSelected = !sender.isSelected
        self.arrTime = self.arrTime.map{ originalDict in
            var newDict = originalDict
            newDict["status"] = sender.isSelected as AnyObject
            return newDict
        }
        timeObj["Times"] = self.arrTime as AnyObject;
        timeObj["SelectAll"] = sender.isSelected as AnyObject; AvailabilityController.availabilityList?[indexPath!.row] = timeObj
        timeCollection?.reloadData()
      
    }
    
    public func SetData(dic:[String:AnyObject],indexPath:IndexPath){
        self.timeObj = dic;
        self.indexPath = indexPath;
        
        self.btnSelectAll.isSelected = (dic["SelectAll"] as! Bool)
        self.lblTitle.text = (dic["title"] as! String)
        self.arrTime = (dic["Times"] as! [[String:AnyObject]])
        timeCollection?.reloadData()

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrTime.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvailabilityCollectionViewCell", for: indexPath as IndexPath) as! AvailabilityCollectionViewCell
        cell.SetData(dic: arrTime[indexPath.row],indexPath: indexPath,parentIndex: self.indexPath!)
        return cell
    }

}
