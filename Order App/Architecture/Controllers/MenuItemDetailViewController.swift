//
//  MenuItemDetailViewController.swift
//  Order App
//
//  Created by Tatevik Brsoyan on 26.10.22.
//

import UIKit

final class MenuItemDetailViewController: UIViewController {

    let menuItem: MenuItem

    init?(coder: NSCoder, menuItem: MenuItem) {
        self.menuItem = menuItem
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) had not been implemented")
    }

    // MARK: - Subviews

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var detailTextLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var addToOrderButton: UIButton!

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    // MARK: - CallBacks

    @IBAction func addToOrderButtonTapped(_ sender: UIButton) {
        UIView.animate(
            withDuration: 0.8,
            delay: 0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 0.1,
            options: [],
            animations: {
                self.addToOrderButton.transform = CGAffineTransform(scaleX: 2.5, y: 2.5)
                self.addToOrderButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            },
            completion: nil)

        MenuController.shared.order.menuItems.append(menuItem)
    }

    // MARK: - Helpers

    func updateUI() {
        nameLabel.text = menuItem.name
        priceLabel.text = menuItem.price.formatted(.currency(code: "usd"))
        detailTextLabel.text = menuItem.detailText

        Task {
            if let image = try? await MenuController.shared.fetchImage(from: menuItem.imageURL) {
                imageView.image = image
            }
        }
    }
}
