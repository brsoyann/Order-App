//
//  OrderTableViewController.swift
//  Order App
//
//  Created by Tatevik Brsoyan on 26.10.22.
//

import UIKit

final class OrderTableViewController: UITableViewController {

    var minutesToPrepareOrder = 0
    var imageLoadTasks: [IndexPath: Task<Void, Never>] = [:]

    // MARK: - ViewLifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let tableView = tableView else {
            fatalError()
        }

        navigationItem.leftBarButtonItem = editButtonItem

        NotificationCenter.default.addObserver(
            tableView,
            selector: #selector(UITableView.reloadData),
            name: MenuController.orderUpdatedNotification,
            object: nil
        )
    }

    // MARK: - Table View and Data Source

    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return MenuController.shared.order.menuItems.count
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Order", for: indexPath)

        configure(cell, forItemAt: indexPath)
        return cell
    }

    override func tableView(
        _ tableView: UITableView,
        canEditRowAt indexPath: IndexPath
    ) -> Bool {
        return true
    }

    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            MenuController.shared.order.menuItems.remove(at: indexPath.row)
        }
    }

    // MARK: - Navigation

    @IBSegueAction func confirmOrder(_ coder: NSCoder) -> OrderConfirmationViewController? {
        return OrderConfirmationViewController(coder: coder, minutesToPrepare: minutesToPrepareOrder)
    }

    @IBAction func submitTapped(_ sender: Any) {

        let orderTotal = MenuController.shared.order.menuItems.reduce(0.0) { (result, menuItem) -> Double in
            return result + menuItem.price
        }

        let formattedTotal = orderTotal.formatted(.currency(code: "usd"))

        let alertController = UIAlertController(
            title: "Confirm order",
            message:
                "Do you want to confirm your order with a total price \(formattedTotal)?",
            preferredStyle: .actionSheet)

        alertController.addAction(
            UIAlertAction(
                title: "Submit",
                style: .default,
                handler: { _ in
            self.uploadOrder()
        }))

        alertController.addAction(
            UIAlertAction(
                title: "Cancel",
                style: .cancel,
                handler: nil))

        present(alertController, animated: true, completion: nil)
    }

    @IBAction func unwindToOrderList(segue: UIStoryboardSegue ) {
        if segue.identifier == "dismissConfirmation" {
            MenuController.shared.order.menuItems.removeAll()
        }
    }

    // MARK: - Helpers

    func configure(_ cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        let menuItem = MenuController.shared.order.menuItems[indexPath.row]

        var content = cell.defaultContentConfiguration()
        content.text = menuItem.name
        content.secondaryText = menuItem.price.formatted(.currency(code: "usd"))
        cell.contentConfiguration = content
    }

    func uploadOrder() {
        let menuIDs = MenuController.shared.order.menuItems.map { $0.id }

        Task {
            do {
                let minutesToPrepare = try await MenuController.shared.submitOrder(forMenuIDs: menuIDs)
                minutesToPrepareOrder = minutesToPrepare
                performSegue(withIdentifier: "confirmOrder", sender: nil)
            } catch {
                displayError(error, title: "Order Submission failed")
            }
        }
    }

    func displayError(_ error: Error, title: String) {
        guard viewIfLoaded?.window != nil else { return }
        let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
