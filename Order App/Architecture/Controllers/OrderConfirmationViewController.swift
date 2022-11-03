//
//  OrderConfirmationViewController.swift
//  Order App
//
//  Created by Tatevik Brsoyan on 29.10.22.
//

import UIKit

final class OrderConfirmationViewController: UIViewController {

    let minutesToPrepare: Int

    // MARK: - Subviews

    @IBOutlet var confirmationLabel: UILabel!

    // MARK: - LifeCycle

    init?(coder: NSCoder, minutesToPrepare: Int) {
        self.minutesToPrepare = minutesToPrepare
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - ViewLifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        confirmationLabel.text = "Thank you for your order, after \(minutesToPrepare) minutes it will be ready"
    }
}
