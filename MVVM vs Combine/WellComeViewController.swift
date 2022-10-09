//
//  ViewController.swift
//  MVVM vs Combine
//
//  Created by mr.root on 10/9/22.
//

import UIKit
import Combine

class WellComeViewController: UIViewController {
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lnAbout: UILabel!
    @IBOutlet weak var btGotoLogin: UIButton!
    let viewModel = WellComeViewModel(user: .init(name: "Long", about: "123", isLogin: false))
    // khai báo phần lưu trữ cho các subcrition
    var subscription = Set<AnyCancellable>()
    

    @IBOutlet weak var btGotoHome: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // subscription
        // name
        viewModel.name
            .assign(to: \.text, on: lbName)// dùng để đưa dữ liệu tới thẳng thuộc tính của đối tượng
            .store(in: &subscription)
        // about
        viewModel.about
            .assign(to: \.text, on: lnAbout)
            .store(in: &subscription)
        //Button
        viewModel.loginEnble
            .sink { isLogin in// sink để xử lý nhiều tác vụ với dữ liệu nhận được
                self.btGotoLogin.isEnabled = !isLogin
                self.btGotoHome.isEnabled = isLogin
            }
            .store(in: &subscription)// lưu trữ các subscription lại
        setupBtLogin()
        setupGoToHome()
    }
    private func setupBtLogin() {
        btGotoLogin.setTitle("Login", for: .normal)
        btGotoLogin.backgroundColor = .blue
        btGotoLogin.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
    }
    @objc func didTapLogin() {
        viewModel.action.send(.gotoLogin)
    }
    private func setupGoToHome() {
        btGotoHome.setTitle("GoToHome", for: .normal)
        btGotoHome.backgroundColor = .blue
        btGotoHome.addTarget(self, action: #selector(didTapHome), for: .touchUpInside)
    }
    @objc func didTapHome() {
        viewModel.action.send(.gotoHome)
    }
    


}

