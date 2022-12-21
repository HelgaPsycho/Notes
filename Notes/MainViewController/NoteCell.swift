//
//  NoteCell.swift
//  Notes
//
//  Created by Ольга Егорова on 21.12.2022.
//

import UIKit

class NoteCell: UITableViewCell {
    
    
    
    var data: NoteModel? {
        didSet {
            guard let data = data else {return}
            titleLabel.text = data.title
        }
    }
    
    private lazy var cellView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        view.backgroundColor = .accentWhite
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .celTitleFont
        label.textColor = .accentGray
        label.textAlignment = .left
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupHierarhy()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    private func setupHierarhy() {
        addSubview(cellView)
        cellView.addSubview(titleLabel)
    }
    
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            cellView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            cellView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            cellView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            
            titleLabel.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 10),
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            titleLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/2)
        ])
    
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
