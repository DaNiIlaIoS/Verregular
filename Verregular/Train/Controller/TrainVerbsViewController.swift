//
//  TrainVerbsViewController.swift
//  Verregular
//
//  Created by Даниил Сивожелезов on 30.05.2024.
//

import UIKit
import SnapKit

final class TrainVerbsViewController: UIViewController {
    
    // MARK: - GUI Variables
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    private lazy var contentView: UIView = UIView()
    
    private lazy var infinitiveLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.text = "Infinitive".uppercased()
        return label
    }()
    
    private lazy var pastSimpleLabel: UILabel = {
        let label = UILabel()
        label.text = "Past Simple"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray5
        return label
    }()
    
    private lazy var participleLabel: UILabel = {
        let label = UILabel()
        label.text = "Participle Simple"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray5
        return label
    }()
    
    private lazy var pastSimpleTextField: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.delegate = self
        field.autocorrectionType = .no
        return field
    }()
    
    private lazy var participleTextField: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.delegate = self
        field.autocorrectionType = .no
        return field
    }()
    
    private lazy var checkButton: UIButton = {
        let button = UIButton()
        button.setTitle("Check".localized, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGray5
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(checkAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var scoreLabel: UILabel = {
        let label = UILabel()
        label.text = "Score: \(score)"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var remainderLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    // TODO: Skip Button
    private lazy var skipButton: UIButton = {
        let button = UIButton()
        button.setTitle("Skip".localized, for: .normal)
        button.setTitleColor(.systemGray3, for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(skipAction), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    private let edgeInsets = 30
    private let dataSource = IrregularVerbs.shared.selectedVerbs
    private var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    private var currentVerb: Verb? {
        guard dataSource.count > count else { return nil }
        return dataSource[count]
    }
    private var count = 0 {
        didSet {
            infinitiveLabel.text = currentVerb?.infinitive.uppercased()
            remainderLabel.text = "\(count)/\(dataSource.count)"
            clearTextField()
        }
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Train verbs".localized
        
        infinitiveLabel.text = currentVerb?.infinitive.uppercased()
        remainderLabel.text = "\(count)/\(dataSource.count)"
        
        setupUI()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unregisterForKeyboardNotification()
    }
    
    // MARK: - Methods
    @objc
    private func checkAction() {
        
        if checkAnswer() {
            
            score += checkAttempt() ? 0 : 1
            
            alertController()
            
            count += 1
            
            checkButton.backgroundColor = .green
            checkButton.setTitle("Correct".localized, for: .normal)
            pastSimpleTextField.becomeFirstResponder()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.checkButton.setTitle("Check".localized, for: .normal)
                self?.checkButton.backgroundColor = .systemGray5
            }
            
        }  else {
            checkButton.backgroundColor = .red
            checkButton.setTitle("Try again".localized, for: .normal)
            clearTextField()
        }
    }
    
    @objc
    private func skipAction() {
        let skipAlert = UIAlertController(title: "You skip verb",
                                          message: "Past simple: \(currentVerb?.pastSimple ?? "")\n Participle: \(currentVerb?.participle ?? "")",
                                          preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { okAction in
            self.alertController()
            self.count += 1
        }
        skipAlert.addAction(okAction)
        present(skipAlert, animated: true)
        
    }
    
    private func checkAttempt() -> Bool {
        let isSecondAttempt = checkButton.backgroundColor == .red
        return isSecondAttempt
    }
    
    private func checkAnswer() -> Bool {
        pastSimpleTextField.text?.lowercased() == currentVerb?.pastSimple.lowercased() &&
        participleTextField.text?.lowercased() == currentVerb?.participle.lowercased()
    }
    
    private func alertController() {
        if currentVerb?.infinitive == dataSource.last?.infinitive {
            let alertController = UIAlertController(title: "Your result".localized,
                                                    message: "Score: \(score)".localized,
                                                    preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { okAction in
                self.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(okAction)
            present(alertController, animated: true)
        }
    }
    
    private func clearTextField() {
        pastSimpleTextField.text = ""
        participleTextField.text = ""
        pastSimpleTextField.becomeFirstResponder()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews([infinitiveLabel,
                                 scoreLabel,
                                 pastSimpleLabel,
                                 pastSimpleTextField,
                                 participleLabel,
                                 participleTextField,
                                 checkButton,
                                 remainderLabel,
                                skipButton])
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.size.edges.equalToSuperview()
        }
        
        infinitiveLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(150)
            make.leading.trailing.equalToSuperview().inset(edgeInsets)
        }
        
        scoreLabel.snp.makeConstraints { make in
            make.top.equalTo(infinitiveLabel.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(edgeInsets)
        }
        
        pastSimpleLabel.snp.makeConstraints { make in
            make.top.equalTo(infinitiveLabel.snp.bottom).offset(60)
            make.leading.trailing.equalToSuperview().inset(edgeInsets)
        }
        pastSimpleTextField.snp.makeConstraints { make in
            make.top.equalTo(pastSimpleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(edgeInsets)
        }
        
        participleLabel.snp.makeConstraints { make in
            make.top.equalTo(pastSimpleTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(edgeInsets)
        }
        participleTextField.snp.makeConstraints { make in
            make.top.equalTo(participleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(edgeInsets)
        }
        
        checkButton.snp.makeConstraints { make in
            make.top.equalTo(participleTextField.snp.bottom).offset(100)
            make.height.equalTo(44)
            make.leading.trailing.equalToSuperview().inset(edgeInsets)
        }
        
        remainderLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.trailing.equalToSuperview().inset(edgeInsets)
        }
        
        skipButton.snp.makeConstraints { make in
            make.top.equalTo(checkButton.snp.bottom).offset(20)
            make.height.equalTo(34)
            make.leading.trailing.equalToSuperview().inset(edgeInsets)
        }
    }
}

// MARK: - UITextFieldDelegate
extension TrainVerbsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if pastSimpleTextField.isFirstResponder {
            participleTextField.becomeFirstResponder()
        } else {
            scrollView.endEditing(true)
        }
        
        return true
    }
}

// MARK: - Keyboard events
private extension TrainVerbsViewController {
    func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unregisterForKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    func keyboardWillShow(_ notification: Notification) {
        guard let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        scrollView.contentInset.bottom = frame.height + 50
    }
    
    @objc
    func keyboardWillHide() {
        scrollView.contentInset.bottom = .zero - 50
    }
    
    func hideKeyboardWhenTappedAround() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        scrollView.addGestureRecognizer(recognizer)
    }
    
    @objc
    func hideKeyboard() {
        scrollView.endEditing(true)
    }
}
