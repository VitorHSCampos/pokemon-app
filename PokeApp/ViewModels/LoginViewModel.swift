//
//  LoginViewModel.swift
//  PokeApp
//
//  Created by Vitor Campos on 2/4/21.
//

import Foundation

protocol LoginDelegate: class {
    func requestNewPassword()
    func requestLoginPassword()
    func resetForms()
    func loginSuccess()
    func presentError(text: String)
}

class LoginViewModel {
    let userService = UserService()
    
    var userList: [User] = []
    
    var email: String?
    
    var delegate: LoginDelegate!
    
    init() {
        self.userService.getUserList { (users) in
            self.userList = users
        }
    }
    
    func checkNeedsCreatePassword(_ email: String) {
        self.email = userList.first(where: {$0.email.lowercased() == email.lowercased()})?.email
        
        if self.email == nil {
            self.delegate.presentError(text: "Usuário não encontrado")
            return
        }

        if User.checkUserExists(email: email.lowercased()) != nil {
            self.delegate.requestLoginPassword()
        } else {
            self.delegate.requestNewPassword()
        }
    }
    
    func validatePassword(_ password: String) {
        let storedPassword = KeychainHelper.retrieveUserPassword(email: self.email!)
        if storedPassword == password {
            self.delegate.loginSuccess()
        } else {
            self.delegate.presentError(text: "Senha incorreta")
        }
    }
    
    func createPassword(_ password: String) {
        KeychainHelper.saveUserPassword(email: self.email!.lowercased(), password: password)
        self.delegate.loginSuccess()
        userList.first(where: {$0.email.lowercased() == email?.lowercased() })?.saveUser()
    }
}
