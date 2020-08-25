//
//  BookingDetailAddressViewController.swift
//  PODPhotographer
//
//  Created by Apple on 16/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import MapKit
class BookingDetailAddressViewController: UIViewController {

    @IBOutlet var lblAdd:UILabel!
    @IBOutlet var mapView:MKMapView!
    var lat:Double = 0.0;
    var lng:Double = 0.0;
    var add:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        lblAdd.text = add;
        self.SetLocationOnMap()
        lblAdd.sizeToFit()
        // Do any additional setup after loading the view.
    }
    
    func SetLocationOnMap(){
        let annotation = MKPointAnnotation()
        annotation.title = title
        annotation.coordinate = CLLocationCoordinate2DMake(lat, lng)
        
        mapView!.addAnnotation(annotation)
        mapView?.setRegion(MKCoordinateRegion.init(center: CLLocationCoordinate2DMake(lat, lng), span: MKCoordinateSpan.init(latitudeDelta: 0.05, longitudeDelta: 0.05)), animated: true)
    }
    
    @IBAction func btnGetDirection(){
        openTrackerInBrowser(lat: Constant.currLat.description, long: Constant.currLng.description, dlat: self.lat.description, dlong: self.lng.description)
    }


    func openTrackerInBrowser(lat: String, long: String, dlat: String, dlong: String){

        if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=\(lat),\(long)&daddr=\(dlat),\(dlong)&directionsmode=driving") {
            UIApplication.shared.open(urlDestination, options: [:], completionHandler: nil)

        }
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
