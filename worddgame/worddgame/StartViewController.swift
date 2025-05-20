import UIKit

class StartViewController: UIViewController {
    
    // Arka planına gradyan verilecek olan view (arayüzde tanımlı)
    @IBOutlet weak var myView11: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI() // Arayüzü ayarlayan fonksiyonu çağır
    }
    
    // Arayüzün görünümünü ayarlayan özel fonksiyon
    func setupUI() {
        // Gradyan katmanı oluşturuluyor
        let gradientLayer = CAGradientLayer()
        
        // Gradyan için renkler tanımlanıyor
        gradientLayer.colors = [
            UIColor(hex: "#4169e1").cgColor, // Royal Blue
            UIColor(hex: "#0000CD").cgColor, // Medium Blue
            UIColor(hex: "#000080").cgColor  // Navy
        ]
        
        // Gradyan yönü aşağıdan yukarıya doğru olacak şekilde ayarlanıyor
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
        
        // Gradyan katmanı, view'ın boyutuna göre yerleştiriliyor
        gradientLayer.frame = myView11.bounds
        
        // Gradyan katmanı, view'ın en altına ekleniyor (arka plan gibi)
        myView11.layer.insertSublayer(gradientLayer, at: 0)
    }

    // "Oyunu Başlat" butonuna tıklandığında çalışacak fonksiyon
    @IBAction func startGameButtonTapped(_ sender: UIButton) {
        // Storyboard'dan ViewController (oyun ekranı) nesnesi oluşturuluyor
        if let viewController = storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController {
            // Navigation Controller üzerinden oyun ekranına geçiş yapılıyor
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
