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
	@Published var servingsFilter: Int? = nil
	@Published var instructionSearch: String = ""
	@Published var includeIngredients: [String] = []
	@Published var excludeIngredients: [String] = []
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
		
		// Servings filter
		if let maxServings = servingsFilter {
			results = results.filter { $0.servings <= maxServings }
		}
		
		// If recipe must have all ingredients listed
		if !includeIngredients.isEmpty {
			results = results.filter { recipe in
				let joined = recipe.ingredients.joined(separator: " ").lowercased()
				return includeIngredients.allSatisfy { joined.contains($0.lowercased()) }
			}
		}
		
		// If recipe must not have ingredients listed
		if !excludeIngredients.isEmpty {
			results = results.filter { recipe in
				let joined = recipe.ingredients.joined(separator: " ").lowercased()
				return !excludeIngredients.contains { joined .contains($0.lowercased()) }
			}
		}
		
		// Search Steps
		if !instructionSearch.isEmpty {
			let query = instructionSearch.lowercased()
			results = results.filter { recipe in
				recipe.instructions.contains { $0.lowercased().contains(query) }
			}
		}
		
		return results
	}
	
	var hasActiveFilters: Bool {
		!selectedDietaryFilters.isEmpty ||
		servingsFilter != nil ||
		!includeIngredients.isEmpty ||
		!excludeIngredients.isEmpty ||
		!instructionSearch.isEmpty
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
		servingsFilter = nil
		includeIngredients.removeAll()
		excludeIngredients.removeAll()
		instructionSearch = ""
		searchText = ""
	}
	
	func addIncludeIngredient(_ text: String) {
		let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
		guard !trimmed.isEmpty, !includeIngredients.contains(trimmed) else { return }
		includeIngredients.append(trimmed)
	}
	
	func addExcludeIngredient(_ text: String) {
		let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
		guard !trimmed.isEmpty, !excludeIngredients.contains(trimmed) else { return }
		excludeIngredients.append(trimmed)
	}
}
