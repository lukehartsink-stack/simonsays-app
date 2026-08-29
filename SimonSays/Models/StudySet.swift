import Foundation

struct StudySet: Decodable {
    let title: String
    let subtitle: String
    let parts: [StudyPart]
    let questions: [StudyQuestion]
}

struct StudyPart: Decodable, Identifiable, Hashable {
    let number: Int
    let name: String
    var id: Int { number }
}

struct StudyQuestion: Decodable, Identifiable, Hashable {
    let id: String
    let part: Int
    let handout: String
    let handoutTitle: String
    let q: String
    let options: [String]
    let answer: Int
    let why: String
}
