//
//  LayerExtension.swift
//  SpeakFruit
//
//  Created by Brena Amorim on 22/06/21.
//

import UIKit

extension CALayer {
    func applyShadow(layer: CALayer, shadowColor: CGColor) {
        //Deixando o shadow passar das fronteiras da mascara da layer da contentView da celula
        layer.cornerRadius = 12.0
        layer.shadowColor = shadowColor
        layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        layer.shadowRadius = 8.0
        layer.shadowOpacity = 0.2
    }
}
