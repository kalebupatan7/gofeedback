//
//  GFContactViewController.swift
//  Genfare
//
//  Created by omniwyse on 29/03/19.
//  Copyright © 2019 Omniwyse. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class GFContactViewController: GFBaseViewController {
    
//    let viewModel = ContactViewModel()
//    let disposeBag = DisposeBag()
    
    @IBOutlet var vistTheWebsiteProperty: GFMenuButton!
    @IBOutlet var commentsProperty: GFMenuButton!
    @IBOutlet var callNumberProperty: GFMenuButton!
    @IBOutlet weak var topNavBar: UIView!
    @IBOutlet weak var navBarLogo: UIImageView!
   
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = UIColor.formLabelText
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.backgroundColor = UIColor.white
        self.scrollView.backgroundColor = UIColor.white
    }
    

    func updateUI(){
        vistTheWebsiteProperty.backgroundColor = UIColor(hexString:"#459EAC")
        callNumberProperty.backgroundColor = UIColor(hexString:"#459EAC")
        commentsProperty.backgroundColor = UIColor(hexString:"#459EAC")
    }
    
    @IBAction func facebookBtnClkd(_ sender: Any) {
        
        if UIApplication.shared.canOpenURL(NSURL(string: "fb://") as! URL ) {
            if let url = URL(string: "https://www.facebook.com/cotabus"), !url.absoluteString.isEmpty {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            
        }
    }
    
    @IBAction func twitterButtonClicked(_ sender: UIButton) {
        if UIApplication.shared.canOpenURL(NSURL(string: "twitter://")! as URL ) {
            if let url = URL(string: "https://twitter.com/cotabus/"), !url.absoluteString.isEmpty {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            
        }
    }
    
    func callNum() {
        let alert = UIAlertController(title: "Call COTA?", message: "Call (518) 482-8822", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.destructive, handler: { action in
            if let url = URL(string:"tel:6142281776"), !url.absoluteString.isEmpty {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                
            }
        }))
        
    }
}
