//
//  LocationService.swift
//  Coffee
//
//  Created by SunHo Lee on 2022/08/06.
//

import UIKit
import Alamofire
struct Data : Codable{
    var documents : [LocationService]?
}
struct LocationService : Codable{
    var place_name :String
    var address_name:String
    var x : String
    var y: String
 
    
    
}
enum API{
    static let headers: HTTPHeaders = [
        "Authorization" : "KakaoAK 9234f0fa961e47e59f0aa090d6d550bc"
        ]
    static let Base_url : String = "https://dapi.kakao.com/v2/local/search/keyword.json"
}
    
