//
//  RecipeConnection.swift
//  WhatsCooking
//
//  Created by Floyd Tiu on 2/13/26.
//

import Foundation

protocol RecipeConnection {
	func fetchRecipes() async throws -> [Recipe]
}

// MARK: - API Errors

enum RecipeAPIError: LocalizedError {
	case fileNotfound
	case decodingFailed(Error)
	
	var errorDescription: String? {
		switch self {
		case .fileNotfound:
			return "Recipe data file not found."
			
		case .decodingFailed(let error):
			return "Failed to decode recipes: \(error.localizedDescription)"
		}
	}
}
