//
//  RegisterViewController.swift
//  Coffee
//
//  Created by SunHo Lee on 2022/07/29.
//

import UIKit
import SwiftUI
class RegisterViewController : UIViewController{
    lazy var registertitle : UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
        label.font = UIFont.systemFont(ofSize: 40   , weight: .bold)
        label.text = "회원가입"
        return label
    }()
    
    lazy var idTitle : UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.text = "아이디"
        return label
    }()
    
    lazy var pwTitle : UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
        label.font = UIFont.systemFont(ofSize: 18   , weight: .bold)
        label.text = "비밀번호"
        return label
    }()
    lazy var pw2Title : UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
        label.font = UIFont.systemFont(ofSize: 18   , weight: .bold)
        label.text = "비밀번호확인"
        return label
    }()
    lazy var nameTitle : UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        label.font = UIFont.systemFont(ofSize: 18   , weight: .bold)
        label.text = "이름"
        return label
    }()
    lazy var registerBtn : UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: self.view.bounds.width/2 - 100 , y: self.view.bounds.height/2 + 50, width: 200, height: 100)
        button.backgroundColor = .systemPink
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 20.0
        button.setTitle("회원가입하기",for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    let idinput = UITextField()
    let pwinput = UITextField()
    let pw2input = UITextField()
    let nameinput = UITextField()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemTeal
        view.addSubview(registertitle)
        view.addSubview(idinput)
        view.addSubview(pwinput)
        view.addSubview(pw2input)
        view.addSubview(nameinput)
        view.addSubview(idTitle)
        view.addSubview(pwTitle)
        view.addSubview(pw2Title)
        view.addSubview(nameTitle)
        view.addSubview(registerBtn)
        view.backgroundColor = .white
        
        layout()
    }
    private func layout() {
        self.idinput.keyboardType = .emailAddress
        idinput.placeholder = "원하시는 id를 입력하세요"
        pwinput.placeholder = "원하시는 비밀번호를 입력하세요"
        pw2input.placeholder = "비밀번호를 한번더 입력해주세요"
        nameinput.placeholder = "이름입력해주세요"
        pwinput.isSecureTextEntry = true
        pw2input.isSecureTextEntry = true
        registertitle.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(50)
        }
        idTitle.snp.makeConstraints{
            $0.bottom.equalTo(idinput.snp.top)
            $0.leading.equalTo(idinput.snp.leading)
        }
        pwTitle.snp.makeConstraints{
            $0.leading.equalTo(idinput.snp.leading)
            $0.bottom.equalTo(pwinput.snp.top)
        }
        pw2Title.snp.makeConstraints{
            $0.leading.equalTo(idinput.snp.leading)
            $0.bottom.equalTo(pw2input.snp.top)
        }
        nameTitle.snp.makeConstraints{
            $0.leading.equalTo(idinput.snp.leading)
            $0.bottom.equalTo(nameinput.snp.top)
        }
        idinput.snp.makeConstraints{
            $0.top.equalTo(registertitle.snp.bottom).offset(100)
            $0.leading.equalToSuperview().offset(40)
            $0.trailing.equalToSuperview().offset(-40)
        }
        pwinput.snp.makeConstraints{
            $0.top.equalTo(idinput.snp.bottom).offset(50)
            $0.leading.equalTo(idinput.snp.leading)
        }
        pw2input.snp.makeConstraints{
            $0.top.equalTo(pwinput.snp.bottom).offset(50)
            $0.leading.equalTo(idinput.snp.leading)
            
        }
        nameinput.snp.makeConstraints{
            $0.top.equalTo(pw2input.snp.bottom).offset(50)
            $0.leading.equalTo(idinput.snp.leading)
        }
        registerBtn.snp.makeConstraints{
            $0.top.equalTo(nameinput.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().offset(50)
  
        }
        
        
    }
    
}


struct PreView1: PreviewProvider {
    static var previews: some View {
        RegisterViewController().toPreview().previewInterfaceOrientation(.portraitUpsideDown)
    }
}
#if DEBUG
extension RegisterViewController {
    private struct Preview1: UIViewControllerRepresentable {
            let viewController: RegisterViewController

            func makeUIViewController(context: Context) -> RegisterViewController {
                return viewController
            }

            func updateUIViewController(_ uiViewController: RegisterViewController, context: Context) {
            }
        }

        func toPreview() -> some View {
            Preview1(viewController: self)
        }
}
#endif

