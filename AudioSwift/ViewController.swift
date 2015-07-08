//
//  ViewController.swift
//  AudioSwift
//
//  Created by MAEDAHAJIME on 2015/07/07.
//  Copyright (c) 2015年 MAEDA HAJIME. All rights reserved.
//

import UIKit
import AVFoundation
import QuartzCore

class ViewController: UIViewController,AVAudioPlayerDelegate {

    var _adp01:AVAudioPlayer?
    
    @IBOutlet weak var ivImage: UIImageView!
    
    @IBOutlet weak var lbInformation: UILabel!
    
    @IBOutlet weak var swPlay: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 準備処理
        doReady()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // [再生／停止]スイッチ変更
    @IBAction func changePlay(sender: UISwitch) {
        
        // スイッチ値の判定
        if (sender.on == true) {
            
            // 再生
            _adp01!.play()
            
            // アニメーション開始
            animateStart(self.ivImage)
            
        } else {
            
            // 停止
            _adp01!.stop()
            _adp01!.prepareToPlay()
            _adp01!.currentTime = 0.0
            
            // アニメーション停止
            self.animateEnd(self.ivImage)
        }

    }

    // [ボリューム]スライダー変更
    @IBAction func changeVolume(sender: UISlider) {
        // 音量設定 (0.0-1.0)
        _adp01!.volume = sender.value
    }
    
    // [パンニング]スライダー変更
    @IBAction func changePanning(sender: UISlider) {
        // パンニング設定 (-1.0-1.0)
        _adp01!.pan = sender.value

    }
    
    // [再生速度]スライダー変更
    @IBAction func changeSpeed(sender: UISlider) {
        // 再生速度設定 (0.0-2.0)
        _adp01!.rate = sender.value
    }
    
    // サウンド再生完了時
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        
        // [再生／停止]スイッチOFF
        self.swPlay.on = false

    }
    
    /*
    AVAudioPlayerDelegateをしようしているので準備処理の中にデリゲート設定をしておかなければならない。
    「_adp01!.delegate = self」設定をしなければ動作しませんので注意が必要。
    */
    // 準備処理
    func doReady(){
        
        // 音楽ファイルの参照
        let bnd01:NSBundle = NSBundle.mainBundle()
        let pth01:NSString = bnd01.pathForResource("She's_a_Rainbow",ofType:"mp3")!
        let url01:NSURL = NSURL.fileURLWithPath(pth01 as String)!

        // AVAudioPlayerオブジェクト生成
        _adp01 = AVAudioPlayer(contentsOfURL: url01, error:nil)
        
        // 設定（再生速度の変更許可）
        _adp01!.enableRate = true
        
        // 設定（デリゲート）
        _adp01!.delegate = self
        
        // 再生準備
        _adp01!.prepareToPlay()
        
        // 音楽情報の表示
        let name01:NSString = url01.lastPathComponent!
        let len01:NSTimeInterval = _adp01!.duration
        
        // 桁数を指定して文字列を作る.
        let len02 = "".stringByAppendingFormat("%.f", len01)
        
        self.lbInformation.text = NSString(format: "%@\n%@秒", "\(name01)","\(len02)") as String
        //println(" \(name01) 秒：\(len01)")
    }
    
    // アニメーション開始（要：QuartzCore.framework）
    func animateStart(imageView: UIImageView){
        
        // アニメーション設定
        // (種類(Z軸回転))
        let ani:CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        
        // 開始時の値(変化値)
        ani.fromValue = 0.0
        
        // 終了時の値（絶対的な値）
        ani.toValue   = 2.0 * M_PI
        
        // (アニメーション時間(秒)) アニメーション間隔の指定
        ani.duration = 2.0
        
        // (繰返し回数)
        ani.repeatCount = 99999	// 無限
        
        // アニメーション開始
        imageView.layer.addAnimation(ani, forKey:"ANIM01")
    }
    
    // アニメーション停止
    func animateEnd(imageView: UIImageView){
        // アニメーション削除
        imageView.layer.removeAnimationForKey("ANIM01")
    }
}