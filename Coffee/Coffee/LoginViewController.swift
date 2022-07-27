//
//  LoginViewController.swift
//  Coffee
//
//  Created by SunHo Lee on 2022/07/26.
//
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import UIKit
import SwiftUI
import SnapKit
class LoginViewController : UIViewController {
    let kakaoLoginButton = UIButton(type: .custom)
    let testex = UILabel()
    let coffeeImage : UIImageView =  {
        let imageview = UIImageView(image: UIImage(named: "coffee"))
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.contentMode = .scaleAspectFit
        return imageview
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        self.view.addSubview(kakaoLoginButton)
        self.view.addSubview(coffeeImage)
        setkakaologinbtn(kakaoLoginButton)
        kakaoLoginButton.addTarget(self, action: #selector(kakaologintap), for: .touchUpInside)
        self.view.addSubview(testex)
        
        
    }
    func setkakaologinbtn(_ btn : UIButton){
        self.view.addSubview(btn)
        btn.setImage(UIImage(named: "kakaologin"), for: .normal)
    }
  
    @objc func kakaologintap(){
        UserApi.shared.loginWithKakaoAccount{
            (OAuthToken, Error ) in if let Error = Error {
                print(Error)
            }
            else {
                print("login sucess")
                _ = OAuthToken
            }
        }
    }
}
struct PreView: PreviewProvider {
    static var previews: some View {
        LoginViewController().toPreview()
    }
}
#if DEBUG
extension LoginViewController {
    private struct Preview: UIViewControllerRepresentable {
            let viewController: LoginViewController

            func makeUIViewController(context: Context) -> LoginViewController {
                return viewController
            }

            func updateUIViewController(_ uiViewController: LoginViewController, context: Context) {
            }
        }

        func toPreview() -> some View {
            Preview(viewController: self)
        }
}
#endif
