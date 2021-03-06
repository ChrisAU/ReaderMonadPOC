//
//  Try.swift
//  Core
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation

//sourcery:prism
/// Wraps do-try-catch logic
public enum Try<T> {
    case success(T)
    case failure(Error)

    public init(f: () throws -> T) {
        do {
            self = .success(try f())
        } catch {
            self = .failure(error)
        }
    }

    public enum TryError: Error {
        case throwError
    }

    public func didFail() -> Bool {
        return Try.prism.failure.isCase(self)
    }

    public func didSucceed() -> Bool {
        return Try.prism.success.isCase(self)
    }

    public static func `throw`() -> Try<T> {
        return .init { throw TryError.throwError }
    }
    
    public func map<U>(_ f: @escaping (T) -> U) -> Try<U> {
        switch self {
        case .success(let value): return .success(f(value))
        case .failure(let error): return .failure(error)
        }
    }

    public func flatMap<U>(_ f: @escaping (T) -> Try<U>) -> Try<U> {
        switch self {
        case .success(let value): return f(value)
        case .failure(let error): return .failure(error)
        }
    }

    public func result<E>(_ f: @escaping (Error) -> E) -> Result<T, E> {
        switch self {
        case .success(let value): return .success(value)
        case .failure(let error): return .failure(f(error))
        }
    }

    public func result<E>(_ e: E) -> Result<T, E> {
        switch self {
        case .success(let value): return .success(value)
        case .failure: return .failure(e)
        }
    }

    public func materialize() -> T? {
        return Try.prism.success.preview(self)
    }
}

extension Try where T: OptionalType {
    public func throwIfNull() -> Try<T.Wrapped> {
        switch self {
        case .success(let v): return v.value == nil ? .throw() : .success(v.value!)
        case .failure(let e): return .failure(e)
        }
    }
}
