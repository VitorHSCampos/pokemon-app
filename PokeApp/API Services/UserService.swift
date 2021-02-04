//
//  UserService.swift
//  PokeApp
//
//  Created by Vitor Campos on 2/3/21.
//

import Foundation
import Combine

class UserService {

    let url = URL(string: "https://reqres.in/api/users?page=1")

    var cancellableStorage: AnyCancellable?

    func getUserList(completion: @escaping ([User]) -> ()) {
        self.cancellableStorage = URLSession.shared.dataTaskPublisher(for: url!)
            .tryMap(validateAndConvertResponse(_:))
            .decode(type: [User].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .eraseToAnyPublisher()
            .sink(receiveValue: { (userList) in
                completion(userList)
            })
    }

    func validateAndConvertResponse(_ output: URLSession.DataTaskPublisher.Output) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode == 200,
              let jsonData = try JSONSerialization
                .jsonObject(with: output.data,
                            options: .mutableContainers) as? [String: Any]
        else {
            throw URLError(.badServerResponse)
        }

        let userObjects = jsonData["data"]

        return try JSONSerialization.data(withJSONObject: userObjects ?? [])

    }
    
}
