//
//  MicButton.swift
//  SpeakFruit
//
//  Created by Brena Amorim on 24/06/21.
//

import UIKit

@IBDesignable
class MicButton: UIButton {
    override init(frame: CGRect) {
      super.init(frame: frame)
        self.isEnabled = true
        selected()
    }
    
    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
        self.isEnabled = true
        selected()
    }
    
    fileprivate func selected() {
        self.setBackgroundImage(UIImage(systemName: "mic.fill"), for: .selected)
    }
}
