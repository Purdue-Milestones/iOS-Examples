//
//  InfoViewController.swift
//  MicrovestApp
//
//  Created by Carolina Solís on 2/13/22.
//

import UIKit

class InfoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
        {
            let touch = touches.first
            if touch?.view == self.view
            { self.dismiss(animated: true, completion: nil) }
        }

}
