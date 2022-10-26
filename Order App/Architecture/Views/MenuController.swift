//
//  MenuController.swift
//  Order App
//
//  Created by Tatevik Brsoyan on 26.10.22.
//

import Foundation

final class MenuController {
    let baseURL = URL(string: "http://localhost:8080/")

    func fetchCategories() async throws -> [String] {
        guard let categoriesURL = baseURL?.appendingPathComponent("categories") else { fatalError() }

        let (data, response) = try await URLSession.shared.data(from: categoriesURL)

        guard
            let httpResponse = response as? HTTPURLResponse,
            httpResponse.statusCode == 200
        else {
            throw MenuControllerError.categoriesNotFound
        }

        let decoder = JSONDecoder()
        let categoriesResponse = try decoder.decode(CategoriesResponse.self, from: data)

        return categoriesResponse.categories
    }

    func fetchMenuItems(forCategory categoryName: String) async throws -> [MenuItem] {
        guard let initialMenuURL = baseURL?.appendingPathComponent("menu") else { fatalError() }
        guard var components = URLComponents(url: initialMenuURL, resolvingAgainstBaseURL: true) else { fatalError() }
        components.queryItems = [URLQueryItem(name: "category", value: categoryName)]
        guard let menuURL = components.url else { fatalError() }

        let (data, response) = try await URLSession.shared.data(from: menuURL)

        guard
            let httpResponse = response as? HTTPURLResponse,
            httpResponse.statusCode == 200
        else {
            throw MenuControllerError.menuItemsNotFound
        }

        let decoder = JSONDecoder()
        let menuResponse = try decoder.decode(MenuResponse.self, from: data)

        return menuResponse.items
    }

    typealias MinutesToPrepare = Int

    func submitOrder(forMenuIDs menuIDs: [Int]) async throws -> MinutesToPrepare {
        guard let orderURL = baseURL?.appendingPathComponent("order") else { fatalError() }
        var request = URLRequest(url: orderURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let menuIDsDictionary = ["menuIds": menuIDs]
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(menuIDsDictionary)
        request.httpBody = jsonData

        let (data, response) = try await URLSession.shared.data(for: request)

        guard
            let httpResponse = response as? HTTPURLResponse,
            httpResponse.statusCode == 200
        else {
            throw MenuControllerError.orderRequestFailed
        }

        let decoder = JSONDecoder()
        let orderResponse = try decoder.decode(OrderResponse.self, from: data)

        return orderResponse.prepTime
    }
}

enum MenuControllerError: Error, LocalizedError {
    case categoriesNotFound
    case menuItemsNotFound
    case orderRequestFailed
}
