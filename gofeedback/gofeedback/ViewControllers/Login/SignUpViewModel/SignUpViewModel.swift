//
//  SignUpViewModel.swift
//  Genfare
//
//  Created by vishnu on 21/01/19.
//  Copyright © 2019 Omniwyse. All rights reserved.
//

import Foundation
import RxSwift

class SignUpViewModel {
    
    let model : SignUpModel = SignUpModel()
    let disposebag = DisposeBag()
    
    // Initialise ViewModel's
    let firstNameViewModel = NameTextViewModel()
    let lastNameViewModel = NameTextViewModel()
    let emailIdViewModel = EmailIdViewModel()
    let passwordViewModel = PasswordViewModel()
    let passwordViewModel2 = PasswordViewModel()
    let addressViewModel = AddressViewModel()
    
    // Fields that bind to our view's
    let isSuccess : Variable<Bool> = Variable(false)
    let isLoading : Variable<Bool> = Variable(false)
    let errorMsg : Variable<String> = Variable("")
    
    func validateCredentials() -> Bool{
        return firstNameViewModel.validateCredentials() && lastNameViewModel.validateCredentials() && emailIdViewModel.validateCredentials();
    }
    
    func formErrorString() -> String {
        
        if firstNameViewModel.errorValue.value != "" {
            return firstNameViewModel.errorValue.value ?? ""
        }else if(lastNameViewModel.errorValue.value != ""){
            return lastNameViewModel.errorValue.value ?? ""
        }else if(emailIdViewModel.errorValue.value != ""){
            return emailIdViewModel.errorValue.value ?? ""
        }else if(addressViewModel.errorValue.value != ""){
            return addressViewModel.errorValue.value ?? ""
        }else if(!matchPasswords()){
            return "Passwords does not match"
        }
        
        return ""
    }
    
    func matchPasswords() -> Bool {
        return passwordViewModel2.data.value == passwordViewModel.data.value
    }
    
    func signupUser() {
        
        self.isSuccess.value = true

//        Auth.auth().createUser(withEmail: emailIdViewModel.data.value, password: passwordViewModel2.data.value) { authResult, error in
//
//            if let error = error {
//
//                self.errorMsg.value = error.localizedDescription
//
//                print(error.localizedDescription)
//            } else {
//
//
//            }
//        }
    }
    
    func loginUser() {

    }
    
    func refreshToken(){

    }
    
}
