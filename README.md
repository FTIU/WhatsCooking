# 🍳 WhatsCooking

An iOS recipe browsing app built using **SwiftUI** and the **MVVM** architecture. Browse, search, and filter recipes by your dietary preference! Using a mock API layer that can later be used for a real backend with no ViewModel changes!

## Table of Contents

- [Setup Instructions](#setup-instructions)
- [Architecture Overview](#architecture-overview)
- [Project Structure](#project-structure)
- [Key Design Decisions](#key-design-decisions)
- [Assumptions and Tradeoffs](#assumptions-and-tradeoffs)
- [Known Limitations](#known-limitations)

--- 

## Setup Instructions

### Requirements

| Tools | Version |
|------|---------|
| Xcode | 26.0+ |
| iOS Device | 26.2 |
| Swift | 5.0 |

### Getting Started

1. Clone the repository:
   ```bash
   git clone https://github.com/FTIU/WhatsCooking.git
   ```
2. Open the project in Xcode.
3. Select a simulator or connected device running iOS 26.2+.
4. Build and run! (**⌘R**)

No third-party dependencies or package managers are required.

### Previews

Every view file includes a `PreviewProvider` allowing developers to open any view using the SwiftUI canvas in the editor without having to run the app.

---

## Architecture Overview

The app follows the **MVVM (Model-View-ViewModel)** pattern with a protocol-based service layer:

<img src="https://github.com/user-attachments/assets/c613696c-1976-4cf4-b46d-62caf1680c87" width="300">

### Data Flow

1. `RecipeListView` starts → `.task` calls `viewModel.loadRecipes()`.
2. `RecipeViewModel` calls `service.fetchRecipes()` through the `RecipeConnection` protocol.
3. `RecipeNetworkCall` loads and decodes `RecipeDummyResponse.json`, returning `[Recipe]`.
4. The ViewModel stores recipes in `@Published var recipes`, which triggers a UI update.
5. `filteredRecipes` applies all active search and filter criteria.
6. Views updates automatically whenever any `@Published` property changes.

--- 

## Project Structure

<img src="https://github.com/user-attachments/assets/8e6e11c0-3ebd-420a-8b69-da2ac1a54ddb">

---
## Key Design Decisions

### Protocol-Based Service Layer

`RecipeConnection` is a protocol. The ViewModel depends on this — not the `RecipeNetworkCall` implementation.

This enables swapping the mock for a real `URLSession`-based service by changing a single default parameter in the ViewModel initializer. No other code changes are needed.

```swift
// Change RecipeNetworkCall()
init(service: RecipeConnection = RecipeNetworkCall())
```

### Computed `filteredRecipes` Instead of Stored Property

The filtered results are a computed property that derives from `recipes` array and all filter inputs, rather than a separate `@Published` array that must be manually recalculated.

Any change to `searchText`, `selectedDietaryFilters`, or any other `@Published` input triggers a view re-render, which naturally recomputes `filteredRecipes`. This removes the need for manual synchronization and future bugs.

### Set for Dietary Filters

`selectedDietaryFilters` is a `Set<DietaryClass>` rather than an `Array`.

Sets prevent duplicates and provide faster lookups. They also enable isSubset(of:), which cleanly checks that all selected filters exist in a recipe's attributes.

### Nested DietaryClass Enum

`DietaryClass` is defined inside `Recipe` rather than as a top-level type.

It scopes the enum to where it's semantically relevant (`Recipe.DietaryClass`) and prevents naming conflicts. The `CaseIterable` conformance drives the filter list — `Recipe.DietaryClass.allCases` provides every option automatically.

---

## Assumptions and Tradeoffs

### Assumptions

- **Local-only data:** The app assumes all recipe data is bundled locally. The mock service and response model are structured to mirror a paginated REST API (`totalCount`, `page`, `pageSize`), so the transition to a live backend would be straightforward.
- **No authentication:** The app has no user accounts, saved favorites, or personalized content.
- **No images:** `imageURL` exists in the model but is unused in the views. This allows the app to be ready for image use.

### Tradeoffs

| Decision | Benefit | Cost |
|----------|---------|------|
| MVVM over MVC | Clean separation, testable ViewModel | Slightly more repetitive code for a small app |
| Computed `filteredRecipes` | Auto-updates | Recomputes on every state change |
| Single ViewModel shared across views | Simple state sharing | Could grow large if features expand significantly |

---

## Known Limitations

- **No image support** — The `imageURL` model property is present but not rendered.
- **No search debouncing** — `filteredRecipes` recomputes on every keystroke.
- **No persistence** — Recipes exist only in memory.
- **No unit tests** — The protocol-based architecture is designed for testability, but tests have not been written yet.
- **No accessibility tuning** — Emoji-based dietary icons may not convey meaning to VoiceOver users.
