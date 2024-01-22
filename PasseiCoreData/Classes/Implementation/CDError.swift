//
//  CDError.swift
//  PasseiOAB
//
//  Created by Vagner Oliveira on 15/11/23.
//

import Foundation

/// Enumeração que representa erros relacionados ao Core Data.
public enum CDError: Error {

    /// Erro indicando que o campo UUID não está presente.
    case fieldUUIDNotPresent

    /// Erro indicando que o campo de dados não está presente.
    case fieldDataNotPresent

    /// Erro indicando que o campo de timestamps não está presente.
    case fieldTimestampsNotPresent

    /// Erro indicando que a função não está implementada.
    case functionNotImplemented

    /// Erro indicando falha ao obter resultados do Core Data.
    case getResults
}
