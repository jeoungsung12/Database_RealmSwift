//
//  AddViewController.swift
//  SeSAC6Database
//
//  Created by Jack on 3/4/25.
//

import UIKit
import SnapKit
import SwiftUI
import RealmSwift
import PhotosUI

class AddViewController: UIViewController {
     
    let moneyField = UITextField()
    let categoryField = UITextField()
    let memoField = UITextField()
    let photoImageView = UIImageView()
    let addButton = UIButton()
    
    let titleTextField = UITextField()
    let contentTextField = UITextField()
    private let repository: JackTableRepositoryType = JackTableRepository()
    private let folderRepository: FolderRepositoryType = FolderRepository()
    
    var id: ObjectId!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureView()
        configureConstraints() 
    }
    
    private func configureHierarchy() {
        view.backgroundColor = .white
        [moneyField, categoryField, memoField, photoImageView, addButton, titleTextField, contentTextField]
            .forEach({
                self.view.addSubview($0)
            })
    }
    
    @objc func addButtonClicked() {
        print(#function)
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 3
        configuration.filter = .any(of: [.videos, .images])
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
                
 
    
    @objc func saveButtonClicked() {
        print(#function)
        
        let folder = folderRepository.fetchAll().where { $0.id == id }.first!
        
        let data = JackTable(
            money: Int.random(in: 100...1000) * 100,
            category: ["생활비", "카페", "식비"].randomElement()!,
            name: ["린스", "커피", "과자", "칼국수"].randomElement()!,
            isPay: false,
            memo: nil
        )
        repository.createItemInFolder(folder: folder, data: data)
        if let image = photoImageView.image {
            self.saveImageToDocument(image: image, filename: "\(data.id)")
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    private func configureView() {
        
        titleTextField.placeholder = "제목을 입력해보세요"
        contentTextField.placeholder = "내용을 입력해보세요"
        
        addButton.backgroundColor = .black
        addButton.setTitleColor(.white, for: .normal)
        addButton.setTitle("이미지 추가", for: .normal)
        addButton.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
        
        photoImageView.backgroundColor = .lightGray
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonClicked))
        
        memoField.placeholder = "메모를 입력해보세요"
        moneyField.placeholder = "금액을 입력해보세요"
        categoryField.placeholder = "카테고리를 입력해보세요"
    }
    
     func configureConstraints() {
         
         moneyField.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(48)
            make.centerX.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
         categoryField.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(48)
            make.centerX.equalTo(view)
             make.top.equalTo(moneyField.snp.bottom).offset(20)
        }
        
         memoField.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(48)
            make.centerX.equalTo(view)
             make.top.equalTo(categoryField.snp.bottom).offset(20)
        }
        
        photoImageView.snp.makeConstraints { make in
            make.size.equalTo(200)
            make.centerX.equalTo(view)
            make.top.equalTo(memoField.snp.bottom).offset(20)
        }
        
        addButton.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(48)
            make.centerX.equalTo(view)
            make.top.equalTo(photoImageView.snp.bottom).offset(20)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(48)
            make.centerX.equalTo(view)
            make.top.equalTo(addButton.snp.bottom).offset(20)
        }
        
        contentTextField.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(48)
            make.centerX.equalTo(view)
            make.top.equalTo(titleTextField.snp.bottom).offset(20)
        }
         
     }
    
}

extension AddViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                
                DispatchQueue.main.async {
                    self.photoImageView.image = image as? UIImage
                }
                
            }
            
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerRepresentable<AddViewController>()
    }
}

