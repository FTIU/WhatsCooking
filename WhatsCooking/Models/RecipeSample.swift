//
//  RecipeSample.swift
//  WhatsCooking
//
//  Created by Floyd Tiu on 2/13/26.
//

import Foundation

extension Recipe {
	static let sample = Recipe(
		id: UUID(),
		title: "Sample Recipe",
		description: "A delicious sampler for preview",
		servings: 4,
		ingredients: [
			"1 cup flour",
			"2 eggs",
			"1/2 cup milk",
			"1 tbsp butter"
		],
		instructions: [
			"Mix dry ingredients together",
			"Add wet ingredients and stir until smooth",
			"Cook on medium heat for 20 minutes",
			"Serve hot with your favorite toppings"
		],
		dietaryClass: [.vegetarian, .glutenFree],
		imageURL: nil,
		prepTime: 15,
		cookTime: 30
	)
}
