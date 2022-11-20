//
//  HelpViewController.swift
//  MicrovestApp
//
//  Created by Carolina Solís on 11/19/22.
//

import Foundation
import UIKit
import MessageUI
import SafariServices

class HelpViewController: UIViewController, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate  {

   
    @IBOutlet weak var sideMenuBtn: UIBarButtonItem!
    
    @IBAction func contactButton(_ sender: UIButton) {
        if MFMailComposeViewController.canSendMail(){
            let vc = MFMailComposeViewController()
            vc.mailComposeDelegate = self
            vc.setSubject("Help / Feedback")
            vc.setToRecipients(["orlandohoilett@purdue.edu"])
            vc.setMessageBody("<h4>Hello World</h4>", isHTML: true)
            //if you wanted to attach file
           // vc.addAttachmentData(attachment:Data, mimeType: "plain/txt", fileName: String)
            present(vc,animated:true)
        }
        else {
            guard let url = URL(string: "https://www.gmail.com") else {
                return
            }
            let vc = SFSafariViewController(url:url)
            present(vc, animated: true)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        sideMenuBtn.image = UIImage(systemName: "text.justify")
        sideMenuBtn.target = revealViewController()
        sideMenuBtn.action = #selector(revealViewController()?.revealSideMenu)
    }

}
