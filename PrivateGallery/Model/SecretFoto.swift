import Foundation
import RealmSwift

class SecretFoto: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var comment: String?
    @objc dynamic var like: Bool = false
}
