

import Foundation
import UIKit
import RxCocoa
import RxSwift
import RealmSwift

class ImagePikerViewModel {
    
    
    // MARK: - Properties
    var totalarray: [SecretFoto] = []
    var realm = try! Realm()
    
    
    // MARK: - Prime functions
    func addImage(image: UIImage) -> [SecretFoto] {
        let photo = SecretFoto()
        if  let imageName = self.saveImage(image: image) {
            photo.name = imageName
            totalarray.append(photo)
        }
        realm.beginWrite()
        realm.add(photo)
        do{
            try realm.commitWrite()
        } catch {
            print(error)
        }
        return totalarray
    }
    
    private func saveImage(image: UIImage) -> String? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
              let data = image.jpegData(compressionQuality: 1) else { return nil}
        
        let fileName = UUID().uuidString
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let error {
                print("couldn't remove file at path", error)
            }
        }
        do {
            try data.write(to: fileURL)
            return fileName
        } catch let error {
            print("error saving file with error", error)
            return nil
        }
    }
}
