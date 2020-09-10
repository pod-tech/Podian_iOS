//
//  UpdateAppViewController.swift
//  POD
//
//  Created by Apple on 01/09/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class UpdateAppViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnAppStoreClicked(_ sender: Any) {
        if let url = URL(string: "https://apps.apple.com/in/app/podian/id1502690681"){
            
             if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
             } else {
                 UIApplication.shared.openURL(url)
            }
        }
      
    }
   

}
