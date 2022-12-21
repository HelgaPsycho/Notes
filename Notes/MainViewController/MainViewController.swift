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
        label.textColor = .accentWhite
        label.textAlignment = .center
        label.font = .topTitleFont
        label.text = "Notes"
        return label
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
        button.backgroundColor = .accentBeige
        var image = UIImage(systemName: "plus")
        let colorConfig = UIImage.SymbolConfiguration(paletteColors: [UIColor.accentGreen])
        image = image!.withConfiguration(colorConfig)
        button.setImage(image, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.widthAnchor.constraint(equalToConstant: 60).isActive = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .accentGreen
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NoteCell.self, forCellReuseIdentifier: "cell")
    
        setupHierarhy()
        setupConstraints()
    }
  
    private func setupHierarhy(){
        view.addSubview(topView)
        topView.addSubview(topLabel)
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
            
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40)
        ])
        
    }
    

}

extension MainViewController: UITableViewDelegate {
    
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
               cell.heightAnchor.constraint(equalToConstant: 150).isActive = true

                   return cell
    }
    
    
}





