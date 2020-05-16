import UIKit

public protocol ClassifyDelegate {
    func classRes(res : Any)
    func clearRes()
    func applyRes(res : Any)
}
public class MainVC : UIViewController,ClassifyDelegate {
    private var questionLabel : UILabel!
    private var actualAnswer : String = ""
    private var infoLabel : UILabel!
    private var cvView : CanvasView!
    private var repeatButton : UIButton!
    private var verdictLabel : UILabel!
    private var digitDraw : String = ""
    var currentIndex : Int = 0
    var digitsLabel = [UILabel]()
    var qm = QuesionModel()
    override public func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    public func setup() {
        //Clean up the necessary
        digitDraw = ""
        digitsLabel = []
        currentIndex = 0
        qm.getNextQuesion()
        questionLabel = UILabel()
        questionLabel.textColor = .black
        questionLabel.frame = CGRect(x: 75, y: 20, width: 250, height: 50)
        actualAnswer = qm.correctAnswer
        switch qm.operatorType {
              case .multiplication :
                  //questionLabel.text = "\(qm.num1) x \(qm.num2) == ___? "
                  switch qm.conversionType {
                  case .binary:
                    questionLabel.text = "\(qm.num1) (10) x \(qm.num2) (10) == ___? (2) "
                  default :
                    questionLabel.text = "\(qm.num1) (2) x \(qm.num2) (2) == ___? (10) "
                  }
              case .subtraction :
                  //questionLabel.text = "\(qm.num1) - \(qm.num2) == ___? "
                  switch qm.conversionType {
                  case .binary:
                    questionLabel.text = "\(qm.num1) (10) - \(qm.num2) (10) == ___? (2) "
                  default :
                    questionLabel.text = "\(qm.num1) (2) - \(qm.num2) (2) == ___? (10) "
                  }
              default:
                  //Addition
                  //questionLabel.text = "\(qm.num1) + \(qm.num2) == ___? "
                  switch qm.conversionType {
                  case .binary:
                    questionLabel.text = "\(qm.num1) (10) + \(qm.num2) (10) == ___? (2) "
                  default :
                    questionLabel.text = "\(qm.num1) (2) + \(qm.num2) (2) == ___? (10) "
                  }
        }
        questionLabel.adjustsFontSizeToFitWidth = true
        view.addSubview(questionLabel)
        verdictLabel = UILabel(frame: CGRect(x: 145, y: 120, width: 90, height: 20))
        verdictLabel.adjustsFontSizeToFitWidth = true
        view.addSubview(verdictLabel)
        for i in 0..<actualAnswer.count {
            let tmpLabel = UILabel(frame: CGRect(x: 100+(i*20), y: 50, width: 20, height: 60))
            tmpLabel.text = "?"
            digitsLabel.append(tmpLabel)
            view.addSubview(tmpLabel)
        }
        
        cvView = CanvasView(frame: CGRect(x: 45, y: 150, width: 280, height: 280))
        cvView.delegate = self
        view.addSubview(cvView)
        
        infoLabel = UILabel(frame: CGRect(x: 120, y: 450, width: 200, height: 20))
        infoLabel.text = "No Digit is Drawn"
        view.addSubview(infoLabel)

        repeatButton = UIButton(frame: CGRect(x: 60, y: 480, width: 250, height: 40))
        repeatButton.setTitle("Another Question Please 🙏", for: .normal)
        repeatButton.backgroundColor = .orange
        repeatButton.addTarget(self, action: #selector(repeatQuestion), for: .touchUpInside)
        view.addSubview(repeatButton)
    }
    public func classRes(res : Any) {
        print("Classify res Image: \(res)")
        self.infoLabel.text = "Classified As : \(res)"
    }
    
    public func clearRes() {
        self.infoLabel.text = "No Digit is Drawn"
    }
    
    public func applyRes(res: Any) {
        print("Digit applied: \(res)")
        digitDraw = digitDraw + "\(res)"
        digitsLabel[currentIndex].text = "\(res)"
        currentIndex += 1
        self.cvView.canvasG.clearCanvas(true)
        clearRes()
        if currentIndex==actualAnswer.count {
            if actualAnswer==digitDraw {
                self.verdictLabel.text = "Correct ✌️"
            } else {
                self.verdictLabel.text = "Incorrect 👎"
            }
            return
        }
    }
    
    @objc func repeatQuestion() {
        cvView.removeFromSuperview()
        questionLabel.removeFromSuperview()
        infoLabel.removeFromSuperview()
        verdictLabel.removeFromSuperview()
        for k in digitsLabel {
            k.removeFromSuperview()
        }
        setup()
    }
}
