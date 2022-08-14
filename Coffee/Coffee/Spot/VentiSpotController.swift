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

class VentiSpotController : UIViewController, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    var resultList=[LocationService]()
    var currentX : Double = 0.0
    var currentY : Double = 0.0
    lazy var urlString = "\(API.Base_url)?y=\(currentX)&x=\(currentY)&radius=10000&query=더벤티"
 
    var allmenu : [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        crwl()
        let venticollectionView : UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.sectionInset = UIEdgeInsets(top: 30, left: 10, bottom: 10, right: 10)
            let cv = UICollectionView(frame: view.frame, collectionViewLayout: layout)
            return cv
        }()
        venticollectionView.delegate = self
        venticollectionView.dataSource = self
        
        let mapView = NMFMapView(frame : view.frame)
        mapView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height / 2)
        venticollectionView.frame = CGRect(x:0,y:view.frame.height / 2,width: view.frame.width,height: view.frame.height)
        self.view.addSubview(mapView)
        self.view.addSubview(venticollectionView)
        venticollectionView.register(Menucell.self, forCellWithReuseIdentifier: "Cell")
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
                            marker.iconImage = NMFOverlayImage(name: "theVenti.png")
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
        let megaurl = "https://www.theventi.co.kr/new/menu/all.html?mode=1"
        let megaurl2 = "https://www.theventi.co.kr/new/menu/all.html?mode=2"
        let megaurl3 = "https://www.theventi.co.kr/new/menu/all.html?mode=3"
        let megaurl4 = "https://www.theventi.co.kr/new/menu/all.html?mode=4"
        let megaurl5 = "https://www.theventi.co.kr/new/menu/all.html?mode=5"
        guard let url = URL(string: megaurl ) else {return}
        guard let url2 = URL(string: megaurl2 ) else {return}
        guard let url3 = URL(string: megaurl3 ) else {return}
        guard let url4 = URL(string: megaurl4 ) else {return}
        guard let url5 = URL(string: megaurl5 ) else {return}
        do{
            //#menu_list > li:nth-child(1) > a > div > div.cont_text_box > div:nth-child(1) > div.cont_text_inner.text_wrap.cont_text_title > div > b
            let html = try String(contentsOf: url,encoding: .utf8)
            let html2 = try String(contentsOf: url2,encoding: .utf8)
            let html3 = try String(contentsOf: url3,encoding: .utf8)
            let html4 = try String(contentsOf: url4,encoding: .utf8)
            let html5 = try String(contentsOf: url5,encoding: .utf8)
            
            let doc: Document = try SwiftSoup.parse(html)
            let doc2: Document = try SwiftSoup.parse(html2)
            let doc3: Document = try SwiftSoup.parse(html3)
            let doc4: Document = try SwiftSoup.parse(html4)
            let doc5: Document = try SwiftSoup.parse(html5)
            let menuimage1:Elements = try doc.select("div.menu_list").select("div.img_bx").select("img")
            let stringimage = try menuimage1.attr("src").description
            let urlimage = URL(string: stringimage)
            print(urlimage  )
            
            
            let menuname1:Elements = try doc.select("div.menu_list").select("div.txt_bx")
            let menuname2:Elements = try doc2.select("div.menu_list").select("div.txt_bx")
            let menuname3:Elements = try doc3.select("div.menu_list").select("div.txt_bx")
            let menuname4:Elements = try doc4.select("div.menu_list").select("div.txt_bx")
            let menuname5:Elements = try doc5.select("div.menu_list").select("div.txt_bx")
            for i in menuname1.array(){
                let menu :Elements = try i.select("p.tit")
                allmenu.append(try menu.text())
              
            }
            for i in menuname2.array(){
                let menu :Elements = try i.select("p.tit")
                allmenu.append(try menu.text())
               
            }
            for i in menuname3.array(){
                let menu :Elements = try i.select("p.tit")
                allmenu.append(try menu.text())
      
            }
            for i in menuname4.array(){
                let menu :Elements = try i.select("p.tit")
                allmenu.append(try menu.text())
          
            }
            for i in menuname5.array(){
                let menu :Elements = try i.select("p.tit")
                allmenu.append(try menu.text())
                
            }
        }catch Exception.Error(let type, let message){
            print("Message : \(message)")
        }catch{
            print("error")
        }
        //#menu_list > li:nth-child(2) > a > div > div.cont_text_box > div:nth-child(1) > div.cont_text_inner.text_wrap.cont_text_title > div > b
       
        
        
    }
   
}

extension VentiSpotController: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Menucell
        cell.textView.text = allmenu[indexPath.row]
        return cell 
    }
    
}
