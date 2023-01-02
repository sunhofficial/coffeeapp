//
//  RegisterViewController.swift
//  Coffee
//
//  Created by SunHo Lee on 2022/07/29.
//

import UIKit
import FirebaseDatabase
import Firebase
import FirebaseAuth
import FirebaseStorage
import SwiftUI
class RegisterViewController : UIViewController{
    var ref : DatabaseReference!
    lazy var registertitle : UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
        label.font = UIFont.systemFont(ofSize: 40   , weight: .bold)
        label.text = "회원가입"
        label.textColor = UIColor(named: "Color")
        return label
    }()
    
    lazy var idTitle : UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.text = "아이디"
        label.textColor = UIColor(named: "Color")
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
    let pwcheck = UILabel()
    let idinput = UITextField()
    let pwinput = UITextField()
    let pw2input = UITextField()
    let nameinput = UITextField()
    override func viewDidLoad() {
        super.viewDidLoad()

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
        view.addSubview(pwcheck)

        ref = Database.database().reference()//firebase reference 초기화
        layout()
        idinput.delegate = self
        pwinput.delegate = self
        pw2input.delegate = self
        nameinput.delegate = self
        registerBtn.addTarget(self, action: #selector(registerbtntap), for: .touchUpInside)
    }
    private func layout() {
        self.idinput.keyboardType = .emailAddress
        idinput.placeholder = "원하시는 id를 입력하세요"
        pwinput.placeholder = "원하시는 비밀번호를 입력하세요"
        pw2input.placeholder = "비밀번호를 한번더 입력해주세요"
        nameinput.placeholder = "이름입력해주세요"
        pwcheck.text = ""
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
        pwcheck.snp.makeConstraints{
            $0.top.equalTo(pw2input.snp.bottom)
            $0.leading.equalTo(pw2input.snp.trailing)
        }
    }
    @objc func registerbtntap(){

        guard let id = idinput.text,
              let pw = pwinput.text,
               let pw2=pw2input.text,
              let  name = nameinput.text else { return }
        if(pw != pw2){
            let alert = UIAlertController(title: "ERROR", message: "두 비밀번호가 다릅니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        if (id == "" || pw == "" || pw2 == "" || name == ""){
            let alert = UIAlertController(title: "ERROR", message: "모든 정보를 다채워주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        //여기까지가 확인 이아래부터가 이제 파이어베이스와 연동작업
        Auth.auth().createUser(withEmail: id, password: pw){
            [self] authResult, error in
            guard let user = authResult?.user, error == nil else{
                print("error")
                return
            }
            ref.child("users").child(user.uid).setValue(["name" :name ])
            dismiss(animated: true, completion: nil)
            self.navigationController?.pushViewController(MainVC(), animated: true)
            
        }
        
   
        }
}

extension RegisterViewController : UITextFieldDelegate {
    func setcheckpassword(_ password : String, _ password2 : String){
        guard password2 != "" else {
            pwcheck.text = ""
            return
        }
        if password == password2 {
            pwcheck.textColor = .green
            pwcheck.text = "비밀번호가 일치합니다."
        }else{
            pwcheck.textColor = .red
            pwcheck.text = "비밀번호가 일치하지 않습니다."
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case idinput:
            pwinput.becomeFirstResponder()
        case pwinput:
            pw2input.becomeFirstResponder()
        case pw2input:
            nameinput.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return false
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //사용자가 키 하나 눌렀을때마다 실행
        if textField == pw2input{ //현재 누른 텍스트가 비밀번호확인일때만 실행
            guard let password = pwinput.text, let passwordcheck = pw2input.text else {return true}
            let passwordConfirm = string.isEmpty ? passwordcheck[0..<(passwordcheck.count)] : passwordcheck + string
            // 백스페이스 눌렀을때 인덱스 0번부너 마지막글자까지 짜른다.그게 아니라면 그냥 현재 입력값을 더해준다.
            setcheckpassword(password, passwordConfirm)
        }
        return true
    }
}
extension String { //string을 배열처럼 쪼개기!!!!
    subscript(_ range: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
        let end = index(start, offsetBy: min(self.count - range.lowerBound,
                                             range.upperBound - range.lowerBound))
        return String(self[start..<end])
    }

    subscript(_ range: CountablePartialRangeFrom<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
         return String(self[start...])
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

