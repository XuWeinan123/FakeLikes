//
//  ViewController.swift
//  FakeLikes
//
//  Created by 徐炜楠 on 2018/3/26.
//  Copyright © 2018年 徐炜楠. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet var collectionView: UICollectionView!
    var mainScreenItems = [MainScreenItem]()
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.setStatusBarStyle(.lightContent, animated: true)
        collectionView.delegate = self
        collectionView.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
        initDatas()
    }
    func initDatas(){
        mainScreenItems.append(ViewController.MainScreenItem.init(iconImage: UIImage(named: "微信团队")!, name: "微信点赞"))
        mainScreenItems.append(ViewController.MainScreenItem.init(iconImage: UIImage(named: "微博")!, name: "微博点赞"))
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainScreenItems.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("点击\(indexPath.row)")
        switch indexPath.row {
        case 0:
            let weChatNav = self.storyboard?.instantiateViewController(withIdentifier: "WeChatNav") as! NavController
            weChatNav.tag = 0
            self.present(weChatNav, animated: true, completion: nil)
        case 1:
            let weiBoNav = self.storyboard?.instantiateViewController(withIdentifier: "WeiBoNav") as! NavController
            weiBoNav.tag = 1
            self.present(weiBoNav, animated: true, completion: nil)
        default:
            break
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MainScreenCell
        cell.icon.image = mainScreenItems[indexPath.row].iconImage
        cell.name.text = mainScreenItems[indexPath.row].name
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    struct MainScreenItem {
        var iconImage:UIImage?
        var name = ""
        init(iconImage:UIImage,name:String) {
            self.iconImage = iconImage
            self.name = name
        }
    }
}

