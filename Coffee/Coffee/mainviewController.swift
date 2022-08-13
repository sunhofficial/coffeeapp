//
//  mainviewController.swift
//  Coffee
//
//  Created by SunHo Lee on 2022/08/01.
//

import UIKit
import SnapKit
import SwiftUI
class mainviewController : UIViewController{
    var findmenu : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("땡기는 음료 비교", for: .normal)

        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: CGFloat(40))
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.red
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 3
        return button
    }()
    var findcoffeeshop : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("프랜차이즈 비교", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: CGFloat(40))
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.red
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 3
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(findmenu)
        view.addSubview(findcoffeeshop)
        findmenu.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().offset(60)
            $0.centerY.equalToSuperview().offset(20)
        }
        findcoffeeshop.frame.size.height = 100
        findcoffeeshop.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().offset(60)
            $0.bottom.equalTo(findmenu.snp.top).offset(-200)
            
            
        }
 
        findmenu.addTarget(self, action: #selector(movetomenu), for: .touchUpInside)
        findcoffeeshop.addTarget(self, action: #selector(movetoshop), for: .touchUpInside)
    }
    @objc func movetomenu(){
        self.present(ListViewController(), animated: true)
    }
    @objc func movetoshop(){
        navigationController?.pushViewController(FranchiseviewController(), animated: true)
    }
}





struct PreView2: PreviewProvider {
    static var previews: some View {
        mainviewController().toPreview().previewInterfaceOrientation(.portraitUpsideDown)
    }
}

#if DEBUG
extension mainviewController {
    private struct Preview2: UIViewControllerRepresentable {
            let viewController: mainviewController

            func makeUIViewController(context: Context) -> mainviewController {
                return viewController
            }

            func updateUIViewController(_ uiViewController: mainviewController, context: Context) {
            }
        }

        func toPreview() -> some View {
            Preview2(viewController: self)
        }
}
#endif

