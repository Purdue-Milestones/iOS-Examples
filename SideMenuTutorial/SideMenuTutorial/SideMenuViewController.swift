//
//  SideMenuViewController.swift
//  SideMenuTutorial
//
//  Created by Carolina Solís on 10/6/22.
//

import UIKit

protocol SideMenuViewControllerDelegate {
    func selectedCell(_ row: Int)
}

class SideMenuViewController: UIViewController {
    var delegate: SideMenuViewControllerDelegate?
    
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var sideMenuTableView: UITableView!
    @IBOutlet weak var footerLabel: UILabel!
    
    
    var defaultHighlightedCell: Int = 0
    
    //choose icons for side menu and asign to corresponding VC
    var menu: [SideMenuModel] = [
        SideMenuModel(icon: UIImage(systemName: "house.fill")!, title: "Home"),
        SideMenuModel(icon: UIImage(systemName: "music.note")!, title: "Music"),
        SideMenuModel(icon: UIImage(systemName: "book.fill")!, title: "Books"),
    ]
    
    //set up how side menu looks like
    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.
        
        // TableView
        self.sideMenuTableView.delegate = self
        self.sideMenuTableView.dataSource = self
        self.sideMenuTableView.backgroundColor =   #colorLiteral(red: 0.9409657121, green: 0.8277415633, blue: 0.9443354607, alpha: 1)
        self.sideMenuTableView.separatorStyle = .none
        
        // Set Highlighted Cell
        DispatchQueue.main.async {
            let defaultRow = IndexPath(row: self.defaultHighlightedCell, section: 0)
                self.sideMenuTableView.selectRow(at: defaultRow, animated: false, scrollPosition: .none)
                }
        //Image
        headerImageView.image = UIImage(named:"purplenotes.jpg")

        // Footer
        self.footerLabel.textColor = UIColor.black
        self.footerLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        self.footerLabel.text = "Developed by Caro"

        // Register TableView Cell
        self.sideMenuTableView.register(SideMenuCell.nib, forCellReuseIdentifier: SideMenuCell.identifier)

        // Update TableView with the data
        self.sideMenuTableView.reloadData()
            }
    }
    

    // MARK: - UITableViewDelegate

    extension SideMenuViewController: UITableViewDelegate {
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
        }
    }
    
    
    // MARK: - UITableViewDataSource

    extension SideMenuViewController: UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.menu.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuCell.identifier, for: indexPath) as? SideMenuCell else { fatalError("xib doesn't exist") }
            
            cell.iconImageView.image = self.menu[indexPath.row].icon
            cell.titleLabel.text = self.menu[indexPath.row].title

        // Highlighted color
            let myCustomSelectionColorView = UIView()
            myCustomSelectionColorView.backgroundColor =   #colorLiteral(red: 0.9409657121, green: 0.8277415633, blue: 0.9443354607, alpha: 1)
            cell.selectedBackgroundView = myCustomSelectionColorView
            return cell
    }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            self.delegate?.selectedCell(indexPath.row)
        
        // Remove highlighted color when you press the 'Profile' and 'Like us on facebook' cell
            
        }
        
    }
