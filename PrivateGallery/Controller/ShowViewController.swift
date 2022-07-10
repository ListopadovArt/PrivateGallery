
import UIKit
import RealmSwift

class ShowViewController: UIViewController {
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var currentImage: UIImageView!
    @IBOutlet weak var backgroungImage: UIImageView!
    @IBOutlet weak var completionStatus: UIProgressView!
    @IBOutlet weak var imageCommentField: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    
    // MARK: - Properties
    var fotoBrain = FotoBrain()
    let image = Image(x: 50, y: 50, width: 314, height: 614)
    var realm = try! Realm()
    var like: Bool = false
    let backButtonImage = UIImage(named: "Back")
    let favoriteBorderImage = UIImage(named: "baseline_favorite_border_black")?.withRenderingMode(.alwaysTemplate)
    let favoriteFullImage = UIImage(named: "baseline_favorite_white")?.withRenderingMode(.alwaysTemplate)
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForKeyboardNotifications()
        self.imageCommentField.delegate = self
        if fotoBrain.array.count == 1 {
            leftButton.isEnabled = false
            leftButton.setTitleColor(.lightGray, for: .normal)
            rightButton.isEnabled = false
            rightButton.setTitleColor(.lightGray, for: .normal)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.addSubview(self.backButton)
        self.view.addSubview(self.likeButton)
        self.addBackButton()
        self.addLikeButton()
        self.updateUI()
    }
    
    
    // MARK: - Initialization functions
    private func addBackButton(){
        self.backButton.setImage(self.backButtonImage, for: .normal)
        self.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        self.backButton.leftAnchor.constraint(equalTo: self.currentImage.leftAnchor).isActive = true
        self.backButton.bottomAnchor.constraint(equalTo: self.currentImage.topAnchor, constant: -5).isActive = true
        self.likeButton.bottomAnchor.constraint(equalTo: self.backgroungImage.topAnchor, constant: -5).isActive = true
        self.backButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.backButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    private func addLikeButton(){
        self.likeButton.setImage(self.favoriteBorderImage, for: .normal)
        self.likeButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        self.likeButton.rightAnchor.constraint(equalTo: self.currentImage.rightAnchor).isActive = true
        self.likeButton.bottomAnchor.constraint(equalTo: self.currentImage.topAnchor, constant: -5).isActive = true
        self.likeButton.bottomAnchor.constraint(equalTo: self.backgroungImage.topAnchor, constant: -5).isActive = true
        self.likeButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.likeButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    
    // MARK: - Actions
    @objc func favoriteButtonTapped(_ sender: UIButton) {
        self.likeButton.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 10,
                       options: .curveEaseInOut,
                       animations: {
            self.like = !self.like
            let image = self.like ? self.favoriteFullImage : self.favoriteBorderImage
            self.likeButton.setImage(image, for: .normal)
            self.likeButton.transform = .identity
        }, completion: nil)
        try! self.realm.write {
            self.fotoBrain.array[self.fotoBrain.currentFotoNumber].like = self.like
        }
    }
    
    @objc func backButtonTapped(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
              let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        if notification.name == UIResponder.keyboardWillHideNotification {
            bottomConstraint.constant = 0
        } else {
            bottomConstraint.constant = keyboardScreenEndFrame.height - 90
        }
        view.needsUpdateConstraints()
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    // MARK: - Prime functions
    @objc func updateUI() {
        completionStatus.progress = fotoBrain.getProgress()
        self.currentImage.frame = CGRect(x: self.image.x, y: self.image.y, width: self.image.width, height: self.image.height)
        self.currentImage.contentMode = .scaleAspectFill
        let image = self.fotoBrain.loadImage(fileName: fotoBrain.array[fotoBrain.currentFotoNumber].name)
        self.currentImage.image = image
        self.backgroungImage.frame = CGRect(x: self.image.x , y: self.image.y, width: self.image.width, height: self.image.height)
        self.backgroungImage.contentMode = .scaleAspectFill
        let imageBack = self.fotoBrain.loadImage(fileName: fotoBrain.array[fotoBrain.currentFotoNumber].name)
        self.backgroungImage.image = imageBack
        self.imageCommentField.text = self.fotoBrain.array[self.fotoBrain.currentFotoNumber].comment
        self.like = self.fotoBrain.array[self.fotoBrain.currentFotoNumber].like
        let imageLike = self.like ? self.favoriteFullImage : self.favoriteBorderImage
        self.likeButton.setImage(imageLike, for: .normal)
        setupOneTapGesturesToImage()
        setupTwoTapGesturesToImage()
    }
    
    func updateIndex(){
        self.fotoBrain.currentFotoNumber = self.fotoBrain.array.count - 1
        self.fotoBrain.backgroundFotoNumber = self.fotoBrain.array.count
        self.fotoBrain.progress = self.fotoBrain.array.count
    }
    
    
    //MARK: - Gestures
    private func setupOneTapGesturesToImage() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(showImage))
        tap.numberOfTapsRequired = 1
        currentImage.isUserInteractionEnabled = true
        currentImage.addGestureRecognizer(tap)
    }
    
    private func setupTwoTapGesturesToImage() {
        let tapTap = UITapGestureRecognizer(target: self, action: #selector(hideImage))
        currentImage.isUserInteractionEnabled = true
        tapTap.numberOfTapsRequired = 2
        currentImage.addGestureRecognizer(tapTap)
    }
    
    
    //MARK: - Working with images
    @objc func showImage(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.3, animations: {
            self.currentImage.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
        })
    }
    
    @objc func hideImage (_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.3, animations: {
            self.currentImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    private func updateImage(index: Int){
        let image = self.fotoBrain.loadImage(fileName: fotoBrain.array[index].name)
        self.backgroungImage.image = image
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(updateUI), userInfo: nil, repeats: false)
    }
    
    
    // MARK: - IBActions
    @IBAction func pressedOnLeft(_ sender: UIButton) {
        self.fotoBrain.stepLeft()
        self.updateImage(index: fotoBrain.currentFotoNumber)
        UIView.animate(withDuration: 0.3) {
            self.currentImage.frame.origin.x += self.view.frame.size.width + self.currentImage.frame.size.width
        }
    }
    
    @IBAction func pressedOnRight(_ sender: UIButton) {
        self.fotoBrain.stepRight()
        self.updateImage(index: fotoBrain.currentFotoNumber)
        UIView.animate(withDuration: 0.3) {
            self.currentImage.frame.origin.x -= self.view.frame.size.width
        }
    }
}


// MARK: - Extensions
extension ShowViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = self.imageCommentField.text {
            try! realm.write {
                self.fotoBrain.array[self.fotoBrain.currentFotoNumber].comment = text
            }
        }
    }
}
