import UIKit
class Menucell : UICollectionViewCell{
    override init(frame :CGRect){
        super.init(frame: frame)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("삐용삐용 에러발생")
        
    }
    let textView : UITextView = {
        let img = UITextView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.backgroundColor = .darkGray
        img.textColor = .white
        return img
    }()
    func setupView(){
        self.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        textView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        textView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        
    }
    
}
