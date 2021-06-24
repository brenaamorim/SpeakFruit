//
//  ViewController.swift
//  SpeakFruit
//
//  Created by Brena Amorim on 22/06/21.
//

import UIKit
import AVFoundation
import Speech

class FruitsViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var fruitImage: UIImageView!
    
    @IBOutlet weak var answerView: UIView!
    
    @IBOutlet weak var answerLabel: UILabel!
    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var verifierImage: UIImageView!
    
    @IBOutlet weak var correctAnswers: UILabel!
    
    // process input audio from microphone
    let audioEngine = AVAudioEngine()
    let speechRecognizer = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    
    let fruits = Fruit.defaultFuits()
    var index = 0
    var lastAnswer: String = ""
    
    // tracks the timestamp of the last processed segment.
    var mostRecentlyProcessedSegmentDuration: TimeInterval = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("did load")
        view.backgroundColor = .white
        setupViews()
        
        // request authorization
        SFSpeechRecognizer.requestAuthorization { [unowned self] (authStatus) in
          switch authStatus {
          case .authorized:
            do {
              try self.startRecording()
            } catch let error {
              print("There was a problem starting recording: \(error.localizedDescription)")
            }
          case .denied:
            print("Speech recognition authorization denied")
          case .restricted:
            print("Not available on this device")
          case .notDetermined:
            print("Not determined")
          @unknown default:
            print("Another type error occur")
          }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("will appear")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            self.fruitImage.image = UIImage(named: fruits[index].name)
            bgView.backgroundColor = UIColor(hex: fruits[index].color, alpha: 0.55)
            
            viewDidAppear(true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        verifierImage.isHidden = true
        if fruits[index].numberOfLetters > 5 {
            answerLabel.font = .rounded(ofSize: 50, weight: .semibold)
        }
        let answer = String(repeating: "_ ", count: fruits[index].numberOfLetters)
        answerLabel.text = String(answer.dropLast())
    }
}

// MARK: - Live Speech
extension FruitsViewController {
    fileprivate func startRecording() throws {
        // reset the tracked duration each time recording starts
        mostRecentlyProcessedSegmentDuration = 0

        //input audio
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        
        //When the buffer is filled, the closure returns the data in buffer which is appended to the SFSpeechAudioBufferRecognitionRequest
        node.installTap(onBus: 0, bufferSize: 32, format: recordingFormat) { [unowned self] (buffer, _) in
            self.request.append(buffer)
        }
        
        // prepares to start recording
        audioEngine.prepare()
        try audioEngine.start()
        
        recognitionTask = speechRecognizer?.recognitionTask(with: request) { [unowned self] (result, _) in
          if let transcription = result?.bestTranscription {
//            let text = transcription.formattedString.split(separator: " ")
//            print(text)
            
            self.updateUIWithTranscription(transcription)
            lastAnswer = answerLabel.text!
//            text = []
          }
        }
    }
    
    // stop transcription and recording
    fileprivate func stopRecording() {
      audioEngine.stop()
      request.endAudio()
      recognitionTask?.cancel()
    }
}

// MARK: - Setup View
extension FruitsViewController {
    func setupViews() {
        //title
        titleLabel.font = .rounded(ofSize: 32, weight: .semibold)
        
        //image
//        fruitImage.contentMode = as
        fruitImage.layer.applyShadow(layer: fruitImage.layer, shadowColor: UIColor.black.cgColor)
        fruitImage.image = UIImage(named: fruits[index].name)
        bgView.backgroundColor = UIColor(hex: fruits[index].color, alpha: 0.55)
        
        //answer
        answerView.layer.applyShadow(layer: answerView.layer, shadowColor: UIColor.black.cgColor)
        
        answerLabel.text = String(repeating: "_ ", count: fruits[index].numberOfLetters)
        answerLabel.font = .rounded(ofSize: 80, weight: .semibold)
        
        //verifier
        verifierImage.isHidden = true
        correctAnswers.font = .rounded(ofSize: 22, weight: .bold)
        correctAnswers.text = "\(index)/12"
    }
}

// MARK: - Verify Answer
extension FruitsViewController {
    func verifyAnswer(correctAnswer: String, userAnswer: String) {
        if correctAnswer == userAnswer {
            self.verifierImage.image = UIImage(systemName: "checkmark")
            self.verifierImage.tintColor = UIColor(hex: "00B600")
            self.verifierImage.isHidden = false
            
            correctAnswers.text = "\(index + 1)/12"
            self.index += 1
            
            viewWillAppear(true)
        } else {
            self.verifierImage.image = UIImage(systemName: "xmark")
            self.verifierImage.tintColor = UIColor(hex: "EF0000")
            self.verifierImage.isHidden = false
        }
    }
}

// MARK: - Update Transcription
extension FruitsViewController {
    fileprivate func updateUIWithTranscription(_ transcription: SFTranscription) {
      if let lastSegment = transcription.segments.last,
        lastSegment.duration >= mostRecentlyProcessedSegmentDuration {
        mostRecentlyProcessedSegmentDuration = lastSegment.duration
        self.answerLabel.text = lastSegment.substring.lowercased()
        print(lastSegment.substring.lowercased())
        if lastSegment.substring.lowercased() != lastAnswer {
            verifyAnswer(correctAnswer: fruits[index].name, userAnswer: answerLabel.text!)
        }
      }
    }

}
