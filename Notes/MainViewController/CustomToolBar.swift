//
//  CustomToolBar.swift
//  Notes
//
//  Created by Ольга Егорова on 23.12.2022.
//

import UIKit

class CustomToolBar: UIToolbar {
    
    lazy var buttonsArray: [UIBarButtonItem] = [boldButton, italicButton, colorButton, doneButton] {
        didSet {
            
        }
    }
    
    var textAttributes: [NSAttributedString.Key : Any] = [:]
    
    var imageConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
    
    lazy var boldButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "bold")?.withConfiguration(imageConfig), style: .plain, target: self, action: #selector(boldButtonPressed))
    
    lazy var italicButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "italic")?.withConfiguration(imageConfig), style: .plain, target: self, action: #selector(italicButtonPressed))
    
    lazy var colorButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.fill")?.withConfiguration(imageConfig), style: .plain, target: self, action: #selector(colorButtonPressed))
    
    lazy var doneButton: UIBarButtonItem = UIBarButtonItem(title: "done", style: .plain, target: self, action: #selector(doneButtonPressed))
    
    
    var textView: UITextView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(frame: CGRect, textView: UITextView) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.accentBeige
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.accentGreen.cgColor
        //self.sizeToFit()
        self.textView = textView
        setItems()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setItems () {
        
        self.setItems(buttonsArray, animated: true)
        for button in buttonsArray {
            button.tintColor = UIColor.accentGreen
        }
    }
    
    @objc private func boldButtonPressed(sender: UIBarButtonItem){
        boldButton.isSelected.toggle()
        italicButton.isSelected = false
        if boldButton.isSelected == true {
            textAttributes[NSAttributedString.Key.font] = UIFont.boldSystemFont(ofSize: 18)
        } else {
            textAttributes[NSAttributedString.Key.font] = UIFont.systemFont(ofSize: 18)
        }
        setTextAttribute()
        setTipingTextAttribute()
    
    }
    
    @objc private func italicButtonPressed(sender: UIBarButtonItem){
        italicButton.isSelected.toggle()
        boldButton.isSelected = false
        
        if italicButton.isSelected == true {
            textAttributes[NSAttributedString.Key.font] = UIFont.italicSystemFont(ofSize: 18)
        } else {
            textAttributes[NSAttributedString.Key.font] = UIFont.systemFont(ofSize: 18)
        }
        setTextAttribute()
        setTipingTextAttribute()
    }
    
    
    func setTextAttribute() {
        guard let text = textView else {return}
        let range = text.selectedRange
        let string = NSMutableAttributedString(attributedString: text.attributedText)
        string.addAttributes(textAttributes, range: text.selectedRange)
        text.attributedText = string
        text.selectedRange = range
        
    }
    
    func setTipingTextAttribute() {

        textView?.typingAttributes = textAttributes
        
    }
    
    
    @objc private func colorButtonPressed(sender: UIBarButtonItem){
        sender.isSelected.toggle()
        if sender.isSelected == true {
            setColorAttribute()
        }
    }
    
    private func setColorAttribute() {
        guard let text = textView else {return}
        let range = text.selectedRange
        let string = NSMutableAttributedString(attributedString: text.attributedText)
        let colorAttribute = [
            NSAttributedString.Key.foregroundColor: UIColor.accentRed]
        string.addAttributes(colorAttribute as [NSAttributedString.Key : Any], range: text.selectedRange)
        text.attributedText = string
        text.selectedRange = range
    }
    
    @objc func doneButtonPressed(sender: UIBarButtonItem) {
        textView?.resignFirstResponder()
    }
    

    
}

