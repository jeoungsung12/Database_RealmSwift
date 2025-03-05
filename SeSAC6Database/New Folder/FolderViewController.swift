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
        dump(list)
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
    }
    
    private func configureConstraints() {
         
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
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
        
    }
      
}

