//
//  YourAvailabilityTableViewCell.swift
//  PODPhotographer
//
//  Created by Apple on 15/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Foundation

class YourAvailabilityTableViewCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource {
    @IBOutlet var timeCollection:UICollectionView?
    @IBOutlet var heightConstain:NSLayoutConstraint!
    @IBOutlet var lblDate:UILabel!
    var listTime:[String] = [String]()
    fileprivate let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.5, bottom: 0.0, right: 1)
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        let screenWidth = timeCollection!.frame.size.width
        let paddingSpace = sectionInsets.left * 4
        let availableWidth = screenWidth - paddingSpace
        let widthPerItem  = availableWidth/3
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: widthPerItem, height: 30)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 4
        timeCollection!.collectionViewLayout = layout
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func SetData(dic:[String:AnyObject]){
        self.lblDate.text = dic["Date"] as? String;
        let arrtime = ["00:00","00:30","1:00","1:30","2:00","2:30","3:00","3:30","4:00","4:30","5:00","5:30","6:00","6:30","7:00","7:30","8:00","8:30","9:00","9:30","10:00","10:30","11:00","11:30","12:00","12:30","13:00","13:30","14:00","14:30","15:00","15:30","16:00","16:30","17:00","17:30","18:00","18:30","19:00","19:30","20:00","20:30","21:00","21:30","22:00","22:30","23:00","23:30"]
        listTime.removeAll()
        for key in arrtime{
            if((dic[key] as! String) != "0"){
                listTime.append(key as! String)
            }
        }
     
        timeCollection?.reloadData()
        let rows =  round((Float(listTime.count) / Float(3)))
        let height = (rows * Float((35)))
        print(height)
        if(height>50){
             heightConstain.constant = CGFloat(height);
        }
        else{
             heightConstain.constant = CGFloat(60);
        }
       
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listTime.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YourAvailabilityCollectionViewCell", for: indexPath as IndexPath) as! YourAvailabilityCollectionViewCell
        cell.SetData(time: listTime[indexPath.row]);
        return cell
    }
}
extension CGRect {
    func scaled(to size: CGSize) -> CGRect {
        return CGRect(
            x: self.origin.x,
            y: self.origin.y,
            width: self.size.width,
            height:size.height
        )
    }
}
