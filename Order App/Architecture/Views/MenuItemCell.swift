//
//  MenuItemCell.swift
//  Order App
//
//  Created by Tatevik Brsoyan on 29.10.22.
//

import Foundation
import UIKit

final class MenuItemCell: UITableViewCell {

    var itemName: String? {
        didSet {
            if oldValue != itemName {
                setNeedsUpdateConfiguration()
            }
        }
    }

    var price: Double? {
        didSet {
            if oldValue != price {
                setNeedsUpdateConfiguration()
            }
        }
    }

    var image: UIImage? {
        didSet {
            if oldValue != image {
                setNeedsUpdateConfiguration()
            }
        }
    }

    override func updateConfiguration(using state: UICellConfigurationState) {
        var content = defaultContentConfiguration().updated(for: state)
        content.text = itemName
        content.secondaryText = price?.formatted(.currency(code: "usd"))
        content.prefersSideBySideTextAndSecondaryText = true

        if let image = image {
            content.image = image
        } else {
            content.image = UIImage(systemName: "photo.on.rectangle")
        }
        self.contentConfiguration = content
    }
}
