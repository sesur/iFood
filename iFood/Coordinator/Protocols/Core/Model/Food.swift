import Foundation

struct Food: Codable {
    let categories: [FoodCategory]
    let recipes: [Recipe]
}
