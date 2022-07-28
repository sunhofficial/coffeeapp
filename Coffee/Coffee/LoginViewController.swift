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
    let idField = UITextField()
    let pwField = UITextField()
    let loginbtn = UIButton()
    let registerbtn = UIButton()
    let coffeeImage : UIImageView =  {
        let imageview = UIImageView(image: UIImage(named: "coffee"))
        imageview.contentMode = .scaleAspectFill
        return imageview
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(kakaoLoginButton)
        self.view.backgroundColor = .darkGray
        self.view.addSubview(coffeeImage)
        self.view.addSubview(loginbtn)
        self.view.addSubview(registerbtn)
        setloginbtn()
        
        setkakaologinbtn(kakaoLoginButton)
        kakaoLoginButton.addTarget(self, action: #selector(kakaologintap), for: .touchUpInside)
        coffeeImage.snp.makeConstraints{
            $0.left.right.equalToSuperview()
            $0.top.equalTo(0)
            $0.height.equalTo(view.snp.height).multipliedBy(1.0 / 2.0)
        }
        setidpwField()
        //login 기능 구현
        self.loginbtn.addTarget(self, action: #selector(loginbtntap), for: .touchUpInside)
        
    }
    private func setidpwField(){
        self.view.addSubview(idField)
        self.view.addSubview(pwField)
        idField.keyboardType = .emailAddress

        idField.snp.makeConstraints{
            make in make.top.equalTo(coffeeImage.snp.bottom).offset(20)
            make.height.equalTo(50)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
        }
        idField.placeholder = "  Enter your ID"
        pwField.placeholder = "  Enter your PW"
        pwField.isSecureTextEntry = true
        pwField.autocapitalizationType = .none
        pwField.snp.makeConstraints{make in
            make.top.equalTo(idField.snp.bottom).offset(16)
            make.leading.equalTo(idField.snp.leading)
            make.trailing.equalTo(idField.snp.trailing)
            make.height.equalTo(50)
        }
        idField.layer.cornerRadius = 15.0
        pwField.layer.borderWidth = 1
        pwField.layer.cornerRadius = 15.0
        idField.layer.borderWidth = 1
    }
    private func setloginbtn(){
        let text = "로그인"
        self.loginbtn.setTitle(text, for: .normal)
        loginbtn.setTitleColor(.white, for: .normal)
        let aa = NSMutableAttributedString(string: text)
        let font = UIFont(name: "Helvetica", size: 25)
        aa.addAttribute(.font, value: font, range: NSRange.init(location: 0, length: text.count))
        aa.addAttribute(.underlineStyle , value: 1, range: NSRange.init(location: 0, length: text.count))
        self.loginbtn.titleLabel?.attributedText = aa
        loginbtn.backgroundColor = .systemBrown
//        loginbtn.layer.cornerRadius = 15
        self.loginbtn.layer.borderWidth = 2
        self.loginbtn.layer.borderColor = UIColor.brown.cgColor
        self.loginbtn.snp.makeConstraints{ make in
            make.width.equalToSuperview().multipliedBy(1.0 / 3)
            make.leading.equalTo(70)
            make.height.equalTo(40)
            make.bottom.equalTo(kakaoLoginButton.snp.top).offset(-30)
            
        }
        loginbtn.layer.cornerRadius=40
        let text2 = "회원가입"
        self.registerbtn.setTitle(text2, for: .normal)
        registerbtn.setTitleColor(.blue, for: .normal)
        registerbtn.backgroundColor = .systemGray3
        let bb = NSMutableAttributedString(string: text2)
        bb.addAttribute(.font, value: font, range: NSRange.init(location: 0, length: text2.count))
        bb.addAttribute(.underlineStyle , value: 1, range: NSRange.init(location: 0, length: text2.count))
        self.registerbtn.titleLabel?.attributedText = bb
        self.registerbtn.snp.makeConstraints{
            make in make.leading.equalTo(loginbtn.snp.trailing)
            make.height.equalTo(40)
            make.width.equalToSuperview().multipliedBy(1.0 / 3)
            make.bottom.equalTo(loginbtn.snp.bottom)
        }
        self.registerbtn.layer.borderWidth = 2
        self.registerbtn.layer.borderColor = UIColor.brown.cgColor
        registerbtn.layer.cornerRadius=40
    }
    
    private func setkakaologinbtn(_ btn : UIButton){
        self.view.addSubview(btn)
        btn.setImage(UIImage(named: "kakaologin"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.snp.makeConstraints{
            make in make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(100)
            make.centerX.equalToSuperview()
        }
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
    @objc func loginbtntap(){
        guard let idtext = idField.text else {return}
        guard let pwtext = pwField.text else {return}
        if isValidEmail(id: idtext) && isValidPassword(pwd: pwtext){
            print("성공")
        }
        if !isValidEmail(id: idtext){
            let alertController = UIAlertController(title: nil, message: "아이디를 다시 확인해 주세요.", preferredStyle: .alert)
                   alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                   self.present(alertController, animated: true, completion: nil)
        }
        if !isValidPassword(pwd: pwtext){
            let alertController = UIAlertController(title: nil, message: "비밀번호 다시확인해 주세요.", preferredStyle: .alert)
                   alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                   self.present(alertController, animated: true, completion: nil)
        }
    }
    func isValidEmail(id: String) -> Bool {
        let emailRegEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}" // @앞에 대문자소문자 특수문자 가능하고 @ 뒤에는대문자 소문자 숫자. .기준으로 맨마지막 문자가 2글자 이상이여야함.
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEX)
        return emailTest.evaluate(with: id)
    }
    func isValidPassword(pwd: String) -> Bool {
        let passwordRegEx = "^[a-zA-Z0-9]{8,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: pwd)
    }
    
}
struct PreView: PreviewProvider {
    static var previews: some View {
        LoginViewController().toPreview().previewInterfaceOrientation(.portrait)
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
