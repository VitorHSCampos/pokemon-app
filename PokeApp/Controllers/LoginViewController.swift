//
//  LoginViewController.swift
//  PokeApp
//
//  Created by Vitor Campos on 2/4/21.
//

import UIKit

class LoginViewController: UIViewController, LoginDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    
    let viewModel = LoginViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        
        self.view.bringSubviewToFront(textField)
        self.view.bringSubviewToFront(label)
        self.view.bringSubviewToFront(button)
        
        self.button.layer.cornerRadius = self.button.frame.height/2
        self.button.setTitleColor(.white, for: .normal)
        self.button.backgroundColor = .red
        resetForms()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func requestNewPassword() {
        self.textField.textContentType = .password
        self.textField.text = nil
        self.label.text = "Cadastre uma senha"
        self.button.setTitle("Cadastrar", for: .normal)
        self.button.removeTarget(nil, action: nil, for: .allEvents)
        self.button.addTarget(self, action: #selector(registerPassword), for: .touchUpInside)
    }
    
    func requestLoginPassword() {
        self.textField.textContentType = .password
        self.textField.text = nil
        self.label.text = "Digite sua senha"
        self.button.setTitle("Entrar", for: .normal)
        self.button.removeTarget(nil, action: nil, for: .allEvents)
        self.button.addTarget(self, action: #selector(login), for: .touchUpInside)
    }
    
    func resetForms() {
        self.textField.textContentType = .emailAddress
        self.textField.text = nil
        self.label.text = "Email"
        self.button.setTitle("Próximo", for: .normal)
        self.button.removeTarget(nil, action: nil, for: .allEvents)
        self.button.addTarget(self, action: #selector(validateEmail), for: .touchUpInside)
        self.viewModel.email = nil
    }
    
    @objc func login() {
        viewModel.validatePassword(textField.text ?? "")
    }
    
    @objc func registerPassword() {
        guard let pass = textField.text, pass != "" else {
            self.presentError(text: "Digite uma senha válida")
            return
        }
        viewModel.createPassword(pass)
    }
    
    @objc func validateEmail() {
        viewModel.checkNeedsCreatePassword(textField.text ?? "")
    }
    
    func loginSuccess() {
        let indexController = PokemonIndexTableViewController()
        indexController.title = "Pokemon Index"
        indexController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        let indexNav = UINavigationController(rootViewController: indexController)
        
        let favoritesController = FavoritesIndexTableViewController()
        favoritesController.title = "Favoritos"
        favoritesController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        let favNav = UINavigationController(rootViewController: favoritesController)

        let tabbarc = UITabBarController()
        tabbarc.viewControllers = [indexNav, favNav]
        
        self.navigationController?.setViewControllers([tabbarc], animated: true)
    }
    
    func presentError(text: String) {
        let alert = UIAlertController(title: "Ops!", message: text, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }

}
