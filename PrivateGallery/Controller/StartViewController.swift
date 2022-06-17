
import UIKit
import RxCocoa
import RxSwift
import RealmSwift

class StartViewController: UIViewController {
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var showButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cleanMemoryButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // MARK: - Properties
    let model = StartViewModel()
    let disposeBag = DisposeBag()
    var realm = try! Realm()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewCollection()
        self.showImage()
        self.add()
        self.cleanMemory()
        var configuration = Realm.Configuration()
        configuration.deleteRealmIfMigrationNeeded = true
        realm = try! Realm(configuration: configuration)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let array = try! Realm().objects(SecretFoto.self).toArray()
        if array.isEmpty {
            showButton.isEnabled = false
            showButton.setTitleColor(.systemGray, for: .normal)
        } else {showButton.isEnabled = true
            showButton.isEnabled = true
            showButton.setTitleColor(.label, for: .normal)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    // MARK: - Rx Setup
    func bindViewCollection(){
        self.model
            .data
            .bind(to: collectionView.rx.items(cellIdentifier: Constants.startFotoCollectionViewCell, cellType: StartFotoCollectionViewCell.self)) {(row, element, item) in
                item.configure(with: element)
                item.dropShadow()
                let collectionViewLayout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
                collectionViewLayout.minimumLineSpacing = 4
                collectionViewLayout.itemSize = CGSize(width: UIScreen.main.bounds.width/2-(collectionViewLayout.minimumLineSpacing)*2, height: UIScreen.main.bounds.width/2-(collectionViewLayout.minimumLineSpacing)*2)
            }.disposed(by: disposeBag)
        
        self.collectionView
            .rx
            .modelSelected(SecretFoto.self)
            .subscribe(onNext: { item in
                self.model.showImage(item: item, view: self.view)
            }).disposed(by: disposeBag)
    }
    
    func add(){
        self.addButton
            .rx
            .tap
            .subscribe{ [weak self] event in
                guard let controller = self?.storyboard?.instantiateViewController(withIdentifier: Constants.imagePikerViewController) as? ImagePikerViewController else {
                    return
                }
                controller.delegate = self
                self?.navigationController?.pushViewController(controller, animated: true)
            }.disposed(by: disposeBag)
    }
    
    func showImage(){
        self.showButton
            .rx
            .tap
            .subscribe{ [weak self] event in
                guard let controller = self?.storyboard?.instantiateViewController(withIdentifier: Constants.showViewController) as? ShowViewController else {
                    return
                }
                self?.navigationController?.pushViewController(controller, animated: true)
            }.disposed(by: disposeBag)
    }
    
    func cleanMemory(){
        self.cleanMemoryButton
            .rx
            .tap
            .subscribe{[weak self] event in
                self?.model.cleanMemory()
                self?.showButton.isEnabled = false
                self?.showButton.setTitleColor(.lightGray, for: .normal)
            }.disposed(by: disposeBag)
    }
}


// MARK: - Extensions
extension StartViewController: ImagePikerViewControllerDelegate {
    func getObject(objects: [SecretFoto]) {
        self.model.addImage(objects: objects)
    }
}


