//
//  CustomDateFormatter.swift
//  GameCatalog
//
//  Created by admin on 07/11/22.
//

import Foundation

struct CustomDateFormatter {
    static func formatDate(date: String) -> String {
        
        var fixedDate = "unknown"
                
        let formatterOne = DateFormatter()
        formatterOne.dateFormat = "yyyy-mm-dd"

        let formatterTwo = DateFormatter()
        formatterTwo.dateFormat = "dd-mm-yyyy"

        if let dateOne = formatterOne.date(from: date) {
            fixedDate = formatterTwo.string(from: dateOne)
        }
        
        return fixedDate
    }
}
