//
//  ListViewController.swift
//  Coffee
//
//  Created by SunHo Lee on 2022/07/31.
//
import Alamofire
import UIKit
import SwiftUI
import SwiftSoup
class ListViewController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        crwl()
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
            var allmenu : [String] = []
            let doc: Document = try SwiftSoup.parse(html)
            let doc2: Document = try SwiftSoup.parse(html2)
            let doc3: Document = try SwiftSoup.parse(html3)
            let doc4: Document = try SwiftSoup.parse(html4)
            let doc5: Document = try SwiftSoup.parse(html5)
            let menuname1:Elements = try doc.select("div.menu_list").select("div.txt_bx")
            let menuname2:Elements = try doc2.select("div.menu_list").select("div.txt_bx")
            let menuname3:Elements = try doc3.select("div.menu_list").select("div.txt_bx")
            let menuname4:Elements = try doc4.select("div.menu_list").select("div.txt_bx")
            let menuname5:Elements = try doc5.select("div.menu_list").select("div.txt_bx")
            for i in menuname1.array(){
                let menu :Elements = try i.select("p.tit")
                allmenu.append(try menu.text())
                print(try? menu.text())
            }
            for i in menuname2.array(){
                let menu :Elements = try i.select("p.tit")
                allmenu.append(try menu.text())
                print(try? menu.text())
            }
            for i in menuname3.array(){
                let menu :Elements = try i.select("p.tit")
                allmenu.append(try menu.text())
                print(try? menu.text())
            }
            for i in menuname4.array(){
                let menu :Elements = try i.select("p.tit")
                allmenu.append(try menu.text())
                print(try? menu.text())
            }
            for i in menuname5.array(){
                let menu :Elements = try i.select("p.tit")
                allmenu.append(try menu.text())
                print(try? menu.text())
            }
        }catch Exception.Error(let type, let message){
            print("Message : \(message)")
        }catch{
            print("error")
        }
        //#menu_list > li:nth-child(2) > a > div > div.cont_text_box > div:nth-child(1) > div.cont_text_inner.text_wrap.cont_text_title > div > b
       
        
        
    }

}
extension ListViewController{
    
}
