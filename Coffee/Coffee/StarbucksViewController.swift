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

class StarbucksViewController : UIViewController, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    var resultList=[LocationService]()
    let keyword = "스타벅스"
    var currentX : Double = 0.0
    var currentY : Double = 0.0
    let headers: HTTPHeaders = [
        "Authorization" : "KakaoAK 9234f0fa961e47e59f0aa090d6d550bc"
        ]
    let queryParam: [String: Any] = [
        "query": "스타벅스",
        ]
    lazy var urlString = "\(API.Base_url)?y=\(currentX)&x=\(currentY)&radius=10000&query=starbucks"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let mapView = NMFMapView(frame : view.frame)
        self.view.addSubview(mapView)
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
            
            currentX = locationManager.location?.coordinate.latitude ?? 0
            currentY = locationManager.location?.coordinate.longitude ?? 0
           
            print("x",currentX,"y",currentY)
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: currentX , lng: currentY))
            cameraUpdate.animation = .easeIn
            mapView.moveCamera(cameraUpdate)
            
            
            AF.request(urlString, method: .get, encoding: JSONEncoding.default,headers: API.headers).responseDecodable(of: Data.self) {
                response in
                switch response.result{
                case .success(let res):
                    
                    do{

                        guard let data = res.documents else{return}
                        print(data)
                        let dataNum = data.count as Int
                        print(type(of:dataNum))
                        print(dataNum)
                      
                        for i in 0...dataNum-1{
                            let marker = NMFMarker()
                            let doublelat = Double(data[i].y)
                            let doublelng = Double(data[i].x)
                            let infoWindow = NMFInfoWindow()
                            let datasource = NMFInfoWindowDefaultTextSource.data()
//                            func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
//                                infoWindow.close()
//                            }
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
                            marker.iconImage = NMFOverlayImage(name: "Starbucks.png")
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

                    }
                    catch{
                        print(error)
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
extension String{
    func encodeUrl() -> String?
    {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
    func decodeUrl() -> String?
    {
        return self.removingPercentEncoding
    }
}
