//
//  GFBaseViewController.swift
//  Genfare
//
//  Created by omniwzse on 28/08/18.
//  Copyright © 2018 Genfare. All rights reserved.
//

import UIKit
import SideMenu

class GFBaseViewController: UIViewController {

    var currentTextField:UITextField?
    static var currentMenuItem:String = Constants.SideMenuAction.HomeScreen
    var spinnerView:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addMenuObservers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.setNavigationBarHidden(true, animated: false)
        //view.backgroundColor = UIColor.topNavBarColor
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        view?.endEditing(true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var isUserLoggedIn: Bool {
        
        guard let loginStatus = UserDefaults.standard.value(forKey: "loginStatus") as? Bool else
        {
            return true
        }
        
        return !loginStatus
    }
    
    func addMenuObservers() {
        print("Add MENU Observers")
        
        //Prevent adding observers multipletimes
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: Constants.NotificationKey.Login), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showUserLogin), name: Notification.Name(Constants.NotificationKey.Login), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func updateUIFortenant() {
        //TODO - need to implement tenant based UI
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func goToRoot(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }

    @IBAction func dismissCurrent(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func presentSideMenu(_ sender: UIButton) {
        showSideMenu()
    }
    
    @objc func showSideMenu() {
        if let controller = UIStoryboard(name: "Sidemenu", bundle: nil).instantiateInitialViewController() {
            SideMenuItemsViewController.rightNavController = self.navigationController
            present(controller, animated: true, completion: nil)
        }
    }
    
    @objc func showUserLogin() {
        if let controller = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController() {
            let navController = UINavigationController(rootViewController: controller)
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true, completion: nil)
        }
    }

    @objc func navigateToPlanTrip() {
        print("SIDEMENU - Plan Trip")
        if GFBaseViewController.currentMenuItem == Constants.SideMenuAction.PlanTrip {
            SideMenuItemsViewController.rightNavController?.popToRootViewController(animated: false)
            return
        }
        
        if let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GFNAVIGATEMENUHOME") as? HomeViewController {
            SideMenuItemsViewController.rightNavController?.viewControllers = [controller]
        }
        GFBaseViewController.currentMenuItem = Constants.SideMenuAction.PlanTrip
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
    
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func logoutUser() {
        //GFAccountManager.logout()
        navigateToPlanTrip()
        //TODO - Handle any logout related stuff
    }
    
    func updateNavBarUI() {
        let barButton:UIBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "Hamburger"), style: .plain, target: self, action:#selector(showSideMenu))
        barButton.tintColor = UIColor.white
        self.navigationItem.leftItemsSupplementBackButton = false
        self.navigationItem.leftBarButtonItem = barButton
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "\(Utilities.tenantId().lowercased())NavBarLogo"))
        
    }
    
    func showNavBar() {
        if let navController = self.navigationController {
            navController.setNavigationBarHidden(false, animated: true)
        }
    }
    
    func hideNavBar() {
        if let navController = self.navigationController{
            navController.setNavigationBarHidden(true, animated: true)
        }
    }

    func attachSpinner(value:Bool) {
        if value {
            self.spinnerView = UIViewController.displaySpinner(onView: self.view)
        }else{
            if let _ = self.spinnerView {
                UIViewController.removeSpinner(spinner: self.spinnerView!)
            }
        }
    }
    
    func showErrorMessage(message:String) {
        if message != ""{
            self.popupAlert(title: "ERROR", message: message, actionTitles: ["OK"], actions: [nil])
        }
    }
    
    deinit {
        print("Controller is being removed -============================================== \(self)")
    }
}

extension GFBaseViewController: UISideMenuNavigationControllerDelegate {
    func sideMenuWillAppear(menu: UISideMenuNavigationController, animated: Bool) {
        UIApplication.shared.sendAction(#selector(resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension GFBaseViewController {
    func popupAlert(title: String?, message: String?, actionTitles:[String?], actions:[((UIAlertAction) -> Void)?]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title, style: .default, handler: actions[index])
            alert.addAction(action)
        }
        self.present(alert, animated: true, completion: nil)
    }
}

extension UIViewController {
    class func displaySpinner(onView : UIView) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    
    class func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
}

extension UIViewController {
    
    func dismissKey()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer( target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
