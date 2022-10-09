//
//  WellComeViewModel.swift
//  MVVM vs Combine
//
//  Created by mr.root on 10/9/22.
//

import Foundation
import Combine
final class WellComeViewModel {
    let name = CurrentValueSubject<String?, Never>(nil)
    let about = CurrentValueSubject<String?, Never>(nil)
    let loginEnble = CurrentValueSubject<Bool, Never>(false)
    let texError = CurrentValueSubject<String?, Never>(nil)
    let state = CurrentValueSubject<State, Never>(.initial)
    var subscription = Set<AnyCancellable>()
    /* Các CurrentValueSubject có thể lưu trữ dữ liệu, đóng vai trò như sucriber để nhận dữ liệu */
    // Dùng enum để định nghĩa trạng thái của login
    
    var user: User
    
    init(user: User) {
        self.user = user
        // Tạo 1 subscriptions
        state.sink(receiveValue: { [weak self] state in
            self?.progressState(state)
        })
        .store(in: &subscription)
        
        // Tạo 1 subscriptions để thực hiện func progress
        action.sink(receiveValue: { [weak self] action in
            self?.progressAction(action)
        })
        .store(in: &subscription)
        
    }
    //MARK:- Trạng thái
    enum State {
        case initial
        case error(massage: String)
    }
    //MARK: Action
    enum Action {
    case gotoLogin
    case gotoHome
    }
    
    let action = PassthroughSubject<Action, Never>()// PassthroughtSubject không lưu được dữ liệu
    private func progressState(_ state: State) {
        switch state {
        case .initial:
            name.value = user.name
            about.value = user.about
            loginEnble.value = user.isLogin
            texError.value = nil
        case .error(massage: let message):
            texError.value = message
            
        }
    }
    
    // Tạo function để sưr lý trạng thái của Action
    private func progressAction(_ action: Action) {
        switch action {
        case .gotoLogin:
            print("login")
        case .gotoHome:
            print("GotoHome")
        }
    }
}
