//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Rishav on 07/03/17.
//  Copyright © 2017 Rishav. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController ,AVAudioRecorderDelegate{
    
    @IBOutlet weak var stopRecording: UIButton!
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        stopRecording.isEnabled = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear called")

    }
    
    @IBAction func recordAudio(_ sender: Any) {
        configureUI(isRecording: true)
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate=self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    
    }
    func configureUI(isRecording: Bool) {
        recordingLabel.text = isRecording ? "Recording in progress" : "Tap to Record"
        stopRecording.isEnabled = isRecording
        recordButton.isEnabled = !isRecording
    }
    @IBAction func stopRecord(_ sender: Any) {
        configureUI(isRecording: false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
                performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }
        else{
            print("recording unsuccessful")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}
