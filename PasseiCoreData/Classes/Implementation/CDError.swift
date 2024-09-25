//
//  CDError.swift
//  PasseiOAB
//
//  Created by Vagner Oliveira on 15/11/23.
//

import Foundation

/// Enumeração que representa erros relacionados ao Core Data.
public enum CDError: LocalizedError {

    /// Erro indicando que o campo UUID não está presente.
    case fieldUUIDNotPresent

    /// Erro indicando que o campo de dados não está presente.
    case fieldDataNotPresent

    /// Erro indicando que o campo de timestamps não está presente.
    case fieldTimestampsNotPresent

    /// Erro indicando que a função não está implementada.
    case functionNotImplemented(String)

    /// Erro indicando falha ao obter resultados do Core Data.
    case getResults
    
    public var errorDescription: String? {
        switch self {
        case .fieldUUIDNotPresent:
            return "Campo UUID não está presente"
        case .fieldDataNotPresent:
            return "campo de dados não está presente"
        case .fieldTimestampsNotPresent:
            return "Campo de timestamps não está presente."
        case .functionNotImplemented(let model):
            return "Função não está implementada, model: \(model)"
        case .getResults:
            return "Falha ao obter resultados do Core Data"
        }
    }
}
