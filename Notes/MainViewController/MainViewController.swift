//
//  ViewController.swift
//  Notes
//
//  Created by Ольга Егорова on 21.12.2022.
//

import UIKit
import CoreData

class MainViewController: UIViewController {
    
    var container: NSPersistentContainer!
    var dataStoreManager = DataStoreManager()
    
    public weak var delegate: MainViewControllerDelegate?
    
    var notesArray: [Note] = []
    
    private lazy var topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var topLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .accentGray
        label.textAlignment = .center
        label.font = .topTitleFont
        label.text = "Notes"
        return label
    }()
    
    private lazy var customSegmentedControl: UIView = {
        let control = UIView()
        control.translatesAutoresizingMaskIntoConstraints = false
        control.layer.masksToBounds = true
        control.layer.cornerRadius = 10
        control.layer.borderColor = UIColor.accentGreen.cgColor
        control.layer.borderWidth = 2
        control.backgroundColor = .accentBeige
        return control
    }()
    
    private var segmentedControlButtonsArray: [UIButton] = []
    
    private lazy var allNotesButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.backgroundColor = .accentBeige
        let font = UIFont.segmentalControl
        button.setTitle("All Notes", for: .normal)
        button.titleLabel?.font = font
        button.setTitleColor(.accentWhite, for: .selected)
        button.setTitleColor(.accentGreen, for: .normal)
        segmentedControlButtonsArray.append(button)
        button.addTarget(self, action: #selector(segmentedControlDidSelect), for: .touchUpInside)
        return button
    }()
    
    private lazy var favoritesButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        //  button.backgroundColor = .accentGreen
        let font = UIFont.segmentalControl
        button.setTitle("Favorites", for: .normal)
        button.titleLabel?.font = font
        button.setTitleColor(.accentWhite, for: .selected)
        button.setTitleColor(.accentGreen, for: .normal)
        segmentedControlButtonsArray.append(button)
        button.addTarget(self, action: #selector(segmentedControlDidSelect), for: .touchUpInside)
        button.addTarget(self, action: #selector(favoritesButtonPressed), for: .touchUpInside)
        return button
    }()
    
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        return tableView
    }()
    
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 30
        button.backgroundColor = .accentGreen
        var image = UIImage(systemName: "plus")
        var config = UIImage.SymbolConfiguration(paletteColors: [UIColor.accentWhite])
        config = config.applying(UIImage.SymbolConfiguration(pointSize: 30, weight: .regular))
        image = image?.withConfiguration(config)
        button.setImage(image, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.widthAnchor.constraint(equalToConstant: 60).isActive = true
        button.addTarget(self, action: #selector(plusButtonPressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        guard container != nil else {
        //                    fatalError("This view needs a persistent container.")
        //                }
        
        //        for family in UIFont.familyNames.sorted() {
        //            let names = UIFont.fontNames(forFamilyName: family)
        //            print("Family: \(family) Font names: \(names)")
        //        }
        
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .accentWhite
        
        dataStoreManager.subscribe(subscriber: self)
        
        allNotesButton.isSelected = true
        allNotesButton.backgroundColor  = UIColor.accentGreen
        loadNotes()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NoteCell.self, forCellReuseIdentifier: "cell")
        
        setupHierarhy()
        setupConstraints()
        print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")
    }
    
    private func setupHierarhy(){
        view.addSubview(topView)
        topView.addSubview(topLabel)
        view.addSubview(customSegmentedControl)
        customSegmentedControl.addSubview(allNotesButton)
        customSegmentedControl.addSubview(favoritesButton)
        view.addSubview(tableView)
        view.addSubview(addButton)
        addButton.superview?.bringSubviewToFront(addButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.heightAnchor.constraint(equalToConstant: 50),
            
            topLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            topLabel.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            topLabel.heightAnchor.constraint(equalToConstant: 40),
            topLabel.widthAnchor.constraint(equalToConstant: 100),
            
            customSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            customSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            customSegmentedControl.heightAnchor.constraint(equalToConstant: 40),
            customSegmentedControl.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 10),
            
            allNotesButton.heightAnchor.constraint(equalToConstant: 40),
            allNotesButton.leftAnchor.constraint(equalTo: customSegmentedControl.leftAnchor),
            allNotesButton.centerYAnchor.constraint(equalTo: customSegmentedControl.centerYAnchor),
            allNotesButton.widthAnchor.constraint(equalTo: customSegmentedControl.widthAnchor, multiplier: 1/2),
            
            favoritesButton.heightAnchor.constraint(equalToConstant: 40),
            favoritesButton.rightAnchor.constraint(equalTo: customSegmentedControl.rightAnchor),
            favoritesButton.centerYAnchor.constraint(equalTo: customSegmentedControl.centerYAnchor),
            favoritesButton.widthAnchor.constraint(equalTo: customSegmentedControl.widthAnchor, multiplier: 1/2),
            
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: customSegmentedControl.bottomAnchor, constant: 10),
            
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40)
        ])
        
    }
    
    
}

// MARK: - BUTTONS

extension MainViewController {
    
    @objc func segmentedControlDidSelect (sender: UIButton){
        for button in segmentedControlButtonsArray {
            button.isSelected = false
            button.backgroundColor = UIColor.accentBeige
        }
        sender.isSelected = true
        sender.backgroundColor = UIColor.accentGreen
    }
    
    @objc func favoritesButtonPressed(sender: UIButton) {
        loadFavoritesNotes()
        updateTableView()
        
        
    }
    
    private func sortNotes (){
        
    }
    
    @objc func plusButtonPressed(sender: UIButton) {
        self.delegate?.navigateToNoteEditViewController()
    }
    
}

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.delegate?.navigateToNoteEditViewController()
        //tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? NoteCell else {fatalError("could not dequeueReusableCell")}
        cell.data = self.notesArray[indexPath.row]
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        cell.translatesAutoresizingMaskIntoConstraints = true
        cell.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            let indexOfArrayElement: Int = Int(indexPath.row)
            do { let note = try dataStoreManager.obtainNote(dateOfCreation: notesArray[indexOfArrayElement].dateOfCreation!)
                dataStoreManager.deleteNote(note: note)
            }
            catch { print ("ERROR in TablieViewController with cell delete")}
            
            self.notesArray.remove(at: indexOfArrayElement)
            self.tableView.deleteRows(at: [indexPath], with: .top)
        }
        
        
    }
}

// MARK: - COREDATA
extension MainViewController {
    func loadNotes() {
        do {
            notesArray = try dataStoreManager.obtainNotes()
        } catch {
            return
        }
    }
    
    func loadFavoritesNotes() {
        do {
            notesArray = try dataStoreManager.obtainFavoriteNotes()
        } catch {
            return
        }
    }
    
}


