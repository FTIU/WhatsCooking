//
//  RecipeViewModel.swift
//  WhatsCooking
//
//  Created by Floyd Tiu on 2/11/26.
//

import Foundation
import Combine

@MainActor
class RecipeViewModel: ObservableObject {
	@Published var recipes: [Recipe] = []
	@Published var searchText = ""
	@Published var selectedDietaryFilters: Set<Recipe.DietaryClass> = []
	@Published var isLoading: Bool = false
	@Published var errorMessage: String?
	
	private let service: RecipeConnection
	
	init(service: RecipeConnection = RecipeNetworkCall()) {
		self.service = service
	}
	
	// MARK: - Filtered Recipes

	var filteredRecipes: [Recipe] {
		var results = recipes
		
		// Search for title, description, ingredients and instructions
		if !searchText.isEmpty {
			let query = searchText.lowercased()
			results = results.filter { recipe in
				recipe.title.lowercased().contains(query) ||
				recipe.description.lowercased().contains(query)
			}
		}
		
		// Dietary filter
		if !selectedDietaryFilters.isEmpty {
			results = results.filter { recipe in
				selectedDietaryFilters.isSubset(of: Set(recipe.dietaryClass))
			}
		}
		
		return results
	}
	
	var hasActiveFilters: Bool {
		!selectedDietaryFilters.isEmpty
	}
	
	// MARK: - Actions
	
	func loadRecipes() async {
		isLoading = true
		errorMessage = nil
		
		do {
			recipes = try await service.fetchRecipes()
		} catch {
			errorMessage = error.localizedDescription
		}
		
		isLoading = false
	}
	
	func toggleDietaryFilter(_ class: Recipe.DietaryClass) {
		if selectedDietaryFilters.contains(`class`) {
			selectedDietaryFilters.remove(`class`)
		} else {
			selectedDietaryFilters.insert(`class`)
		}
	}
	
	func clearFilters() {
		selectedDietaryFilters.removeAll()
		searchText = ""
	}
}
