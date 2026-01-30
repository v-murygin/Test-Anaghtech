//
//  FavoriteButton.swift
//  TestAnaghtech
//
//  Created by Vladislav Murygin on 1/30/26.
//

import UIKit
import SwiftUI

struct FavoriteButtonUIKit: UIViewRepresentable {

    let isFavorite: Bool
    let onTap: () -> Void

    func makeUIView(context: Context) -> UIButton {
        let button = UIButton(type: .system)
        button.addTarget(context.coordinator, action: #selector(Coordinator.buttonTapped), for: .touchUpInside)

        var config = UIButton.Configuration.bordered()
        config.cornerStyle = .capsule
        config.imagePadding = 6
        button.configuration = config

        return button
    }

    func updateUIView(_ button: UIButton, context: Context) {
        let imageName = isFavorite ? "heart.fill" : "heart"
        let title = isFavorite ? "Favorited" : "Favorite"
        let tint: UIColor = isFavorite ? .systemRed : .secondaryLabel

        var config = button.configuration
        config?.image = UIImage(systemName: imageName)
        config?.title = title
        config?.baseForegroundColor = tint
        button.configuration = config

        if isFavorite && context.coordinator.previousState == false {
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5) {
                button.imageView?.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            } completion: { _ in
                UIView.animate(withDuration: 0.1) {
                    button.imageView?.transform = .identity
                }
            }
        }

        context.coordinator.previousState = isFavorite
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(onTap: onTap)
    }

    class Coordinator {
        let onTap: () -> Void
        var previousState: Bool = false

        init(onTap: @escaping () -> Void) {
            self.onTap = onTap
        }

        @objc func buttonTapped() {
            onTap()
        }
    }
}
