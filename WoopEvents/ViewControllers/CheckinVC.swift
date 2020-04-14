//
//  CheckinVC.swift
//  WoopEvents
//
//  Created by Fredyson Costa Marques Bentes on 13/04/20.
//  Copyright © 2020 home. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTextFields
import MaterialComponents.MaterialButtons
import MaterialComponents.MaterialDialogs
import MaterialComponents.MaterialSnackbar

class CheckinVC: UIViewController, WeStoryboardViewController {
    
    @IBOutlet weak var textFieldName: MDCTextField!
    @IBOutlet weak var textFieldEmail: MDCTextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var viewCard: ShadowedView!
    
    var nameController: MDCTextInputControllerUnderline!
    var emailController: MDCTextInputControllerUnderline!
    
    var eventId: String = ""
    
    static func getStoryboardName() -> String {
        return "Main"
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCard()
        
        registerKeyboardNotifications()
        addGestureRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.textFieldName.becomeFirstResponder()
    }
    
    func addGestureRecognizer() {
        let tapRecognizer = UITapGestureRecognizer(target: self,
                                                   action: #selector(tapDidTouch(sender: )))
        self.scrollView.addGestureRecognizer(tapRecognizer)
    }
    
    @objc
    func tapDidTouch(sender: Any) {
        self.view.endEditing(true)
    }
    
    func setupCard() {
        self.viewCard.setDefaultElevation()
        
        self.textFieldName.delegate = self
        self.textFieldName.textContentType = UITextContentType(rawValue: "")
        self.textFieldName.autocorrectionType = .no
        self.textFieldName.autocapitalizationType = .sentences
        self.nameController = MDCTextInputControllerUnderline(textInput: textFieldName)
        setupFieldController(nameController, "Nome")
        
        self.textFieldEmail.delegate = self
        self.textFieldEmail.textContentType = UITextContentType(rawValue: "")
        self.textFieldEmail.autocorrectionType = .no
        self.textFieldEmail.keyboardType = .emailAddress
        self.emailController = MDCTextInputControllerUnderline(textInput: textFieldEmail)
        setupFieldController(emailController, "E-mail")
    }
    
    func setupFieldController(_ controller: MDCTextInputControllerUnderline, _ placeholder: String) {
        let font = WeFont.robotoRegular(size: 14)
        
        let colorText = Palette.textFieldDefault()
        let colorPlaceholder = Palette.textFieldPlaceholder()
        let colorNormal = Palette.textFieldDivisor()
        let colorActive = Palette.textFieldDefault()
        let colorError = Palette.errorText()
        
        controller.textInput?.font = font
        controller.textInput?.textColor = colorText
        
        controller.normalColor = colorNormal
        controller.activeColor = colorActive
        controller.errorColor = colorError
        
        controller.placeholderText = placeholder
        controller.inlinePlaceholderColor = colorPlaceholder
        controller.floatingPlaceholderNormalColor = colorPlaceholder
        controller.floatingPlaceholderActiveColor = colorPlaceholder
    }
    
    @IBAction func tapConfirm(_ sender: Any) {
        validateFields()
    }
    
    func validateFields() {
        self.view.endEditing(true)
        
        let name = textFieldName.text ?? ""
        let email = textFieldEmail.text ?? ""
        
        if name.trimmingCharacters(in: .whitespaces).isEmpty {
            self.nameController.setErrorText("Nome inválido", errorAccessibilityValue: nil)
            self.textFieldName.becomeFirstResponder()
            return
        }
        
        if email.isEmpty || !isValidEmail(email) {
            self.emailController.setErrorText("E-mail inválido", errorAccessibilityValue: nil)
            self.textFieldEmail.becomeFirstResponder()
            return
        }
        
        completeCheckin(name: name, email: email)
    }
    
    func completeCheckin(name: String, email: String) {
        showProgress()
        let checkin = Checkin(eventId: eventId, name: name, email: email)
        WEService.shared.registerCheckin(checkin: checkin) { result in
            self.hideProgress()
            switch result {
                case .success(let response):
                    self.handle(response: response)
                case .failure(let error):
                    self.handle(error: error.localizedDescription)
             }
        }
    }
    
    func handle(response: CheckinResponse) {
        if response.code == "200" {
            showSuccessDialog()
        } else {
            showSnack("Falha ao realizar check-in")
        }
    }
    
    func handle(error: String) {
        showSnack(error)
    }
    
    func showSuccessDialog() {
        DispatchQueue.main.async {
            let alertController = MDCAlertController(title: "Sucesso", message: "Parabéns! o check-in foi realizado com sucesso.")
            let action = MDCAlertAction(title: "OK") { (action) in
                self.navigationController?.popBack(toControllerType: HomeVC.self)
            }
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func showProgress() {
        self.view.isUserInteractionEnabled = false
        self.activityIndicator.alpha = 1.0
        self.activityIndicator.startAnimating()
    }
    
    func hideProgress() {
        DispatchQueue.main.async {
            self.activityIndicator.alpha = 0
            self.activityIndicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
        }
    }
    
    func showSnack(_ message: String) {
        let snackBarMessage = MDCSnackbarMessage()
        snackBarMessage.text = message
        snackBarMessage.duration = 3.0
        MDCSnackbarManager.show(snackBarMessage)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
}

//MARK: - Text Field
extension CheckinVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textFieldName {
            textFieldEmail.becomeFirstResponder()
        }
        
        if textField == textFieldEmail {
            textField.resignFirstResponder()
        }
        
        return false
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if textField == textFieldName {
            self.nameController.setErrorText(nil, errorAccessibilityValue: nil)
        }
        
        if textField == textFieldEmail {
            self.emailController.setErrorText(nil, errorAccessibilityValue: nil)
        }
        
        return true
    }
}

// MARK: - Keyboard Handling
extension CheckinVC {
    
    func registerKeyboardNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(
            self,
            selector: #selector(keyboardWillShow(notif:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        notificationCenter.addObserver(
            self,
            selector: #selector(keyboardWillHide(notif:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
        notificationCenter.addObserver(
            self,
            selector: #selector(keyboardWillShow(notif:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil)
    }
    
    @objc func keyboardWillShow(notif: Notification) {
        guard let frame = notif.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        scrollView.contentInset = UIEdgeInsets(top: 0.0,
                                               left: 0.0,
                                               bottom: frame.height,
                                               right: 0.0)
    }
    
    @objc func keyboardWillHide(notif: Notification) {
        scrollView.contentInset = UIEdgeInsets()
    }
    
}
