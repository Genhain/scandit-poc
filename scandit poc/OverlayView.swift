//
//  OverlayView.swift
//  scandit poc
//
//  Created by Ben Fowler on 8/7/2022.
//

import UIKit
import FontAwesome_swift
import random_swift

class OverlayView: IBView {
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var iconImage: UIImageView!
  @IBOutlet weak var label: UILabel!
  
  override func initialize() {
    super.initialize()
    
    let name = String(describing: type(of: self))
    let nib = UINib(nibName: name, bundle: .main)
    nib.instantiate(withOwner: self, options: nil)
    
    addSubview(containerView)
    self.containerView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
        containerView.topAnchor.constraint(equalTo: topAnchor),
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
    ])
    
    let icon = FontAwesome.allCases.randomElement()
    iconImage?.image = UIImage.fontAwesomeIcon(
      name: icon!,
      style: .brands,
      textColor: .white,
      size: .init(width: 50, height: 50)
    )
    
    label?.text = .random
  }
  
}

extension String {
  static var random: String {
    (1...10).map { _ in Random.word }.joined(separator: " ")
  }
}
