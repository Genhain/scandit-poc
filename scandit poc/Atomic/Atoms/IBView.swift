//
//  IBView.swift
//  scandit poc
//
//  Created by Ben Fowler on 8/7/2022.
//

import UIKit

class IBView: UIView {

    init() {
        super.init(frame: .zero)

        self.initialize()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.initialize()
    }

    func initialize() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
