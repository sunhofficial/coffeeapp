//
//  StarbucksViewController.swift
//  Coffee
//
//  Created by SunHo Lee on 2022/08/06.
//
import CoreLocation
import UIKit
import SnapKit
import NMapsMap //카카오 api에러로 네이버로 넘어갑니다~
import Alamofire
import SwiftyJSON

class ComposeSpotController : UIViewController, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    var resultList=[LocationService]()
    var currentX : Double = 0.0
    var currentY : Double = 0.0
    lazy var urlString = "\(API.Base_url)?y=\(currentX)&x=\(currentY)&radius=10000&query=컴포즈커피"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let mapView = NMFMapView(frame : view.frame)
      
        self.view.addSubview(mapView)
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
            let locationovelay = mapView.locationOverlay
            locationovelay.icon = NMFOverlayImage(name : "location_overlay_icon")
            currentX = locationManager.location?.coordinate.latitude ?? 0
            currentY = locationManager.location?.coordinate.longitude ?? 0
            locationovelay.location = NMGLatLng(lat: currentX, lng: currentY)
            locationovelay.heading = 90
            let marker = NMFMarker()
            marker.position = NMGLatLng(lat: currentX, lng: currentY)
            marker.mapView = mapView
            marker.captionText = "현위치"
            locationovelay.mapView = mapView
            
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: currentX , lng: currentY))
            cameraUpdate.animation = .easeIn
            mapView.moveCamera(cameraUpdate)
            
            
            AF.request(URL(string:urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!, method: .get, encoding: JSONEncoding.default,headers: API.headers).responseDecodable(of: Data.self) {
                response in
                switch response.result{
                case .success(let res):
                        guard let data = res.documents else{return}
                        let dataNum = data.count as Int
                        for i in 0...dataNum-1{
                            let marker = NMFMarker()
                            let doublelat = Double(data[i].y)
                            let doublelng = Double(data[i].x)
                            let infoWindow = NMFInfoWindow()
                            let datasource = NMFInfoWindowDefaultTextSource.data()
                            let handler = {
                                 (overlay: NMFOverlay) -> Bool in
                                if let marker = overlay as? NMFMarker {
                                    if marker.infoWindow == nil{
                                        infoWindow.open(with: marker)
                                    }else{
                                        infoWindow.close()
                                    }
                                }
                                return true
                            };

                            datasource.title = data[i].address_name
                            infoWindow.dataSource = datasource
                            marker.position = NMGLatLng(lat: doublelat ?? 0, lng: doublelng ?? 0)
                            marker.iconImage = NMFOverlayImage(name: "Compose.png")
                            marker.width = 30
                            marker.height = 40
                            marker.anchor = CGPoint(x:1,y:1)
                            marker.captionText = data[i].place_name
                            marker.captionColor = UIColor.black
                            marker.captionTextSize = 14
                            marker.captionAligns = [NMFAlignType.top]
                            marker.touchHandler = handler
                            infoWindow.open(with: marker)
                            marker.mapView = mapView
                        }
                
                case .failure(let error):
                    print(error)
                    
                }
                
            }
        }else{
            print("위치 Off")
        }
        
            
      
    }
   
}

