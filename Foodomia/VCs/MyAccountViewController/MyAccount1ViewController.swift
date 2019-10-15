//
//  MyAccount1ViewController.swift
//  Foodomia
//
//  Created by Rao Mudassar on 9/29/17.
//  Copyright © 2017 dinosoftlabs. All rights reserved.
//

import UIKit
import KRProgressHUD

class MyAccount1ViewController: UIViewController {
    
    
    @IBOutlet weak var editView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        let yourBackImage = UIImage(named: "BACK")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.backItem?.title = ""
        
        editView.layer.borderWidth = 1
        editView.layer.borderColor = UIColor.init(red:190/255.0, green:44/255.0, blue:44/255.0, alpha: 1.0).cgColor
        editView.layer.masksToBounds = true
        editView.layer.cornerRadius = 3
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Account"
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
