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
import FirebaseAuth
import Firebase
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(kakaoLoginButton)
        self.view.backgroundColor = .darkGray
        self.view.addSubview(coffeeImage)
        self.view.addSubview(loginbtn)
        self.view.addSubview(registerbtn)
        setidpwField()
        setloginbtn()
    
        setkakaologinbtn(kakaoLoginButton)
        kakaoLoginButton.addTarget(self, action: #selector(kakaologintap), for: .touchUpInside)
        coffeeImage.snp.makeConstraints{
            $0.left.right.equalToSuperview()
            $0.top.equalTo(0)
            $0.height.equalTo(view.snp.height).multipliedBy(1.0 / 2.0)
        }
        
        //login 기능 구현
        self.loginbtn.addTarget(self, action: #selector(loginbtntap), for: .touchUpInside)
        self.registerbtn.addTarget(self, action: #selector(registertap), for: .touchUpInside)
        
    }
    private func setidpwField(){
        self.view.addSubview(idField)
        self.view.addSubview(pwField)
        idField.keyboardType = .emailAddress
        idField.snp.makeConstraints{
            make in make.top.equalTo(coffeeImage.snp.bottom).offset(30)
            make.height.equalTo(50)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
        }
        idField.attributedPlaceholder = NSAttributedString(string: "   Enter your. ID", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        pwField.attributedPlaceholder =          NSAttributedString(string: "   Enter your PW", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])


        pwField.isSecureTextEntry = true
        pwField.autocapitalizationType = .none
        pwField.snp.makeConstraints{make in
            make.top.equalTo(idField.snp.bottom).offset(25)
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
        self.loginbtn.layer.borderWidth = 0.1
        self.loginbtn.layer.borderColor = UIColor.brown.cgColor
        self.loginbtn.snp.makeConstraints{ make in
            make.width.equalToSuperview().multipliedBy(1.0 / 3)
            make.leading.equalTo(70)
            make.height.equalTo(40)
            make.top.equalTo(pwField.snp.bottom).offset(30)
            
        }
        loginbtn.layer.cornerRadius = 10
        let text2 = "회원가입"
        self.registerbtn.setTitle(text2, for: .normal)
        registerbtn.setTitleColor(.blue, for: .normal)
        registerbtn.backgroundColor = .systemGray3
        let bb = NSMutableAttributedString(string: text2)
        bb.addAttribute(.font, value: font, range: NSRange.init(location: 0, length: text2.count))
        bb.addAttribute(.underlineStyle , value: 1, range: NSRange.init(location: 0, length: text2.count))
        self.registerbtn.titleLabel?.attributedText = bb
        self.registerbtn.snp.makeConstraints{
            make in make.leading.equalTo(loginbtn.snp.trailing).offset(15)
            make.height.equalTo(40)
            make.width.equalToSuperview().multipliedBy(1.0 / 3)
            make.bottom.equalTo(loginbtn.snp.bottom)
        }
        registerbtn.layer.cornerRadius = 10
    }
    
    private func setkakaologinbtn(_ btn : UIButton){
        self.view.addSubview(btn)
        btn.setImage(UIImage(named: "kakaologin"), for: .normal)
        btn.snp.makeConstraints{
            make in make.top.equalTo(loginbtn.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
    }
  
    @objc func kakaologintap(){
        // 카카오톡 설치가 안되어잇는경우를 대비해 웹브라우저를 통한 카카오 로그인ㄴ 구현
        UserApi.shared.loginWithKakaoAccount{
            (OAuthToken, Error ) in if let Error = Error {
                print(Error)
            }
            else {
                self.navigationController?.pushViewController(mainviewController(), animated: true)
                _ = OAuthToken
            }
        }
    }
    @objc func loginbtntap(){
        guard let idtext = idField.text else {return}
        guard let pwtext = pwField.text else {return}
        if isValidEmail(id: idtext) && isValidPassword(pwd: pwtext){
            Auth.auth().signIn(withEmail: idtext, password: pwtext){authResult, error in
                if authResult != nil {
                    self.navigationController?.pushViewController(mainviewController(), animated: true)
                }else {
                    let alertController = UIAlertController(title: "계정오류", message: "아이디와 비밀번호를 다시 확인해주세요", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                    self.present(alertController,animated: true,completion: nil)
                }
            }

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
    @objc func registertap(){

        let registerviewcontroller = RegisterViewController()
        self.navigationController?.pushViewController(registerviewcontroller, animated: true)
       
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
