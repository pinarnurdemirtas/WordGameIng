import UIKit

// Model struct: Her bir soru için İngilizce kelime, seçenekler ve doğru cevabı tutar
struct Question: Codable {
    let englishWord: String
    let options: [String]
    let correctAnswer: String
}

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

class ViewController: UIViewController {

    var score = 0  // Kullanıcının toplam skoru
    var currentQuestionIndex = 0  // Şu anki sorunun indeksi
    var timer: Timer?  // Soru için geri sayım timer'ı
    var timeLeft = 10  // Soru için kalan süre (saniye)
    var questions: [Question] = []  // Tüm sorular burada tutulacak

    // UI elementleri
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet var optionButtons: [UIButton]!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var myView2: UIView!
    @IBOutlet weak var myView3: UIView!
    @IBOutlet weak var myView4: UIView!
    @IBOutlet weak var myView5: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true // Geri butonunu gizle
        loadQuestions() // JSON dosyasından soruları yükle
        setupUI()       // UI görünümünü ayarla
        startGame()     // Oyunu başlat
    }
    
    // JSON dosyasından soruları yükler ve karıştırarak ilk 10 soruyu seçer
    func loadQuestions() {
        guard let url = Bundle.main.url(forResource: "questions", withExtension: "json") else {
            print("JSON dosyası bulunamadı.")
            return
        }
        do {
            let data = try Data(contentsOf: url)
            questions = try JSONDecoder().decode([Question].self, from: data)
            questions.shuffle()
            questions = Array(questions.prefix(10)) // İlk 10 soruyu al
        } catch {
            print("JSON yüklenirken hata oluştu: \(error.localizedDescription)")
        }
    }

    // Oyunu sıfırlar, skoru ve soru indeksini başlatır ve ilk soruyu gösterir
    func startGame() {
        score = 0
        currentQuestionIndex = 0
        updateUI()
        startTimer()
    }

    // UI elementlerinin görünümünü ve efektlerini ayarlar
    func setupUI() {
        myView.layer.cornerRadius = 50
        myView.layer.masksToBounds = true
        myView.layer.shadowColor = UIColor.gray.cgColor
        myView.layer.shadowOffset = CGSize(width: 2, height: 2)
        myView.layer.shadowOpacity = 0.5
        myView.layer.shadowRadius = 4

        myView2.layer.cornerRadius = 20
        myView2.layer.masksToBounds = true
        myView2.layer.shadowColor = UIColor.gray.cgColor
        myView2.layer.shadowOffset = CGSize(width: 2, height: 2)
        myView2.layer.shadowOpacity = 0.5
        myView2.layer.shadowRadius = 4

        myView4.layer.cornerRadius = 8
        myView4.layer.masksToBounds = true
        myView5.layer.cornerRadius = 8
        myView5.layer.masksToBounds = true

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(hex: "#4169e1").cgColor,
            UIColor(hex: "#0000CD").cgColor,
            UIColor(hex: "#000080").cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.frame = myView.bounds
        myView.layer.insertSublayer(gradientLayer, at: 0)

        let gradientLayer2 = CAGradientLayer()
        gradientLayer2.colors = [
            UIColor(hex: "#4169e1").cgColor,
            UIColor(hex: "#0000CD").cgColor,
            UIColor(hex: "#000080").cgColor
        ]
        gradientLayer2.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer2.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer2.frame = myView4.bounds
        myView4.layer.insertSublayer(gradientLayer2, at: 0)

        let gradientLayer4 = CAGradientLayer()
        gradientLayer4.colors = [
            UIColor(hex: "#4169e1").cgColor,
            UIColor(hex: "#0000CD").cgColor,
            UIColor(hex: "#000080").cgColor
        ]
        gradientLayer4.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer4.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer4.frame = myView5.bounds
        myView5.layer.insertSublayer(gradientLayer4, at: 0)

        let gradientLayer3 = CAGradientLayer()
        gradientLayer3.colors = [
            UIColor(hex: "#436758").cgColor,
            UIColor(hex: "#4d7665").cgColor,
            UIColor(hex: "#7eab98").cgColor
        ]
        gradientLayer3.startPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer3.endPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer3.frame = myView3.bounds
        myView3.layer.insertSublayer(gradientLayer3, at: 0)
    }

    // Soru için geri sayım başlatır, her saniye timerLabel güncellenir
    func startTimer() {
        timeLeft = 10
        timerLabel.text = "\(timeLeft)"
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }

    // Timer her saniye çağrılır, süre azalır, süre biterse sonraki soruya geçilir
    @objc func updateTimer() {
        timeLeft -= 1
        timerLabel.text = "\(timeLeft)"
        if timeLeft == 0 {
            nextQuestion()
        }
    }

    // UI elementlerini günceller: skor, soru ve seçenekler
    func updateUI() {
        guard questions.indices.contains(currentQuestionIndex) else { return }
        let currentQuestion = questions[currentQuestionIndex]
        
        scoreLabel.text = "\(score)"
        questionLabel.text = "Translate the word: \(currentQuestion.englishWord)"
        
        // Seçenek butonlarına metin atanır, kullanılmayan butonlar gizlenir
        for (index, button) in optionButtons.enumerated() {
            if index < currentQuestion.options.count {
                button.setTitle(currentQuestion.options[index], for: .normal)
                button.isHidden = false
            } else {
                button.isHidden = true
            }
        }
    }

    // Kullanıcı bir seçeneğe tıkladığında çağrılır
    @IBAction func optionSelected(_ sender: UIButton) {
        guard questions.indices.contains(currentQuestionIndex),
              let selectedAnswer = sender.titleLabel?.text else { return }
        
        let correctAnswer = questions[currentQuestionIndex].correctAnswer
        
        // Doğruysa skor 10 puan artar
        if selectedAnswer == correctAnswer {
            score += 10
        }
        nextQuestion() // Sonraki soruya geç
    }

    // Sonraki soruya geçiş işlemi
    func nextQuestion() {
        timer?.invalidate() // Önceki timer iptal edilir
        currentQuestionIndex += 1
        
        if currentQuestionIndex >= questions.count {
            // Sorular bitince oyun sonu gösterilir
            showGameOverAlert()
        } else {
            updateUI()
            startTimer()
        }
    }

    // Oyun bitince kullanıcıya toplam skoru gösteren alert
    func showGameOverAlert() {
        let alert = UIAlertController(
            title: "Oyun Bitti",
            message: "Toplam Skorunuz: \(score)",
            preferredStyle: .alert
        )
        // Tekrar başlatma seçeneği
        let restartAction = UIAlertAction(title: "Tekrar Başla", style: .default) { _ in
            self.startGame()
        }
        alert.addAction(restartAction)
        present(alert, animated: true, completion: nil)
    }
}
