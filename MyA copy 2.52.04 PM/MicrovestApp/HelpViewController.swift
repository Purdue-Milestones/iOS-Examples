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

class HelpViewController: UIViewController, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate  {
   
    @IBOutlet weak var sideMenuBtn: UIBarButtonItem!

    
    //SEND EMAIL
    @IBAction func contactButton(_ sender: UIButton) {
        if MFMailComposeViewController.canSendMail(){
            let vc = MFMailComposeViewController()
            vc.mailComposeDelegate = self
            vc.setSubject("Help / Feedback")
            vc.setToRecipients(["orlandohoilett@purdue.edu"])
            vc.setMessageBody("<h4>Hello Orlando!</h4>", isHTML: true)
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
    
    //SEND MESSAGE
    @IBAction func sendMessage(_ sender: Any) {
        displayMessageInterface()
    }
    
    //MESSAGE FUNCTIONS
    func displayMessageInterface() {
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self
        
        // Configure the fields of the interface.
        composeVC.recipients = ["7654180593"]
        composeVC.body = "Hello Caro!"
        
        // Present the view controller modally.
        if MFMessageComposeViewController.canSendText() {
            present(composeVC, animated: true)
        } else {
            print("Can't send messages.")
            guard let url = URL(string: "https://www.google.com") else {
                return
            }
            let vc = SFSafariViewController(url:url)
            present(vc, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        sideMenuBtn.image = UIImage(systemName: "text.justify")
        sideMenuBtn.target = revealViewController()
        sideMenuBtn.action = #selector(revealViewController()?.revealSideMenu)
    }
    
    
    
    
    //Protocol for message composer
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //Protocol for email composer
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

}
