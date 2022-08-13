//
//  LogoCell.swift
//  Coffee
//
//  Created by SunHo Lee on 2022/08/03.
//

import UIKit
class LogoCell : UICollectionViewCell {
    override init(frame :CGRect){
        super.init(frame: frame)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("삐용삐용 에러발생")
        
    }
    let Imageview : UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        
        return img
    }()
    func setupView(){
        self.addSubview(Imageview)
        Imageview.translatesAutoresizingMaskIntoConstraints = false
        Imageview.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        Imageview.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        Imageview.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        Imageview.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        
    }
    
}
