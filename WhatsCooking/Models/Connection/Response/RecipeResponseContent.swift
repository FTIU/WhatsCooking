//
//  RecipeResponseContent.swift
//  WhatsCooking
//
//  Created by Floyd Tiu on 2/13/26.
//

import Foundation

struct RecipeResponseContent: Codable {
	let recipes: [Recipe]
	let totalCount: Int
	let page: Int
	let pageSize: Int
}
