import UIKit
import CoreML
import Vision

public extension UILabel {
    func isHidden(_ hidden: Bool, animated: Bool = true) {
        UIView.animate(withDuration: animated ? 0.3 : 0) {
            self.transform = hidden ? CGAffineTransform(scaleX: 0.85, y: 0.85) : .identity
            self.alpha = hidden ? 0 : 1
        }
    }
}

public extension UIImage {
    convenience init(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: image!.cgImage!)
    }
    
    public func resize(to newSize: CGSize) -> UIImage? {
        guard self.size != newSize else { return self }
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        
        defer { UIGraphicsEndImageContext() }
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
public class Canvas : UIImageView {
    let π = CGFloat.pi
    
    let forceSensitivity: CGFloat = 4.0
    let minLineWidth: CGFloat = 5
    
    var minX = 0
    var minY = 0
    var maxX = 0
    var maxY = 0
    
    var ocrImageRect: CGRect?
    let defaultLineWidth: CGFloat = 6
    var context: CGContext?
    
    public var tutorialLabel: UILabel!
    
    public func setup() {
        resetRect()
        
        tutorialLabel = {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 320 - 30, height: 320 - 30))
            //label.text = "Touch and pan to\ndraw a number"
            label.numberOfLines = 2
            label.textColor = UIColor.systemGray
            label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            label.textAlignment = .center
            label.isHidden(false, animated: true)
            return label
        }()
        addSubview(tutorialLabel)
    }
    
    func resetRect() {
        minX = Int(self.frame.width)
        minY = Int(self.frame.height)
        
        maxX = 0
        maxY = 0
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        context = UIGraphicsGetCurrentContext()
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else {
            return
        }
        
        image?.draw(in: bounds)
        
        var touches = [UITouch]()
        if let coalescedTouches = event?.coalescedTouches(for: touch) {
            touches = coalescedTouches
        } else {
            touches.append(touch)
        }
        
        for touch in touches {
            drawStroke(context: context, touch: touch)
        }
        
        image = UIGraphicsGetImageFromCurrentImageContext()
        
        tutorialLabel.isHidden(true, animated: true)
        //applyButton.isButtonEnabled(true)
    }
        
    func drawStroke(context: CGContext?, touch: UITouch) {
        let previousLocation = touch.previousLocation(in: self)
        
        var lineWidth: CGFloat = 25.0
        let tiltThreshold: CGFloat = π/6
        
        let location = touch.location(in: self)
        
        minX = min(minX, Int(location.x))
        minY = min(minY, Int(location.y))
        maxX = max(maxX, Int(location.x))
        maxY = max(maxY, Int(location.y))
        
        if touch.altitudeAngle < tiltThreshold {
            lineWidth = lineWidthForShading(context: context, touch: touch)
        } else {
            lineWidth = lineWidthForDrawing(context: context, touch: touch)
        }
        
        
        UIColor.white.setStroke()
        
        context!.setLineWidth(lineWidth)
        context!.setLineCap(.round)
        
        context?.move(to: previousLocation)
        context?.addLine(to: location)
        
        context!.strokePath()
    }
    
    func lineWidthForShading(context: CGContext?, touch: UITouch) -> CGFloat {
        
        let previousLocation = touch.previousLocation(in: self)
        let location = touch.location(in: self)
        
        let vector1 = touch.azimuthUnitVector(in: self)
        
        let vector2 = CGPoint(x: location.x - previousLocation.x, y: location.y - previousLocation.y)
        
        var angle = abs(atan2(vector2.y, vector2.x) - atan2(vector1.dy, vector1.dx))
        
        if angle > π {
            angle = 2 * π - angle
        }
        if angle > π / 2 {
            angle = π - angle
        }
        
        let minAngle: CGFloat = 0
        let maxAngle = π / 2
        let normalizedAngle = (angle - minAngle) / (maxAngle - minAngle)
        
        let maxLineWidth: CGFloat = 60
        var lineWidth = maxLineWidth * normalizedAngle
        
        let tiltThreshold : CGFloat = π/6
        let minAltitudeAngle: CGFloat = 0.25
        let maxAltitudeAngle = tiltThreshold
        
        let altitudeAngle = touch.altitudeAngle < minAltitudeAngle ? minAltitudeAngle : touch.altitudeAngle
        
        let normalizedAltitude = 1 - ((altitudeAngle - minAltitudeAngle) / (maxAltitudeAngle - minAltitudeAngle))
        
        lineWidth = lineWidth * normalizedAltitude + minLineWidth
        
        let minForce: CGFloat = 0.0
        let maxForce: CGFloat = 5
        
        let normalizedAlpha = (touch.force - minForce) / (maxForce - minForce)
        
        context!.setAlpha(normalizedAlpha)
        
        return lineWidth
    }
    
    func lineWidthForDrawing(context: CGContext?, touch: UITouch) -> CGFloat {
        var lineWidth = defaultLineWidth
        
        if touch.force > 0 {
            lineWidth = touch.force * forceSensitivity
        }
        
        return lineWidth
    }
    
    public func clearCanvas(_ animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.alpha = 0
                //applyButton.isButtonEnabled(false)
            }, completion: { finished in
                self.alpha = 1
                self.image = nil
                self.resetRect()
                self.tutorialLabel.isHidden(false, animated: true)
            })
        } else {
            image = nil
            resetRect()
            tutorialLabel.isHidden(false, animated: true)
            //applyButton.isButtonEnabled(false)
        }
    }
}

