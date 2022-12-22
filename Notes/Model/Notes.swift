//
//  Notes.swift
//  Notes
//
//  Created by Ольга Егорова on 21.12.2022.
//

import Foundation

struct NoteModel {
    var title: String
    var dateOfCreation: Date
    var dateOfLastCorrection: Date
    var text: String
    var highlights: Bool = false
    var topics: [String] = []
}


#if DEBUG
extension NoteModel {
    static var sampleData = [
           NoteModel(title: "Принципы ООП", dateOfCreation: Date().addingTimeInterval(-800.0), dateOfLastCorrection: Date().addingTimeInterval(-400.0), text: "Инкапсуляция, наследование, полиморфизм"),
           NoteModel(title: "Swift", dateOfCreation: Date().addingTimeInterval(-68000.0), dateOfLastCorrection: Date().addingTimeInterval(-68000.0), text: "Современный жестко типизированный язык программированния, представленный в 20014 г"),
           NoteModel(title: "Волатильность", dateOfCreation: Date().addingTimeInterval(-3200.0), dateOfLastCorrection: Date().addingTimeInterval(-3200.0), text: "Волатильность - способность изменять значение (переменной). В случае со swift обеспечивается ключевым словом var, в отличие от Obj-C, где требуется определять отдельный мутируемый класс (например NSMutableArray).", highlights: true)
       ]
}
#endif
