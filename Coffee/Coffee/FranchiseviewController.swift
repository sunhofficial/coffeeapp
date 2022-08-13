//
//  Franchiselist.swift
//  Coffee
//
//  Created by SunHo Lee on 2022/08/02.
//

import Foundation
import UIKit
import SwiftUI

class FranchiseviewController : UIViewController{
    var customCollectionView: UICollectionView?
    var images = ["Back.jpeg","Compose.png","Mega.png","theLiter.png","Starbucks.png","mammoth.png","theVenti.png","Ediya.png","Juicy.png"]
    override func viewDidLoad(){
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = "메인메뉴"
        self.navigationItem.title = "cafe list"
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20,left: 30, bottom: 10, right: 30)
   
        customCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        customCollectionView?.backgroundColor = .white

        customCollectionView?.delegate = self
        customCollectionView?.dataSource = self
        self.view.addSubview(customCollectionView ?? UICollectionView())
        customCollectionView?.register(LogoCell.self, forCellWithReuseIdentifier: "Cell")
        
    }

    
}
extension FranchiseviewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! LogoCell
        cell.Imageview.image = UIImage(named: images[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        let itemsperRow: CGFloat = 3
        let itemsperCol: CGFloat = 3
        let cellwidth = width / itemsperRow
        let cellheight = (height - 110) / itemsperCol
        return CGSize(width: cellwidth, height: cellheight)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let logo = images[indexPath.row]
        switch logo{
        case "Back.jpeg" :
            let BackController = BackController()
            return self.show(BackController, sender: nil) //show = push
        case "Compose.png":
            let ComposeController = ComposeSpotController()
            return self.show(ComposeController, sender: nil)
        case "Mega.png":
            let megacontroller = MegaSpotController()
            return self.show(megacontroller, sender: nil)
        case "theLiter.png":
            let thelitter = TheLitterSpotController()
            return self.show(thelitter,sender: nil)
        case "Starbucks.png":
            let starbuckscontroller = StarbucksViewController()
            self.navigationController?.pushViewController(starbuckscontroller, animated: true)
        case "mammoth.png":
            let mam = MammothSpotController()
            return self.show(mam, sender: nil)
        case "theVenti.png":
            let theventicontroller = VentiSpotController()
            self.show(theventicontroller, sender: nil)
        case "Ediya.png":
            let ed = EdiyaSpotController()
            self.show(ed, sender: nil)
        case "Juicy.png":
            let ju = JuicySpotController()
            self.show(ju, sender: nil)
        default:
            let nextcontroller = UIViewController()
            self.navigationController?.pushViewController(nextcontroller, animated: true)
        }
        
    }
}
struct PreView3: PreviewProvider {
    static var previews: some View {
        FranchiseviewController().toPreview().previewInterfaceOrientation(.portraitUpsideDown)
    }
}

#if DEBUG
extension FranchiseviewController {
    private struct Preview3: UIViewControllerRepresentable {
            let viewController: FranchiseviewController

            func makeUIViewController(context: Context) -> FranchiseviewController {
                return viewController
            }

            func updateUIViewController(_ uiViewController: FranchiseviewController, context: Context) {
            }
        }

        func toPreview() -> some View {
            Preview3(viewController: self)
        }
}
#endif
