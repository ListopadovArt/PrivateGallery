
import Foundation
import UIKit
import RxCocoa
import RxSwift
import RealmSwift

class StartViewModel {
    
    
    // MARK: - Properties
    var realm = try! Realm()
    let data = BehaviorRelay(value: try! Realm().objects(SecretFoto.self).toArray())
    var fotoBrain = FotoBrain()
    let image: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    // MARK: - Prime functions
    func addImage(objects: [SecretFoto]){
        var array = data.value
        array += objects
        data.accept(array)
    }
    
    func cleanMemory(){
        var array = data.value
        array.removeAll()
        self.realm.beginWrite()
        self.realm.delete(data.value)
        self.realm.deleteAll()
        try! realm.commitWrite()
        data.accept(array)
    }
    
    func showImage(item: SecretFoto, view: UIView){
        self.image.frame = CGRect(x:Int(view.frame.origin.x) , y: Int(view.frame.origin.y), width: Int(view.frame.size.width), height: Int(view.frame.size.height))
        view.addSubview(self.image)
        let photo = self.fotoBrain.loadImage(fileName: item.name)
        self.image.image = photo
        self.image.contentMode = .scaleAspectFill
        let translationTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 400, 0)
        self.image.layer.transform = translationTransform
        UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: {
            self.image.layer.transform = CATransform3DIdentity
        })
        let tapTap = UITapGestureRecognizer(target: self, action: #selector(closeImage))
        self.image.isUserInteractionEnabled = true
        tapTap.numberOfTapsRequired = 1
        self.image.addGestureRecognizer(tapTap)
    }
    
    @objc func closeImage() {
        self.image.removeFromSuperview()
    }
}
