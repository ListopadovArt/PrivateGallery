
import UIKit

class StartFotoCollectionViewCell: UICollectionViewCell {
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    
    
    // MARK: - Properties
//    static let identifier = "StartFotoCollectionViewCell"
    var fotoBrain = FotoBrain()
    
    // MARK: - Prime functions
    func configure(with object: SecretFoto) {
        guard let imageName = self.fotoBrain.loadImage(fileName: object.name) else {return}
        self.imageView.image = imageName
        
    }
}
