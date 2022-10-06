import UIKit

class AuthViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let loginLabel: UILabel = {
        let label = UILabel()
        label.text = "LogIn"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter email"
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter password"
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("SignUp", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("SignIn", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var textFieldsStackView = UIStackView()
    private var buttonStackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupDelegate()
        registerKeyboardNotification()
        setupConstraints()
        
        let dataBase = DataBase.shared.users
        print(dataBase)
    }
    
    deinit {
        removeKeyboardNotification()
    }
    
    private func setupView() {
        title = "SignIn"
        view.backgroundColor = .white
        
        textFieldsStackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField],
                                          axis: .vertical,
                                          spacing: 10,
                                          distribution: .fillProportionally)
        
        buttonStackView = UIStackView(arrangedSubviews: [signInButton, signUpButton],
                                          axis: .horizontal,
                                          spacing: 10,
                                          distribution: .fillEqually)
        
        view.addSubview(scrollView)
        scrollView.addSubview(backgroundView)
        backgroundView.addSubview(textFieldsStackView)
        backgroundView.addSubview(loginLabel)
        backgroundView.addSubview(buttonStackView)
    }
    
    private func setupDelegate() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    @objc private func signUpButtonTapped() {
        let signUpViewController = SignUpViewController()
        self.present(signUpViewController, animated: true)
    }
    
    @objc private func signInButtonTapped() {
        
        let mail = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let user = findUserDataBase(mail: mail)
        
        if user == nil {
            loginLabel.text = "User not found"
            loginLabel.textColor = .red
        } else if user?.password == password {
            let vc = UINavigationController(rootViewController: AlbumsViewController())
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
            
            guard let activeUser = user else { return }
            DataBase.shared.saveActiveUser(user: activeUser)
        } else {
            loginLabel.text = "Wrong password"
            loginLabel.textColor = .red
        }
    }
    
    private func findUserDataBase(mail: String) -> User? {

        let database = DataBase.shared.users
        
        for user in database {
            if user.email == mail {
                return user
            }
        }
        return nil
    }
}

//MARK: - UITextFieldDelegate

extension AuthViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
}

//MARK: - Keyboard show hide


extension AuthViewController {
    
    private func registerKeyboardNotification() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func removeKeyboardNotification() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        let userInfo = notification.userInfo
        let keyboardHeight = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        scrollView.contentOffset = CGPoint(x: 0, y: keyboardHeight.height / 2)
    }
    
    @objc private func keyboardWillHide() {
        scrollView.contentOffset = CGPoint.zero
        
    }
}

//MARK: - SetConstrains

extension AuthViewController {
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            backgroundView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            backgroundView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            backgroundView.heightAnchor.constraint(equalTo: view.heightAnchor),
            backgroundView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            textFieldsStackView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            textFieldsStackView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            textFieldsStackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 20),
            textFieldsStackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            loginLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            loginLabel.bottomAnchor.constraint(equalTo: textFieldsStackView.topAnchor, constant: -30)
        ])
        
        NSLayoutConstraint.activate([
            signUpButton.heightAnchor.constraint(equalToConstant: 40),
            signInButton.heightAnchor.constraint(equalToConstant: 40),
        ])
        
        NSLayoutConstraint.activate([
            buttonStackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 20),
            buttonStackView.topAnchor.constraint(equalTo: textFieldsStackView.bottomAnchor, constant: 30),
            buttonStackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -20)        ])
    }
}
