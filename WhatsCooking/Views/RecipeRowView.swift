//
//  RecipeRowView.swift
//  WhatsCooking
//
//  Created by Floyd Tiu on 2/11/26.
//

import SwiftUI

struct RecipeRowView: View {
	let recipe: Recipe
	
	var body: some View {
		VStack(alignment: .leading, spacing: 8) {
			// Title
			Text(recipe.title)
				.font(.headline)
				.foregroundColor(.primary)
			
			// Description
			Text(recipe.description)
				.font(.subheadline)
				.foregroundStyle(.secondary)
				.lineLimit(2)
			
			// Metadata Row
			HStack(spacing: 16) {
				// Servings
				HStack(spacing: 4) {
					Image(systemName: "person.2.fill")
						.font(.caption)
					Text("\(recipe.servings) servings")
						.font(.caption)
				}
				
				// Time
				HStack(spacing: 4) {
					Image(systemName: "clock.fill")
						.font(.caption)
					Text("\(recipe.prepTime + recipe.cookTime) min")
						.font(.caption)
				}
				
				Spacer()
			}
			.foregroundStyle(.secondary)
			
			// Dietary Attributes
			if !recipe.dietaryClass.isEmpty {
				ScrollView(.horizontal, showsIndicators: false) {
					HStack(spacing: 6) {
						ForEach(recipe.dietaryClass, id: \.self) { `class` in
							HStack(spacing: 3) {
								Text(`class`.icon)
									.font(.system(size: 10))
								Text(`class`.rawValue)
									.font(.system(size: 10))
									.fontWeight(.medium)
							}
							.padding(.horizontal, 8)
							.padding(.vertical, 4)
							.background(Color.green.opacity(0.1))
							.foregroundColor(.green)
							.cornerRadius(8)
						}
					}
				}
			}
		}
		.padding(.vertical, 8)
	}
}

struct RecipeRowView_Previews: PreviewProvider {
	static var previews: some View {
		RecipeRowView(recipe: Recipe(
			id: UUID(),
			title: "Sample Recipe",
			description: "A delicious Sampler for preview",
			servings: 4,
			ingredients: ["Ing 1", "Ing 2"],
			instructions: ["Step 1", "Step 2"],
			dietaryClass: [.vegetarian, .glutenFree],
			imageURL: nil,
			prepTime: 15,
			cookTime: 30
		))
		.padding()
		.previewLayout(PreviewLayout.sizeThatFits)
	}
}
