import RealmSwift
import Foundation
import  UIKit

struct FotoBrain {
    
    var array = try! Realm().objects(SecretFoto.self).toArray()
    var currentFotoNumber = 0
    var backgroundFotoNumber = 1
    var progress = 1
    
    mutating func stepLeft()  {
        if currentFotoNumber + 1 > 1 {
            currentFotoNumber -= 1
            if currentFotoNumber == 0 {
                backgroundFotoNumber = array.count - 1
            } else {
                backgroundFotoNumber = currentFotoNumber - 1
            }
            progress -= 1
        } else {
            currentFotoNumber = array.count - 1
            backgroundFotoNumber = currentFotoNumber - 1
            progress = array.count
        }
    }
    
    mutating func stepRight()  {
        if currentFotoNumber + 1 < array.count {
            currentFotoNumber += 1
            backgroundFotoNumber = currentFotoNumber - 1
            progress += 1
        } else {
            currentFotoNumber = 0
            backgroundFotoNumber = array.count - 1
            progress = 1
        }
    }
    
    func getProgress() -> Float {
        return Float(progress) / Float(array.count)
    }
    
    func loadImage(fileName: String) -> UIImage? {
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let imageUrl = documentsDirectory.appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
            
        }
        return nil
    }
}
