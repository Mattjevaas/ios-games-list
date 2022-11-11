//
//  ErrorProtocol.swift
//  GameCatalog
//
//  Created by admin on 07/11/22.
//

import Foundation
import UIKit

protocol ErrorDelegate: AnyObject {
    func showError(msg: String)
}
