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
            dateLabel.text = data.dateOfLastCorrection.dayText
            setFavoriteImage()
            noteText.text = data.text
            
            
        }
    }
    
    private func setFavoriteImage(){
        if data!.highlights == true {
            let image = UIImage(systemName: "heart.fill")
            let colorConfig = UIImage.SymbolConfiguration(paletteColors: [UIColor.accentGreen])
            favoriteView.image = image!.withConfiguration(colorConfig)
        } else {
            let image = UIImage(systemName: "heart")
            let colorConfig = UIImage.SymbolConfiguration(paletteColors: [UIColor.accentGreen])
            favoriteView.image = image!.withConfiguration(colorConfig)
        }
    }
    
    private lazy var cellView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        view.backgroundColor = .accentBeige
        return view
    }()
    
    private lazy var titleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        view.backgroundColor = UIColor.accentWhite
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
    
    private lazy var favoriteView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .center
        return imageView
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .celTitleFont
        label.textColor = .accentGreen
        label.textAlignment = .right
        
        return label
    }()
    
//    private lazy var textView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.layer.masksToBounds = true
//        view.layer.cornerRadius = 10
//        view.backgroundColor = UIColor.accentWhite
//        return view
//    }()
    
    private lazy var noteText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .celTitleFont
        label.textAlignment = .left
        label.numberOfLines = 2
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
        cellView.addSubview(titleView)
        titleView.addSubview(titleLabel)
        cellView.addSubview(titleLabel)
        cellView.addSubview(favoriteView)
        cellView.addSubview(dateLabel)
        cellView.addSubview(noteText)
//        cellView.addSubview(textView)
//        textView.addSubview(noteText)
    }
    
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            cellView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            cellView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            cellView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            titleView.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 10),
            titleView.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 20),
            titleView.heightAnchor.constraint(equalToConstant: 25),
            titleView.widthAnchor.constraint(equalTo: cellView.widthAnchor, multiplier: 3/5),
            
            titleLabel.leftAnchor.constraint(equalTo: titleView.leftAnchor, constant: 5),
            titleLabel.rightAnchor.constraint(equalTo: titleView.rightAnchor, constant: -5),
            titleLabel.centerYAnchor.constraint(equalTo: titleView.centerYAnchor),
            
            favoriteView.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 10),
            favoriteView.rightAnchor.constraint(equalTo: cellView.rightAnchor, constant: -20),
            favoriteView.heightAnchor.constraint(equalToConstant: 20),
            favoriteView.widthAnchor.constraint(equalToConstant: 20),
            
            dateLabel.rightAnchor.constraint(equalTo: cellView.rightAnchor, constant: -20),
            dateLabel.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -10),
            dateLabel.heightAnchor.constraint(equalToConstant: 20),
            dateLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/4),
            
            noteText.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 20),
            noteText.rightAnchor.constraint(equalTo: dateLabel.leftAnchor, constant: -20),
            noteText.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 10),
            noteText.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -10)

//
//            textView.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 20),
//            textView.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -10),
//            textView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
//            textView.rightAnchor.constraint(equalTo: dateLabel.leftAnchor, constant: -10),
//
//            noteText.leftAnchor.constraint(equalTo: textView.leftAnchor, constant: 5),
//            noteText.rightAnchor.constraint(equalTo: textView.rightAnchor, constant: -5),
//            noteText.topAnchor.constraint(equalTo: textView.topAnchor, constant: 5),
//            noteText.bottomAnchor.constraint(equalTo: textView.bottomAnchor, constant: -5)
            
            
        ])
    
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
