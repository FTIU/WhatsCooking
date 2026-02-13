//
//  RecipeDetailsView.swift
//  WhatsCooking
//
//  Created by Floyd Tiu on 2/11/26.
//

import SwiftUI

struct RecipeDetailsView: View {
	let recipe: Recipe
	
	var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 20) {
				// Header Section
				VStack(alignment: .leading, spacing: 12) {
					Text(recipe.title)
						.font(.title)
						.fontWeight(.bold)
					
					Text(recipe.description)
						.font(.body)
						.foregroundColor(.secondary)
					
					// Dietary Attributes
					if !recipe.dietaryClass.isEmpty {
						ScrollView(.horizontal, showsIndicators: false) {
							HStack(spacing: 8) {
								ForEach(recipe.dietaryClass, id: \.self) { `class` in
									HStack(spacing: 4) {
										Text(`class`.icon)
										Text(`class`.rawValue)
											.fontWeight(.semibold)
									}
									.font(.subheadline)
									.padding(.horizontal, 12)
									.padding(.vertical, 6)
									.background(Color.green.opacity(0.15))
									.foregroundColor(.green)
									.cornerRadius(12)
								}
							}
						}
					}
				}
				.padding()
				.background(Color(.systemGray6))
				.cornerRadius(12)
				
				// Quick Info Section
				HStack(spacing: 20) {
					InfoCard(icon: "person.2.fill", title: "Servings", value: "\(recipe.servings)")
					InfoCard(icon: "clock.fill", title: "Prep", value: "\(recipe.prepTime)m")
					InfoCard(icon: "flame.fill", title: "Cook", value: "\(recipe.cookTime)m")
				}
				
				Divider()
				
				// Ingredients Section
				VStack(alignment: .leading, spacing: 12) {
					Text("Ingredients")
						.font(.title2)
						.fontWeight(.bold)
					
					VStack(alignment: .leading, spacing: 8) {
						ForEach(Array(recipe.ingredients.enumerated()), id: \.offset) { index, ingredient in
							HStack(alignment: .top, spacing: 12) {
								Circle()
									.fill(Color.blue)
									.frame(width: 8, height: 8)
									.padding(.top, 6)
								
								Text(ingredient)
									.font(.body)
							}
						}
					}
					.padding()
					.background(Color(.systemGray6))
					.cornerRadius(12)
				}
				
				Divider()
				
				// Instructions Section
				VStack(alignment: .leading, spacing: 12) {
					Text("Instructions")
						.font(.title2)
						.fontWeight(.bold)
					
					VStack(alignment: .leading, spacing: 16) {
						ForEach(Array(recipe.instructions.enumerated()), id: \.offset) { index, instruction in
							HStack(alignment: .top, spacing: 12) {
								ZStack {
									Circle()
										.fill(Color.blue)
										.frame(width: 28, height: 28)
									
									Text("\(index + 1)")
										.font(.subheadline)
										.fontWeight(.bold)
										.foregroundColor(.white)
								}
								
								Text(instruction)
									.font(.body)
									.fixedSize(horizontal: false, vertical: true)
							}
						}
					}
					.padding()
					.background(Color(.systemGray6))
					.cornerRadius(12)
				}
			}
			.padding()
		}
		.navigationBarTitleDisplayMode(.inline)
	}
}

struct InfoCard: View {
	let icon: String
	let title: String
	let value: String
	
	var body: some View {
		VStack(spacing: 8) {
			Image(systemName: icon)
				.font(.title2)
				.foregroundColor(.blue)
			
			Text(title)
				.font(.caption)
				.foregroundColor(.secondary)
			
			Text(value)
				.font(.headline)
				.fontWeight(.semibold)
		}
		.frame(maxWidth: .infinity)
		.padding()
		.background(Color(.systemGray6))
		.cornerRadius(12)
	}
}

struct RecipeDetailView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationView {
			RecipeDetailsView(recipe: Recipe(
				id: UUID(),
				title: "Sample Recipe",
				description: "A delicious sampler for preview",
				servings: 4,
				ingredients: ["1 cup flour", "2 eggs", "1/2 cup milk"],
				instructions: ["Mix ingredients", "Cook for 20 minutes", "Serve hot"],
				dietaryClass: [.vegetarian, .glutenFree],
				imageURL: nil,
				prepTime: 15,
				cookTime: 30
			))
		}
	}
}
