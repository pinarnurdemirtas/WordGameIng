struct Question: Decodable {
    let englishWord: String
    let options: [String]
    let correctAnswer: String
}
