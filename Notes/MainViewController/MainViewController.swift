//
//  ViewController.swift
//  Notes
//
//  Created by Ольга Егорова on 21.12.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    var notesArray: [NoteModel] = NoteModel.sampleData
    
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
        return button
    }()

    
   private lazy var tableView: UITableView = {
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
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .accentWhite
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NoteCell.self, forCellReuseIdentifier: "cell")
    
        setupHierarhy()
        setupConstraints()
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
            topLabel.widthAnchor.constraint(equalToConstant: 300),
            
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
    
    private func sortNotes (){
        
    }
    
}

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
               cell.translatesAutoresizingMaskIntoConstraints = true
               cell.heightAnchor.constraint(equalToConstant: 120).isActive = true

                   return cell
    }

    
    
}




