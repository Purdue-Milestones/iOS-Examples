//
//  VideoViewController.swift
//  MicrovestApp
//
//  Created by Carolina Solís on 2/13/22.
//

import UIKit

class VideoViewController: UIViewController {

    @IBOutlet weak var sideMenuBtn: UIBarButtonItem!
    
    @IBOutlet weak var videoButton: UISwitch!
    @IBAction func videoSwitch(_ sender: UISwitch) {
        if sender.isOn{
            viewDidLoad()
            print("Video Switch On")
        }
        else{
            //VoltageAudioBox.clear()
            print("Video Switch Off")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        sideMenuBtn.image = UIImage(systemName: "text.justify")
        sideMenuBtn.target = revealViewController()
        sideMenuBtn.action = #selector(revealViewController()?.revealSideMenu)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
