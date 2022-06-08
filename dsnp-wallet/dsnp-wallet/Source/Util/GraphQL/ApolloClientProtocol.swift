//
//  ApolloClientProtocol.swift
//  DSNP-Wallet
//
//  Created by Ryan Sheh on 6/3/22.
//

import Foundation
import Apollo

protocol ApolloClientProtocol {
    
    var client: ApolloClient { get }
    
    @discardableResult
    func fetch<Query: GraphQLQuery>(
        query: Query,
        cachePolicy: CachePolicy,
        queue: DispatchQueue,
        resultHandler: GraphQLResultHandler<Query.Data>?) -> Cancellable?
    
    @discardableResult
    func perform<Mutation: GraphQLMutation>(
        mutation: Mutation,
        publishResultToStore: Bool,
        queue: DispatchQueue,
        resultHandler: GraphQLResultHandler<Mutation.Data>?) -> Cancellable?
    
    @discardableResult
    func subscribe<Subscription: GraphQLSubscription>(
        subscription: Subscription,
        queue: DispatchQueue,
        resultHandler: @escaping GraphQLResultHandler<Subscription.Data>) -> Cancellable?
}

extension ApolloClientProtocol {
    
    @discardableResult
    func fetch<Query: GraphQLQuery>(
        query: Query,
        cachePolicy: CachePolicy = .fetchIgnoringCacheData,
        queue: DispatchQueue = .global(),
        resultHandler: GraphQLResultHandler<Query.Data>?) -> Cancellable? {
            self.client.fetch(
                query: query,
                cachePolicy: cachePolicy,
                queue: queue,
                resultHandler: resultHandler)
        }
    
    @discardableResult
    func perform<Mutation: GraphQLMutation>(
        mutation: Mutation,
        publishResultToStore: Bool = false,
        queue: DispatchQueue = .global(),
        resultHandler: GraphQLResultHandler<Mutation.Data>?) -> Cancellable? {
            return client.perform(
                mutation: mutation,
                publishResultToStore: publishResultToStore,
                queue: queue,
                resultHandler: resultHandler)
        }
    
    @discardableResult
    func subscribe<Subscription: GraphQLSubscription>(
        subscription: Subscription,
        queue: DispatchQueue = .global(),
        resultHandler: @escaping GraphQLResultHandler<Subscription.Data>) -> Cancellable? {
            return client.subscribe(
                subscription: subscription,
                resultHandler: resultHandler)
        }
}
