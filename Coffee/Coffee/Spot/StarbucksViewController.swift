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
import SwiftSoup

class StarbucksViewController : UIViewController, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    var resultList=[LocationService]()
    var currentX : Double = 0.0
    var currentY : Double = 0.0
    lazy var urlString = "\(API.Base_url)?y=\(currentX)&x=\(currentY)&radius=10000&query=starbucks"
    var allmenu : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        crwl()
        let starbuckscollectionView : UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.sectionInset = UIEdgeInsets(top: 30, left: 10, bottom: 10, right: 10)
            let cv = UICollectionView(frame: view.frame, collectionViewLayout: layout)
            return cv
        }()
        starbuckscollectionView.delegate = self
        starbuckscollectionView.dataSource = self
        
        let mapView = NMFMapView(frame : view.frame)
        mapView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height / 2)
        starbuckscollectionView.frame = CGRect(x:0,y:view.frame.height / 2,width: view.frame.width,height: view.frame.height)
        self.view.addSubview(mapView)
        self.view.addSubview(starbuckscollectionView)
        starbuckscollectionView.register(Menucell.self, forCellWithReuseIdentifier: "starCell")
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
            
            
            AF.request(urlString, method: .get, encoding: JSONEncoding.default,headers: API.headers).responseDecodable(of: Data.self) {
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
                
                case .failure(let error):
                    print(error)
                    
                }
                
            }
        }else{
            print("위치 Off")
        }
        
            
      
    }
    func crwl(){
        let megaurl = "https://www.starbucks.co.kr/menu/drink_list.do"
        guard let url = URL(string: megaurl ) else {return}
        do{
            //#menu_list > li:nth-child(1) > a > div > div.cont_text_box > div:nth-child(1) > div.cont_text_inner.text_wrap.cont_text_title > div > b
            //#container > div.content > div.product_result_wrap.product_result_wrap01 > div > dl > dd:nth-child(2) > div.product_list > dl > dd:nth-child(2) > ul > li:nth-child(1) > dl > dd
            //#container > div.content > div.product_result_wrap.product_result_wrap01 > div > dl > dd:nth-child(2) > div.product_list > dl > dd:nth-child(8) > ul > li:nth-child(1) > dl > dd
            
            let html = try String(contentsOf: url,encoding: .utf8)
            
            let doc: Document = try SwiftSoup.parse(html) //문제가 메뉴들이 스타벅스에서 자바스크립트로 숨겨져있어서 가져오지를 못함 ㅠㅠ
            let menulist:Elements = try doc.select("div.product_list").select("li.menuDataSet")
            for i in menulist.array(){
                let menu: Elements = try i.select("dd")
                print(try menu.text())
            }
            
        }catch Exception.Error(let type, let message){
            print("Message : \(message)")
        }catch{
            print("error")
        }
        //#menu_list > li:nth-child(2) > a > div > div.cont_text_box > div:nth-child(1) > div.cont_text_inner.text_wrap.cont_text_title > div > b
       
        
        
    }
}

extension StarbucksViewController: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allmenu.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        let itemsperRow: CGFloat = 6
        let itemsperCol: CGFloat = 5
        let cellwidth = width / itemsperRow
        let cellheight = (height - 110) / itemsperCol
        return CGSize(width: cellwidth, height: cellheight)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "starCell", for: indexPath) as! Menucell
        cell.textView.text = allmenu[indexPath.row]
        return cell
    }
    
}
