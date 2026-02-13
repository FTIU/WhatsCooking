//
//  RecipeFilterView.swift
//  WhatsCooking
//
//  Created by Floyd Tiu on 2/11/26.
//

import SwiftUI

struct RecipeFilterView: View {
	@ObservedObject var viewModel: RecipeViewModel
	@Environment(\.presentationMode) var presentationMode
	
	var body: some View {
		NavigationView {
			List {
				Section(header: Text("Dietary Preferences")) {
					ForEach(Recipe.DietaryClass.allCases, id: \.self) { `class` in
						Button(action: {
							viewModel.toggleDietaryFilter(`class`)
						}) {
							HStack {
								Text(`class`.icon)
									.font(.title3)
								
								Text(`class`.rawValue)
									.foregroundColor(.primary)
								
								Spacer()
								
								if viewModel.selectedDietaryFilters.contains(`class`) {
									Image(systemName: "checkmark.circle.fill")
										.foregroundColor(.blue)
								} else {
									Image(systemName: "circle")
										.foregroundColor(.gray)
								}
							}
							.contentShape(Rectangle())
						}
						.buttonStyle(PlainButtonStyle())
					}
				}
				
				if !viewModel.selectedDietaryFilters.isEmpty {
					Section {
						Button(action: {
							viewModel.clearFilters()
						}) {
							HStack {
								Spacer()
								Text("Clear All Filters")
									.foregroundColor(.red)
									.fontWeight(.semibold)
								Spacer()
							}
						}
					}
				}
			}
			.navigationTitle("Filters")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					Button("Done") {
						presentationMode.wrappedValue.dismiss()
					}
				}
			}
		}
	}
}

struct FilterView_Previews: PreviewProvider {
	static var previews: some View {
		RecipeFilterView(viewModel: RecipeViewModel())
	}
}
