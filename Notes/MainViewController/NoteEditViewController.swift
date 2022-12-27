//
//  NoteEditViewController.swift
//  Notes
//
//  Created by Ольга Егорова on 22.12.2022.
//

import UIKit
import CoreData

class NoteEditViewController: UIViewController {
    var container: NSPersistentContainer!
    
    var dataStoreManager: DataStoreManager?
    var selectedNote: Note? {
        didSet {
            guard var data = selectedNote else {return}
            favoriteButton.isSelected = data.favorites
            titleTextField.text = data.title
            textView.attributedText = data.text
            
        }
    }
    
    
    public weak var delegate: NoteEditControllerDelegate?
    
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
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.backgroundColor = .accentBeige
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.accentGreen.cgColor
        let font = UIFont.segmentalControl
        button.setTitle("back", for: .normal)
        button.titleLabel?.font = font
        button.setTitleColor(.accentWhite, for: .selected)
        button.setTitleColor(.accentGreen, for: .normal)
        var image = UIImage(systemName: "chevron.backward")
        let colorConfig = UIImage.SymbolConfiguration(paletteColors: [UIColor.accentGreen])
        image = image?.withConfiguration(colorConfig)
        button.setImage(image, for: .normal)

        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        var normalImage = UIImage(systemName: "heart")
        var selectImage = UIImage(systemName: "heart.fill")
        
        var config = UIImage.SymbolConfiguration(paletteColors: [UIColor.accentGreen])
        config = config.applying(UIImage.SymbolConfiguration(pointSize: 24, weight: .regular))
        normalImage = normalImage?.withConfiguration(config)
        selectImage = selectImage?.withConfiguration(config)
        
        button.setImage(selectImage, for: .selected)
        button.setImage(normalImage, for: .normal)
        
        button.addTarget(self, action: #selector(favoriteButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private var titleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 10
        textField.backgroundColor = .accentBeige
        textField.font = UIFont.celTitleFont
        textField.textColor = UIColor.accentGray
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
     //   textField.becomeFirstResponder()
                return textField
    }()
    
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .clear
        
        return scrollView
    }()
    
    private var contentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .accentBeige
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var textView: UITextView! = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
    //    textView.layer.cornerRadius = 10
    //    textView.backgroundColor = .accentBeige
        textView.backgroundColor = .clear
        textView.font = UIFont.text
        textView.textColor = UIColor.accentGray
        textView.becomeFirstResponder()
        return textView
    }()
    
    private var bottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemPink
        return view
    }()
    
    private lazy var toolBar: CustomToolBar = CustomToolBar(frame: CGRect(x: 0, y: view.bounds.height, width: UIScreen.main.bounds.width, height: 50), textView: textView)

    
    override func viewDidLoad() {
        super.viewDidLoad()
         loadNote()
        
//        guard container != nil else {
//                    fatalError("This view needs a persistent container.")
           //     }
        
        view.backgroundColor = UIColor.accentWhite
        textView.delegate = self
        titleTextField.delegate = self
        titleTextField.becomeFirstResponder()
        textView.becomeFirstResponder()
        setupElements()
        setupHierarhy()
        setupConstrains()
        // Do any additional setup after loading the view.
    }
    
    private func setupElements() {
        textView.inputAccessoryView = toolBar
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
      //lblk  boldButton.addTarget(self, action: #selector(boldButtonPressed), for: .touchUpInside)
    }
    
    private func setupHierarhy() {
        view.addSubview(topView)
        topView.addSubview(topLabel)
        topView.addSubview(backButton)
        topView.addSubview(favoriteButton)
        view.addSubview(titleTextField)
      //  view.addSubview(scrollView)
       // scrollView.addSubview(contentView)
        view.addSubview(contentView)
        contentView.addSubview(textView)
        contentView.addSubview(bottomView)
        view.addSubview(toolBar)
    }
    
    private func setupConstrains() {
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.heightAnchor.constraint(equalToConstant: 50),
            
            topLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            topLabel.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            topLabel.heightAnchor.constraint(equalToConstant: 40),
            topLabel.widthAnchor.constraint(equalToConstant: 100),
            
            backButton.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            backButton.heightAnchor.constraint(equalToConstant: 40),
            backButton.leftAnchor.constraint(equalTo: topView.leftAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 80),
            
            favoriteButton.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            favoriteButton.rightAnchor.constraint(equalTo: topView.rightAnchor, constant: -30),
            favoriteButton.heightAnchor.constraint(equalToConstant: 40),
            favoriteButton.widthAnchor.constraint(equalToConstant: 40),
            
            titleTextField.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 10),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleTextField.heightAnchor.constraint(equalToConstant: 40),
            
//            scrollView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 10),
//            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//
//            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
//            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
//            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 20),
//            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -20)
            
            contentView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 10),
            contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            
        ])
        
//        let contentViewCenterY = contentView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
//               contentViewCenterY.priority = .defaultLow
//
//               let contentViewHeight = contentView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor)
//               contentViewHeight.priority = .defaultLow
//
//               NSLayoutConstraint.activate([
//                   contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
//                   contentViewCenterY,
//                   contentViewHeight])
        
        toolBar.layoutIfNeeded()
            
        NSLayoutConstraint.activate([
            
           textView.topAnchor.constraint(equalTo: contentView.topAnchor),
           textView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5),
           textView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5),
          // textView.bottomAnchor.constraint(equalTo: toolBar.topAnchor, constant: -20)
           textView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
           
//           bottomView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
//           bottomView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
//           bottomView.heightAnchor.constraint(equalToConstant: 300)
           
           
                                    
        ])
    }
    
    func loadNote(){
       // guard data =
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: - BUTTONS

extension NoteEditViewController {
    
    @objc private func backButtonPressed(sender: UIButton){
        if selectedNote == nil {
            createNote()
            self.delegate?.navigateBackToMainController()
        } else {
            changeNote()
            self.delegate?.navigateBackToMainController()
        }
    }
    
    
    @objc private func favoriteButtonPressed(sender: UIButton){
        favoriteButton.isSelected.toggle()
    }
    

    }

extension NoteEditViewController: UITextFieldDelegate {

    
}

extension NoteEditViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        view.addSubview(toolBar)
    }
}

//MARK: - Data store Manager

extension NoteEditViewController {
    
    func createNote (){
        
        guard (titleTextField.text != "") || (textView.textStorage.string != "") else {return}
        
        let note = Note(context: dataStoreManager!.noteEditContext)
        
        note.title = titleTextField.text
        note.text = textView.textStorage
        note.dateOfCreation = Date.now
        note.dateOfLastCorrection = Date.now
        note.favorites = favoriteButton.isSelected
        
        dataStoreManager!.saveContext()
    }
    
    func changeNote() {
        
        guard let note = selectedNote else {
            return
        }
        note.title = titleTextField.text
        note.text = textView.textStorage
        note.dateOfCreation = selectedNote?.dateOfCreation
        note.dateOfLastCorrection = Date.now
        note.favorites = favoriteButton.isSelected
        
        dataStoreManager!.saveContext()

    }
}


//MARK: - Keyboard
extension NoteEditViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            // if keyboard size is not available for some reason, dont do anything
            return
        }
        
        self.view.frame.origin.y = 0 - keyboardSize.height
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification) {
      // move back the root view origin to zero
      self.view.frame.origin.y = 0
    }
}
