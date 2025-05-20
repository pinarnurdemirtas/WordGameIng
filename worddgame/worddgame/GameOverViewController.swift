import UIKit

class GameOverViewController: UIViewController {
    
    @IBOutlet weak var gameOverLabel: UILabel!
    @IBOutlet weak var finalScoreLabel: UILabel!
    
    var finalScore: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Game Over mesajını ve skoru göster
        gameOverLabel.text = "Oyun Bitti"
        finalScoreLabel.text = "Toplam Skor: \(finalScore)"
    }
    
    @IBAction func restartGame(_ sender: UIButton) {
        // Tekrar başlat butonuna tıklandığında sadece yeni bir ekran açalım.
        if let viewController = storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
