//
//  FolderDetailViewController.swift
//  SeSAC6Database
//
//  Created by 정성윤 on 3/5/25.
//


import UIKit
import SnapKit
import RealmSwift
/*
 뷰 갱신
 데이터 수정
 */
final class FolderDetailViewController: UIViewController {
    private let tableView = UITableView()
    var list: List<JackTable>!
    var id: ObjectId!
     
    private let repository: JackTableRepositoryType = JackTableRepository()
    private let folderRepository: FolderRepositoryType = FolderRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        folderRepository.createItem(name: "개인")
        folderRepository.createItem(name: "계모임")
        folderRepository.createItem(name: "회사")
        folderRepository.createItem(name: "멘토")
        print(#function)
        print(repository.getFileURL())
        configureHierarchy()
        configureView()
        configureConstraints()
    }
    
    private func configureHierarchy() {
        view.addSubview(tableView)
    }
    
    private func configureView() {
        view.backgroundColor = .white
        tableView.rowHeight = 130
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.id)
          
        let image = UIImage(systemName: "plus")
        let item = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(rightBarButtonItemClicked))
        navigationItem.rightBarButtonItem = item
    }
    
    private func configureConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
     
    @objc func rightBarButtonItemClicked() {
        let vc = AddViewController()
        vc.id = id
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension FolderDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.id) as! ListTableViewCell
        
        let data = list[indexPath.row]
        
        cell.titleLabel.text = data.name
        cell.subTitleLabel.text = data.category
        cell.overviewLabel.text = data.money.formatted()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = list[indexPath.row]
        repository.deleteItem(data: data)
//        tableView.reloadData()
    }
      
}
