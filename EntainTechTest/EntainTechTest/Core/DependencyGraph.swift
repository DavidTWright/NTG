//
//  DependencyGraph.swift
//  EntainTechTest
//
//  Created by David Wright on 25/4/2025.
//

import Foundation

protocol DependencyGraph {
    var repositories: RepositoryProvider { get }
    var useCases: UseCaseProvider { get }
}

final class DependencyGraphImpl: DependencyGraph {
    lazy var repositories: RepositoryProvider = Repositories()
    lazy var useCases: UseCaseProvider = UseCases(repositories: repositories)
}

protocol RepositoryProvider {
    var raceDataRespository: RacesDataRepository { get }
}

protocol UseCaseProvider {
    var getRaceDataUseCase: GetRacesDataUseCase { get }
}

final class Repositories: RepositoryProvider {
    lazy var raceDataRespository: RacesDataRepository = RacesDataRepositoryImpl(
        raceDataEndpoint: RacesDataEndpoint(),
        networking: NetworkingImpl(),
        responseMapper: ResponseMapper()
    )
}

final class UseCases: UseCaseProvider {
    private let repositories: RepositoryProvider
    var getRaceDataUseCase: GetRacesDataUseCase {
        GetRacesDataUseCaseImpl(racesDataRepository: repositories.raceDataRespository)
    }

    init(repositories: RepositoryProvider) {
        self.repositories = repositories
    }
}
