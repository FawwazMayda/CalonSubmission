import UIKit

public class DigitRes : UIView {
    private var numLabel : UILabel!
    public override init(frame: CGRect) {
           super.init(frame: frame)
           configure()
    }
       
       required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        //layer.backgroundColor = UIColor.white.cgColor
        //layer.cornerRadius = 50.0
        //layer.borderColor = UIColor.black.cgColor
        //layer.borderWidth = 6.0
        
        numLabel = UILabel(frame: CGRect(x: 15, y: 15, width: frame.width-40, height: frame.height - 40))
        numLabel.text = "B"
        //numLabel.font = UIFont.systemFont(ofSize: 40)
        addSubview(numLabel)
    }
    
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Berhenti disentuh: \(numLabel.text!)")
        
    }
    
    public func setLabel(_ num : Int) {
        numLabel.text = "\(num)"
    }
    
    public func setLabel(_ num : String){
        numLabel.text = num
    }
}
