import Foundation
import UIKit
import RxCocoa
import RxSwift

protocol ImagePikerViewControllerDelegate: AnyObject {
    func getObject(objects: [SecretFoto])
}

class ImagePikerViewController: UIViewController {
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var imageToAdd: UIImageView!
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    
    // MARK: - Properties
    let model = ImagePikerViewModel()
    let disposeBag = DisposeBag()
    var user = [SecretFoto]()
    weak var delegate: ImagePikerViewControllerDelegate?
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.exit()
        self.add()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.showPickerAlert()
    }
    
    
    // MARK: - Rx Setup
    func add(){
        self.addButton
            .rx
            .tap
            .subscribe{ [weak self] event in
                guard let image = self?.imageToAdd.image else {return}
                if let object = self?.model.addImage(image: image) {
                    self?.user = object
                }
                guard let controller = self?.storyboard?.instantiateViewController(withIdentifier: Constants.showViewController) as? ShowViewController else {return}
                controller.updateIndex()
                self?.navigationController?.pushViewController(controller, animated: true)
            }.disposed(by: disposeBag)
    }
    
    func exit(){
        self.exitButton
            .rx
            .tap
            .subscribe{ [weak self] event in
                if let delegate = self?.delegate {
                    delegate.getObject(objects: self!.user)
                }
                self?.navigationController?.popViewController(animated: true)
            }.disposed(by: disposeBag)
    }
    
    
    // MARK: - Prime functions
    private func showImagePicker(sourceType: UIImagePickerController.SourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.modalPresentationStyle = .overCurrentContext
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    private func showPickerAlert() {
        let alert = UIAlertController(title: "Choose image source", message: nil, preferredStyle: .actionSheet)
        let library = UIAlertAction(title: "Photos", style: .default) { (_) in
            self.showImagePicker(sourceType: .photoLibrary)
        }
        let camera = UIAlertAction(title: "Camera", style: .default) { (_) in
            self.showImagePicker(sourceType: .camera)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}


// MARK: - Extensions
extension ImagePikerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            self.imageToAdd.contentMode = .scaleAspectFill
            self.imageToAdd.image = image
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            self.imageToAdd.contentMode = .scaleAspectFill
            self.imageToAdd.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
