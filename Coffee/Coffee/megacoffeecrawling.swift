//
//  megacoffeecrawling.swift
//  Coffee
//
//  Created by SunHo Lee on 2022/08/01.
//

import UIKit
import SwiftSoup
class megacoffeecrawling : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
func crwl(){
    let megaurl = "https://www.mega-mgccoffee.com/menu/?menu_category1=1&menu_category2=1"
    guard let url = URL(string: megaurl ) else {return}
    do{
        let html = try String(contentsOf: url,encoding: .utf8)
        let doc: Document = try SwiftSoup.parse(html)
        let menuname:Elements = try doc.select("div#menu_list")
        for i in menuname.array(){
            print(i)
        }
    }catch Exception.Error(let type, let message){
        print("Message : \(message)")
    }catch{
        print("error")
    }
    //#menu_list > li:nth-child(2) > a > div > div.cont_text_box > div:nth-child(1) > div.cont_text_inner.text_wrap.cont_text_title > div > b
   
    
    
}
