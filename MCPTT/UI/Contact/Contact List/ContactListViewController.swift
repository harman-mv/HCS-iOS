//
//  ContactsViewController.swift
//  mcpttapp
//
//  Created by Raju Maramulla on 09/10/18.
//  Copyright © 2018 Harman connected services. All rights reserved.
//

import Foundation
import UIKit

final class ContactListViewController : UIViewController, UICollectionViewDelegateFlowLayout{
    var userName = "Jeanette McHale"
    var userEmail = "MCID"
    var groups = ["Special TF A(999)"]
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let screenSize = UIScreen.main.bounds
    
    lazy var viewModel: ContactsViewModel = {
        return ContactsViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // init view model
        initVM()
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        collectionView?.register(UINib.init(nibName: "ContactsMainCell", bundle: nil), forCellWithReuseIdentifier:"ContactsMainCell")
        collectionView?.register(UINib.init(nibName: "ContactsGroupCell", bundle: nil), forCellWithReuseIdentifier:"ContactsGroupCell")
        
        collectionView?.register(UINib.init(nibName: "SectionHeaderView", bundle: nil), forSupplementaryViewOfKind:UICollectionElementKindSectionHeader , withReuseIdentifier: "Header")
        
        let cellSize = CGSize(width: view.frame.width, height: 100)
        
        let layout = UICollectionViewFlowLayout()
        //layout.scrollDirection = .vertical //.horizontal
        layout.itemSize = cellSize
        layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        layout.minimumLineSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0
        collectionView?.setCollectionViewLayout(layout, animated: true)
        
        collectionView?.reloadData()
        
    }
    
    func initVM() {
        viewModel.initFetch()
        
        viewModel.reloadCollectionViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    
    
    
} //class ending

extension ContactListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: UICollectionViewDataSource
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section {
        case 0:
            return CGSize.init(width: screenSize.width, height: 30)
        case 1:
            return CGSize.init(width: screenSize.width, height: 30)
        default:
            return CGSize.init(width: screenSize.width, height: 30)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as? SectionHeaderCell
        switch (indexPath.section) {
            case 0:
                view?.headerNameLabel.text = "Me"
                return view ?? UICollectionReusableView()
            case 1:
                view?.headerNameLabel.text = "Groups"
                return view ?? UICollectionReusableView()
            default:
                view?.headerNameLabel.text = "A  "
                return view ?? UICollectionReusableView()
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
            case 0:
                return 1
            case 1:
                return groups.count
            default:
                return viewModel.numberOfCells
            }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch (indexPath.section) {
            case 0:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContactsMainCell", for: indexPath) as? ContactsMainCell else {
                    fatalError("Cell not exists in storyboard")
                }
                
                cell.contactAvailabiltyStatus.isHidden = true
                cell.callContactButton.isHidden = true
                
                cell.contactNameLabel.text = userName
                cell.contactEmailLabel.text = userEmail
                return cell
            
            case 1:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContactsGroupCell", for: indexPath) as? ContactsGroupCell else {
                    fatalError("Cell not exists in storyboard")
                }
                cell.groupNameLabel.text = groups[indexPath.row]
                return cell
            
            default:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContactsMainCell", for: indexPath) as? ContactsMainCell else {
                    fatalError("Cell not exists in storyboard")
                }
                let cellVM = viewModel.getCellViewModel( at: indexPath )
                cell.configureContactCell(contactMainCellVM: cellVM)
                return cell
            }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            let groupsStoryboard = UIStoryboard.init(name: "Groups", bundle: nil)
            guard let conversationViewController = groupsStoryboard.instantiateViewController(withIdentifier: "GroupsListNewController") as? GroupsListNewController else {
                return
            }
            
            self.parent?.navigationController?.pushViewController(conversationViewController, animated: true)
        case 2:
            let contactStoryboard = UIStoryboard.init(name: "Contact", bundle: nil)
            guard let memberDetailVc = contactStoryboard.instantiateViewController(withIdentifier: "MemberDetailViewController") as? MemberDetailViewController else {
                return
            }
            self.navigationController?.pushViewController(memberDetailVc, animated: true)
        default:
            return
        }
        
    }
}

