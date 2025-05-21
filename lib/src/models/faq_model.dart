class Faq {
  final String question;
  final String answer;

  Faq({required this.question, required this.answer});

  // Optional: for converting from JSON if loading from API
  factory Faq.fromJson(Map<String, dynamic> json) {
    return Faq(
      question: json['question'] as String,
      answer: json['answer'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'question': question, 'answer': answer};
  }
}
