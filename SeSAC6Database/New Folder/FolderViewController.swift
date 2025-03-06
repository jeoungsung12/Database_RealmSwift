//
//  FolderViewController.swift
//  SeSAC6Database
//
//  Created by 정성윤 on 3/5/25.
//

import UIKit
import SnapKit
import RealmSwift

class FolderViewController: UIViewController {
    private let tableView = UITableView()
    private var list: Results<Folder>!
    private let repository: FolderRepositoryType = FolderRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureView()
        configureConstraints()
        list = repository.fetchAll()
        
        repository.createItem(name: "개인")
        repository.createItem(name: "계모임")
        repository.createItem(name: "회사")
        repository.createItem(name: "멘토")
//        dump(list)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
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
        let vc = MainViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
     
}

extension FolderViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.id) as! ListTableViewCell
        let data = list[indexPath.row]
        cell.titleLabel.text = data.name
        cell.subTitleLabel.text = "\(data.detail.count)개"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = list[indexPath.row]
        //EmbeddedObject
        repository.createMemo(data: data)
        
        //폴더 삭제
        //폴더 지울 때 세부 항목도 지울 것인지?
        //폴더 지울 때 세부 항목을 다른 폴더로 이동해줄 것인지?
//        repository.deleteItem(data: data)
//        tableView.reloadData()
        
//        let vc = FolderDetailViewController()
//        vc.list = data.detail
//        vc.id = data.id
//        navigationController?.pushViewController(vc, animated: true)
    }
      
}

