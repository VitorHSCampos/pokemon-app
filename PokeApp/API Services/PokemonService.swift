//
//  PokemonService.swift
//  PokeApp
//
//  Created by Vitor Campos on 2/4/21.
//

import Foundation
import Combine

class PokemonService {

    typealias JSON = [String: Any]

    var cancellableStorage = Set<AnyCancellable>()

    enum Endpoints {
        case list(limit: Int)
        case info(name: String)

        var url: URL {
            var components = URLComponents(
                url: URL(string: "https://pokeapi.co/api/v2/pokemon")!,
                resolvingAgainstBaseURL: true
            )

            switch self {
            case .list(let limit):
                components?.queryItems = [
                    URLQueryItem(name: "limit", value: "\(limit)")
                ]
            case .info(let name):
                components?.path.append("/\(name)")
                break
            }

            return (components?.url)!
        }
    }


    func getPokemonList(completion: @escaping ([PokemonIndex]) -> ()) {
        let url = Endpoints.list(limit: 100).url
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap(validateAndConvertResponseForList(_:))
            .decode(type: [PokemonIndex].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .eraseToAnyPublisher()
            .sink(receiveValue: { (pokemons) in
                completion(pokemons)
            })
            .store(in: &cancellableStorage)
    }

    func validateAndConvertResponseForList(_ output: URLSession.DataTaskPublisher.Output) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode == 200,
              let jsonData = try JSONSerialization
                .jsonObject(with: output.data,
                            options: .mutableContainers) as? [String: Any]
        else {
            throw URLError(.badServerResponse)
        }

        let pokemons = jsonData["results"]

        return try JSONSerialization.data(withJSONObject: pokemons ?? [])

    }

    func getPokemon(by name: String, completion: @escaping (Pokemon) -> ()) {
        let url = Endpoints.info(name: name).url
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap(validateAndConvertResponseForItem(_:))
            .decode(type: Pokemon.self, decoder: JSONDecoder())
            .replaceError(with: Pokemon())
            .eraseToAnyPublisher()
            .sink { (pokemon) in
                completion(pokemon)
            }
            .store(in: &cancellableStorage)

    }

    func validateAndConvertResponseForItem(_ output: URLSession.DataTaskPublisher.Output) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode == 200,
              let jsonData = try JSONSerialization
                .jsonObject(with: output.data,
                            options: .mutableContainers) as? JSON
        else {
            throw URLError(.badServerResponse)
        }

        var pokemonInfo: [String: Any] = [:]
        pokemonInfo["id"] = jsonData["id"]
        pokemonInfo["name"] = jsonData["name"]

        //Image info
        if let spritesObject = jsonData["sprites"] as? JSON {
            pokemonInfo["image"] = spritesObject["front_default"]
        }

        //Stats
        if let statsArray = jsonData["stats"] as? [JSON] {
            statsArray.forEach { parentStat in
                if let stat = parentStat["stat"] as? JSON {
                    let statValue = parentStat["base_stat"]
                    if let statName = stat["name"] as? String {
                        pokemonInfo[statName] = statValue
                    }
                }
            }
        }

        return try JSONSerialization.data(withJSONObject: pokemonInfo)

    }
    
}
