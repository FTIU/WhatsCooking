//
//  RecipeNetworkCall.swift
//  WhatsCooking
//
//  Created by Floyd Tiu on 2/13/26.
//

import Foundation

final class RecipeNetworkCall: RecipeConnection {
	private let bundle: Bundle
	
	init(bundle: Bundle = .main) {
		self.bundle = bundle
	}
	
	func fetchRecipes() async throws -> [Recipe] {
		guard let url = bundle.url(forResource: "RecipeDummyResponse", withExtension: "json") else {
			throw RecipeAPIError.fileNotfound
		}
		
		do {
			let data = try Data(contentsOf: url)
			let response = try JSONDecoder().decode(RecipeResponseContent.self, from: data)
			return response.recipes
		} catch {
			throw RecipeAPIError.decodingFailed(error)
		}
	}
}
