//
//  Extensions.swift
//  Bookworm
//
//  Created by Gavin Butler on 09-08-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import Foundation

extension Date {
    func bookFormat() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        return dateFormatter.string(from: self)
    }
}
