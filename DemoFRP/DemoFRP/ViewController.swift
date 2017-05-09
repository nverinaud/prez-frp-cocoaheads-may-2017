//
//  Created by Nicolas VERINAUD on 08/05/2017.
//  Copyright © 2017 Nicolas VERINAUD. All rights reserved.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class ViewController: UIViewController, UITextFieldDelegate
{
    private let disposeBag = DisposeBag()
    private var usernameField: UITextField!
    private var passwordField: UITextField!
    private var loginButton: UIButton!
    
    override func loadView()
    {
        view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor.white
        
        usernameField = UITextField()
        usernameField.placeholder = "Username"
        usernameField.delegate = self
        view.addSubview(usernameField)
        
        passwordField = UITextField()
        passwordField.placeholder = "Password"
        passwordField.isSecureTextEntry = true
        passwordField.delegate = self
        view.addSubview(passwordField)
        
        loginButton = UIButton(type: .system)
        loginButton.setTitle("Login", for: .normal)
        view.addSubview(loginButton)
        
        setupConstraints()
        setupBindings()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if textField == usernameField
        {
            passwordField.becomeFirstResponder()
            return false
        }
        
        return true
    }
    
    private func setupConstraints()
    {
        usernameField.snp.makeConstraints { make in
            make.top.equalTo(topLayoutGuide.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
            make.height.equalTo(44)
        }
        
        passwordField.snp.makeConstraints { make in
            make.top.equalTo(usernameField.snp.bottom).offset(8)
            make.size.centerX.equalTo(usernameField)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom).offset(14)
            make.size.centerX.equalTo(passwordField)
        }
    }
    
    private func setupBindings()
    {
        let textIsEmpty: (String?) -> Bool = { $0?.isEmpty == true }
        
        let usernameEmpty = usernameField.rx.text.map(textIsEmpty)
        let passwordEmpty = passwordField.rx.text.map(textIsEmpty)
        
        let loginButtonEnabled = Observable.combineLatest(usernameEmpty, passwordEmpty) { !$0 && !$1 }
        
        loginButtonEnabled.bind(to: loginButton.rx.isEnabled)
            .addDisposableTo(disposeBag)
    }
}