public class CanvasView: UIView {
    private var requests = [VNRequest]()
    private var classRes : MNISTClassifierOutput?
    public var canvasG : Canvas!
    private var digitDrawn : Int = 0
    public var classificationDigit : Int = 0
    public var delegate : ClassifyDelegate?
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Touches Ended from Canvas")
        detectTapped()
    }
    public func configure() {
        backgroundColor = .black
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.16
        print("Making Canvas")
        canvasG = {
            let canvas = Canvas(frame: CGRect(x: 15, y: 15, width: frame.width, height: frame.height - 100))
            canvas.isUserInteractionEnabled = true
            canvas.setup()
            return canvas
        }()
        addSubview(canvasG)
        let label = UILabel(frame: CGRect(x: 15, y: frame.height-100, width: 50, height: 100))
        label.text = "Ini"
        
        let clearButton = UIButton(frame: CGRect(x: 0, y: frame.height-100, width: frame.width/2, height: 100))
        clearButton.setTitle("Clear", for: .normal)
        clearButton.addTarget(self, action: #selector(self.clearTapped), for: .touchUpInside)
        
        let detectButton = UIButton(frame: CGRect(x: 150, y: frame.height-100, width: frame.width/2, height: 100))
        detectButton.setTitle("Apply", for: .normal)
        detectButton.addTarget(self, action: #selector(self.applyTapped), for: .touchUpInside)
        addSubview(clearButton)
        addSubview(detectButton)
        visionSetup()
    }
    
    
    @objc func clearTapped() {
        canvasG.clearCanvas(true)
        delegate?.clearRes()
    }
    
    @objc func detectTapped() {
        //canvasG.clearCanvas(true)
        
        //let image = UIImage(view: Canvas()).resize(to: CGSize(width: 28, height: 28))
        let image = canvasG.image?.resize(to: CGSize(width: 28, height: 28))
        let imageRequestHandler = VNImageRequestHandler(cgImage: (image?.cgImage)!, options: [:])
        
        do {
            try imageRequestHandler.perform(self.requests)
        } catch {
            print(error)
        }
    }
    
    @objc func applyTapped() {
        detectTapped()
        delegate?.applyRes(res: digitDrawn)
    }
    
    func visionSetup() {
        guard let visionModel = try? VNCoreMLModel(for: MNISTClassifier().model) else { fatalError("Unable to load Vision Model")}
        let classificationRequest = VNCoreMLRequest(model: visionModel, completionHandler: self.classificationHandler)
        classificationRequest.imageCropAndScaleOption = .centerCrop
        self.requests = [classificationRequest]
    }
    
    func classificationHandler(request : VNRequest,error : Error?) {
        guard let observations = request.results else {
                   print("No results")
                   return
        }
               
        let classifications = observations
                   .compactMap({$0 as? VNClassificationObservation})
                   .filter({$0.confidence > 0.3})
                   .map({$0.identifier})
        //print(classifications)
        self.classificationDigit = Int(classifications.first!)!
        delegate?.classRes(res: self.classificationDigit)
        self.digitDrawn = self.classificationDigit
    }
}

