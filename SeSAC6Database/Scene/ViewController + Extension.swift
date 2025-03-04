//
//  ViewController + Extension.swift
//  SeSAC6Database
//
//  Created by 정성윤 on 3/4/25.
//

import UIKit
import SwiftUI

extension ViewController {
    
    
}

struct ViewControllerRepresentable<T:UIViewController>: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> T {
        return T()
    }
    
    func updateUIViewController(_ uiViewController: T, context: Context) {}
}


