//
//  Recipe.swift
//  WhatsCooking
//
//  Created by Floyd Tiu on 2/11/26.
//

import Foundation

struct Recipe: Identifiable, Codable {
	let id: UUID
	let title: String
	let description: String
	let servings: Int
	let ingredients: [String]
	let instructions: [String]
	let dietaryClass: [DietaryClass]
	let imageURL: String?
	let prepTime: Int
	let cookTime: Int
	
	enum DietaryClass: String, Codable, CaseIterable {
		case vegetarian = "Vegetarian"
		case vegan = "Vegan"
		case glutenFree = "Gluten-Free"
		case dairyFree = "Dairy-Free"
		case nutFree = "Nut-Free"
		case lowCarb = "Low-Carb"
		case keto = "Keto"
		case paleo = "Paleo"
		
		var icon: String {
			switch self {
			case .vegetarian: 
				return "🥬"
				
			case .vegan: 
				return "🌱"
				
			case .glutenFree:
				return "🌾"
				
			case .dairyFree: 
				return "🥛"
				
			case .nutFree: 
				return "🥜"
				
			case .lowCarb: 
				return "🥗"
				
			case .keto: 
				return "🥑"
				
			case .paleo:
				return "🍖"
			}
		}
		
	}
}
