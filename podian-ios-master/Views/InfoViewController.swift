//
//  InfoViewController.swift
//  PODPhotographer
//
//  Created by Apple on 08/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class InfoViewController: BaseViewController {

    @IBOutlet var lblTitle:UILabel!
    @IBOutlet var txtView:UITextView!
    public var headerTitle:String?
    public var slug:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        lblTitle.text = headerTitle;
        InfoController.GetInfo(vc: self, txt: txtView, Slug: slug!)
        // Do any additional setup after loading the view.
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
