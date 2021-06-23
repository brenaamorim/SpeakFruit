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
    
    // process input audio from microphone
    let audioEngine = AVAudioEngine()
    let speechRecognizer = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    
    // tracks the timestamp of the last processed segment.
    var mostRecentlyProcessedSegmentDuration: TimeInterval = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
}

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

extension FruitsViewController {
    func setupViews() {
        //title
        titleLabel.text = "Say the fruit name (:"
        titleLabel.font = .rounded(ofSize: 32, weight: .semibold)
        
        //image
//        fruitImage.contentMode = as
        fruitImage.layer.applyShadow(layer: fruitImage.layer, shadowColor: UIColor.black.cgColor)
        fruitImage.image = UIImage(named: "apple")
        bgView.backgroundColor = UIColor(red: 0.87, green: 0.14, blue: 0.16, alpha: 0.55)
        
        //answer
        answerView.layer.applyShadow(layer: answerView.layer, shadowColor: UIColor.black.cgColor)
        answerLabel.font = .rounded(ofSize: 80, weight: .semibold)
    }
}
