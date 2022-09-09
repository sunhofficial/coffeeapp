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
import SwiftSoup
import SwiftyJSON

class BackController : UIViewController, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    var resultList=[LocationService]()
    var currentX : Double = 0.0
    var currentY : Double = 0.0
    lazy var urlString = "\(API.Base_url)?y=\(currentX)&x=\(currentY)&radius=10000&query=빽다방"
    var allmenu : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        crwl()
        let Backcollectionview : UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.sectionInset = UIEdgeInsets(top: 30, left: 10, bottom: 10, right: 10)
            let cv = UICollectionView(frame: view.frame, collectionViewLayout: layout)
            return cv
        }()
        Backcollectionview.delegate = self
        Backcollectionview.dataSource = self
        
        let mapView = NMFMapView(frame : view.frame)
        mapView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height / 2)
        Backcollectionview.frame = CGRect(x:0,y:view.frame.height / 2,width: view.frame.width,height: view.frame.height)
        self.view.addSubview(mapView)
        self.view.addSubview(Backcollectionview)
        Backcollectionview.register(Menucell.self, forCellWithReuseIdentifier: "BackCell")
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
                            marker.iconImage = NMFOverlayImage(name: "Back.jpeg")
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
        let backcoffee = "https://paikdabang.com/menu/menu_coffee/"
        let backdrink = "https://paikdabang.com/menu/menu_drink/"
        let ccino = "https://paikdabang.com/menu/menu_ccino/"
        guard let url = URL(string: backcoffee ) else {return}
        guard let url2 = URL(string: backdrink ) else {return}
        guard let url3 = URL(string: ccino) else {return}

        do{
            //#menu_list > li:nth-child(1) > a > div > div.cont_text_box > div:nth-child(1) > div.cont_text_inner.text_wrap.cont_text_title > div > b
            //#content-wrap > div.sub_section.menu_wrap > div > div.menu_list.clear > ul > li:nth-child(4) > p
            //#content-wrap > div.sub_section.menu_wrap > div > div.menu_list.clear > ul > li:nth-child(1) > p
            let html = try String(contentsOf: url,encoding: .utf8)
            let html2 = try String(contentsOf: url2,encoding: .utf8)
            let html3 = try String(contentsOf: url3,encoding: .utf8)
            
            let doc: Document = try SwiftSoup.parse(html)
            let doc2: Document = try SwiftSoup.parse(html2)
            let doc3: Document = try SwiftSoup.parse(html3)
    
            
            
            let menuname1:Elements = try doc.select("div.menu_list").select("p.menu_tit")
            let menuname2:Elements = try doc2.select("div.menu_list").select("p.menu_tit")
            let menuname3:Elements = try doc3.select("div.menu_list").select("p.menu_tit")
            for i in menuname1.array(){

                allmenu.append(try i.text()) //커피
              
            }
            for i in menuname2.array(){
                print(i)
                allmenu.append(try i.text()) //음료
               
            }
            for i in menuname3.array(){

                allmenu.append(try i.text()) //커피
              
            }

        }catch Exception.Error(let type, let message){
            print("Message : \(message)")
        }catch{
            print("error")
        }
        //#menu_list > li:nth-child(2) > a > div > div.cont_text_box > div:nth-child(1) > div.cont_text_inner.text_wrap.cont_text_title > div > b
       
        
        
    }
   
   
}

extension BackController: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BackCell", for: indexPath) as! Menucell
        cell.textView.text = allmenu[indexPath.row]
        return cell
    }
    
}
