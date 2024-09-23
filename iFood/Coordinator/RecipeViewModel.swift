import Foundation

struct RecipeViewModel: Identifiable {
    let id: UUID
    let categoryId: Int
    let title: String
    let instructions: String
    let imageName: String
    let select: (Self) -> Void
}
