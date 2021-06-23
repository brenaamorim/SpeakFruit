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

    // process input audio from microphone
    let audioEngine = AVAudioEngine()
    let speechRecognizer = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    
    let fruits = Fruit.defaultFuits()
    var index = 0
    
    // tracks the timestamp of the last processed segment.
//    var mostRecentlyProcessedSegmentDuration: TimeInterval = 0
    
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
        print("will appear")
        self.fruitImage.image = UIImage(named: fruits[index].name)
        bgView.backgroundColor = UIColor(hex: fruits[index].color, alpha: 0.55)
    }
}

// MARK: - Live Speech
extension FruitsViewController {
    fileprivate func startRecording() throws {
        // reset the tracked duration each time recording starts
//        mostRecentlyProcessedSegmentDuration = 0

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
            self.answerLabel.text = transcription.formattedString
            verifyAnswer(correctAnswer: fruits[index].name, userAnswer: answerLabel.text!)
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
        answerLabel.font = .rounded(ofSize: 80, weight: .semibold)
        
        //verifier
        verifierImage.isHidden = true
    }
}

// MARK: - Verify Answer
extension FruitsViewController {
    func verifyAnswer(correctAnswer: String, userAnswer: String) {
        if correctAnswer == userAnswer {
            self.verifierImage.image = UIImage(systemName: "checkmark")
            self.verifierImage.tintColor = UIColor(hex: "00B600")
            self.verifierImage.isHidden = false
            self.index += 1
            
            stopRecording()
            viewWillAppear(true)
        } else {
            self.verifierImage.image = UIImage(systemName: "xmark")
            self.verifierImage.tintColor = UIColor(hex: "EF0000")
            self.verifierImage.isHidden = false
        }
    }
}
