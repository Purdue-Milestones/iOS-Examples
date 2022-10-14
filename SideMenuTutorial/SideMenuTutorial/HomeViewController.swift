//
//  HomeViewController.swift
//  SideMenuTutorial
//
//  Created by Carolina Solís on 10/6/22.
//

import Foundation
import UIKit

class HomeViewController: UIViewController{
    
   
    @IBOutlet weak var sideMenuBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
           super.viewDidLoad()

           sideMenuBtn.target = revealViewController()
           sideMenuBtn.action = #selector(revealViewController()?.revealSideMenu)
       }
}
