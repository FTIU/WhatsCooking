//
//  RecipeListView.swift
//  WhatsCooking
//
//  Created by Floyd Tiu on 2/11/26.
//

import SwiftUI

struct RecipeListView: View {
	@StateObject private var viewModel = RecipeViewModel()
	@State private var showingFilters = false
	
	var body: some View {
		NavigationView {
			Group {
				if viewModel.isLoading && viewModel.recipes.isEmpty {
					ProgressView("Loading recipes...")
				} else if let error = viewModel.errorMessage, viewModel.recipes.isEmpty {
					errorView(message: error)
				} else if viewModel.filteredRecipes.isEmpty {
					noResultsView
				} else {
					recipeList
				}
			}
			.navigationTitle("Recipes")
			.searchable(text: $viewModel.searchText, prompt: "Search recipes...")
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					Button(action: { showingFilters = true }) {
						Image(systemName: "line.3.horizontal.decrease.circle")
							.overlay(filterBadge, alignment: .topTrailing)
					}
				}
			}
			.sheet(isPresented: $showingFilters) {
				RecipeFilterView(viewModel: viewModel)
			}
			.task {
				await viewModel.loadRecipes()
			}
			.refreshable {
				await viewModel.loadRecipes()
			}
		}
	}
	
	// MARK: - Recipe List
	
	private var recipeList: some View {
		List(viewModel.filteredRecipes) { recipe in
			NavigationLink(destination: RecipeDetailsView(recipe: recipe)) {
				RecipeRowView(recipe: recipe)
			}
		}
		.listStyle(.plain)
	}
	
	// MARK: - Filter Badge
	
	@ViewBuilder
	private var filterBadge: some View {
		if viewModel.hasActiveFilters {
			Circle()
				.fill(Color.red)
				.frame(width: 8, height: 8)
				.offset(x: 4, y: -4)
		}
	}
	
	// MARK: Error View
	
	private func errorView(message: String) -> some View {
		VStack(spacing: 16) {
			Image(systemName: "exclamationmark.triangle")
				.font(.largeTitle)
				.foregroundColor(.orange)
			
			Text("Something went wrong")
				.font(.headline)
			
			Text(message)
				.font(.subheadline)
				.foregroundColor(.secondary)
				.multilineTextAlignment(.center)
			
			Button("Try Again") {
				Task { await viewModel.loadRecipes() }
			}
			.buttonStyle(.bordered)
		}
		.padding()
	}
	
	// MARK: - No Results
	
	private var noResultsView: some View {
		VStack(spacing: 16) {
			Image(systemName: "magnifyingglass")
				.font(.largeTitle)
				.foregroundColor(.secondary)
			
			Text("No Recipes Found")
				.font(.headline)
			
			Text("Try adjusting your search or filters.")
				.font(.subheadline)
				.foregroundColor(.secondary)
			
			if viewModel.hasActiveFilters {
				Button("Clear Filters") {
					viewModel.clearFilters()
				}
				.buttonStyle(.bordered)
			}
		}
		.padding()
	}
}

struct RecipeListView_Previews: PreviewProvider {
	static var previews: some View {
		RecipeListView()
	}
}

