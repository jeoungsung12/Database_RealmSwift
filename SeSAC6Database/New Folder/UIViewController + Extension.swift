//
//  UIViewController + Extension.swift
//  SeSAC6Database
//
//  Created by 정성윤 on 3/7/25.
//

import UIKit
import RealmSwift

//실제 디바이스 남은 용량을 확인

extension UIViewController {
    //posterImageView.image
    func saveImageToDocument(image: UIImage, filename: String) {
        //jack/Desktop/SeSAC/project
        //도큐먼트 폴더 위치
//        let realm = try! Realm()
        //이미지 용량 줄이기: 압축, 해상도 조절, 리사이징, 다운 샘플링
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        //이미지를 저장할 경로(파일명) 지정
        //appendingPathComponent
        //폴더 메서드는? 찾아보세요~
        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        //실제 저장하려는 이미지 파일
        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
        do {
            try data.write(to: fileURL)
        } catch {
            print("이미지 저장 실패!") //용량이 부족할때?,
        }
    }
    
    func loadImageToDocument(filename: String) -> UIImage? {
        //도큐먼트 위치 확인
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return UIImage(systemName: "star") }
        //이미지 파일 경로를 확인
        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        //이 경로에 실제로 파일이 존재하는지도 체크
        if FileManager.default.fileExists(atPath: fileURL.path()) {
            return UIImage(contentsOfFile: fileURL.path())
        } else {
            return UIImage(systemName: "star")
        }
    }
    
    func removeImageFromDocument(filename: String) {
        guard let documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else { return }
        
        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        
        if FileManager.default.fileExists(atPath: fileURL.path()) {
            
            do {
                try FileManager.default.removeItem(atPath: fileURL.path())
            } catch {
                print("file remove error", error)
            }
            
        } else {
            print("file no exist")
        }
        
    }
    
}
