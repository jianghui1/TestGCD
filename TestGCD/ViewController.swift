//
//  ViewController.swift
//  TestGCD
//
//  Created by ys on 16/1/26.
//  Copyright © 2016年 jzh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let button = UIButton(type: UIButtonType.System)
        button.frame = CGRectMake(100, 100, 100, 100)
        button.backgroundColor = UIColor.redColor()
        button.addTarget(self, action: #selector(ViewController.buttonAction), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
        

    }
    
    func buttonAction() -> Void {
        // 1、测试GCD
//        self.testCGD()
        
        // 2、NSThread
//                self.testNSThread()
        
        // 3、NSObject
        //        self.testNSObject()
        
        // 4、NSOperationQueue
                self.testNSOperationQueue()

    }
    
    func testCGD() {
        
        // 1、串行队列
//        self.serialQueue()
        // 2、并行队列
//        self.concurrent()
        // 3、并发队列
//        self.globalQueue()
        // 4、只走一次
//        self.onlyOne()
//        self.onlyOne()
        // 5、障碍队列
//        self.barrierQueue()
        // 6、延迟
//        self.delay()
        // 7、重复执行
//        self.applyQueue()
        
        // 8、项目中的验证码操作
//        self.initCode()
        
//        print("当前队列==\(NSThread.currentThread())")
        
        
        // 串行队列中的并发队列的执行顺序
//        self.concurrentInSerialQueue()
        
        // 障碍队列中的并发队列的执行顺序
//        self.concurrentInBarrierQueue()
        
        // 分组队列中的并发队列的执行顺序
//        self.concurrentInGroupQueue()
    }
    
    func serialQueue() {
        let serialQueue: dispatch_queue_t = dispatch_queue_create("串行", DISPATCH_QUEUE_SERIAL)
     
        // 往队列里面添加任务
        dispatch_async(serialQueue) { () -> Void in
            print("任务1执行\(NSThread.currentThread())")
        }
        dispatch_async(serialQueue) { () -> Void in
            print("任务2执行\(NSThread.currentThread())")
        }
        dispatch_async(serialQueue) { () -> Void in
            print("任务3执行\(NSThread.currentThread())")
        }
        dispatch_async(serialQueue) { () -> Void in
            print("任务4执行\(NSThread.currentThread())")
        }
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            print("回到主线程 == \(NSThread.currentThread())")
        }
        print("继续执行")
    }
    func concurrent() {
        // 创建一个并行队列
        let concurrent: dispatch_queue_t = dispatch_queue_create("并行", DISPATCH_QUEUE_CONCURRENT)
        dispatch_async(concurrent) { () -> Void in
            print("任务1 == \(NSThread.currentThread())")
        }
        dispatch_async(concurrent) { () -> Void in
            print("任务2 == \(NSThread.currentThread())")
        }
        dispatch_async(concurrent) { () -> Void in
            print("任务3 == \(NSThread.currentThread())")
        }
        dispatch_async(concurrent) { () -> Void in
            print("任务4 == \(NSThread.currentThread())")
        }
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            print("回到主线程 == \(NSThread.currentThread())")
        }
        print("继续执行")
    }
    func globalQueue() {
        // 获取并发队列
        let globalQueue: dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        // 创建一个分组
        let group: dispatch_group_t = dispatch_group_create()
        dispatch_group_async(group, globalQueue) { () -> Void in
            print("请求0~1M的数据\(NSThread.currentThread())")
        }
        dispatch_group_async(group, globalQueue) { () -> Void in
            print("请求1~2M的数据\(NSThread.currentThread())")
        }
        dispatch_group_async(group, globalQueue) { () -> Void in
            print("请求2~3M的数据\(NSThread.currentThread())")
        }
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            print("插入主线程\(NSThread.currentThread())")
        }
        dispatch_group_notify(group, globalQueue) { () -> Void in
            print("所有分组任务都已经下载完成，开始拼接分段数据\(NSThread.currentThread())")
        }
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            print("回到主线程\(NSThread.currentThread())")
        }
        print("继续执行")
    }
    func onlyOne() {
        struct onlyOne {
            static var onceToken: dispatch_once_t = 0
        }
        dispatch_once(&onlyOne.onceToken) { () -> Void in
            print("只走了一次\(NSThread.currentThread())")
        }
        print("我要继续走\(NSThread.currentThread())")
    }
    func barrierQueue() {
        let queue: dispatch_queue_t = dispatch_queue_create("haha", DISPATCH_QUEUE_CONCURRENT)
        dispatch_async(queue) { () -> Void in
            print("任务A\(NSThread.currentThread())")
        }
        dispatch_async(queue) { () -> Void in
            print("任务B\(NSThread.currentThread())")
        }
        dispatch_async(queue) { () -> Void in
            print("任务C\(NSThread.currentThread())")
        }
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            print("障碍之前\(NSThread.currentThread())")
        }
        // 创建一个障碍
        dispatch_barrier_async(queue) { () -> Void in
            print("我是一个障碍\(NSThread.currentThread())")
        }
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            print("障碍之后\(NSThread.currentThread())")
        }
        dispatch_async(queue) { () -> Void in
            print("任务D\(NSThread.currentThread())")
        }
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            print("最后线程\(NSThread.currentThread())")
        }
    }
    func delay() {
        let delay: UInt64 = 5
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay * NSEC_PER_SEC)),  dispatch_get_main_queue(), { () -> Void in
        print("我要执行了\(NSThread.currentThread())")
        })
    }
    func applyQueue() {
        let queue: dispatch_queue_t = dispatch_queue_create("sighiu", DISPATCH_QUEUE_SERIAL)
        let array: Array = ["aa", "bb", "cc", "dd", "ee"]
        dispatch_apply(array.count, queue) { (index: Int) -> Void in
            print("\(NSThread.currentThread()),\(array[index])")
        }
    }
    
    
    func testNSThread() {
        // 1、创建多线程对象
//        let thread: NSThread = NSThread(target: self, selector: #selector(ViewController.mutableThread(_:)), object: "test")
//        thread.start()
        
        // 类方法
        NSThread.detachNewThreadSelector(#selector(ViewController.mutableThread(_:)), toTarget: self, withObject: nil)
        
    }
    func mutableThread(let str: String) {
        print("当前线程\(NSThread.currentThread()), \(str)")
        
        // 跳到主线程执行
//        self.performSelectorOnMainThread(#selector(ViewController.mainThread), withObject: nil, waitUntilDone: false)
        
        // 测试子线程中的子线程
        self.performSelectorInBackground(#selector(ViewController.mutableThread1), withObject: nil)
    }
    func mutableThread1() -> Void {
        print("当前线程1\(NSThread.currentThread())")
    }
    func mainThread() {
        if NSThread.isMainThread() {
            print("MainThread")
        }
    }
    
    
    func testNSObject() {
        self.performSelectorInBackground(#selector(ViewController.mutableThread(_:)), withObject: "test")
    }
    
    func testNSOperationQueue() {
        // 1、
//        let operationQueue: NSOperationQueue = NSOperationQueue()
//        operationQueue.addOperationWithBlock { () -> Void in
//            for var i: Int = 0; i < 10; i++ {
//                print("子线程\(i), \(NSThread.currentThread())")
//            }
//        }
        
        // 2、
        // 创建一个线程队列
        let threadQueue: NSOperationQueue = NSOperationQueue()
        // 设置线程执行的并发数
        threadQueue.maxConcurrentOperationCount = 1
        // 创建一个线程对象
        let blockQueue1: NSBlockOperation = NSBlockOperation()
        blockQueue1.addExecutionBlock { () -> Void in
            print("第一个线程\(NSThread.currentThread())")
            
            let concurrent1 = dispatch_queue_create("concurrent1", DISPATCH_QUEUE_CONCURRENT)
            dispatch_async(concurrent1, {
                print("并行1")
            })
            
        }
        let blockQueue2: NSBlockOperation = NSBlockOperation()
        blockQueue2.addExecutionBlock { () -> Void in
            print("第二个线程\(NSThread.currentThread())")
            
            let concurrent2 = dispatch_queue_create("concurrent2", DISPATCH_QUEUE_CONCURRENT)
            dispatch_async(concurrent2, {
                print("并行2")
            })

        }
        // 设置优先级
        blockQueue1.queuePriority = NSOperationQueuePriority.Low
        blockQueue2.queuePriority = NSOperationQueuePriority.High
        threadQueue.addOperation(blockQueue2)
        threadQueue.addOperation(blockQueue1)
    }
    
    
    func initCode() {
        var timeOut = 59; // 倒计时时间
        let queue: dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        let timer: dispatch_source_t = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue)
        let i: UInt64 = 1
        dispatch_source_set_timer(timer, dispatch_walltime(nil, 0), i *  NSEC_PER_SEC, 0) // 每秒执行
        dispatch_source_set_event_handler(timer) { () -> Void in
            if timeOut <= 0 {
                //关闭
                print("当前线程\(NSThread.currentThread())")
                dispatch_source_cancel(timer)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    print("回到主线程 == \(NSThread.currentThread())")
                })
            } else {
                let seconds: Int = timeOut % 60
                print("当前线程1\(NSThread.currentThread()), \(seconds)")
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    print("回到主线程1 == \(NSThread.currentThread())")
                })
                timeOut--
            }
        }
        dispatch_resume(timer)
    }
    
    func concurrentInSerialQueue() -> Void {
        let serialQueue: dispatch_queue_t = dispatch_queue_create("serial", DISPATCH_QUEUE_SERIAL)
        dispatch_async(serialQueue) {
            print("第一个串行\(serialQueue)")
            let concurrent: dispatch_queue_t = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT)
            dispatch_async(concurrent, { 
                print("第一个并行\(concurrent)")
            })
        }
        dispatch_async(serialQueue) {
            print("第一个串行\(serialQueue)")
            let concurrent: dispatch_queue_t = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT)
            dispatch_async(concurrent, {
                print("第二个并行\(concurrent)")
            })
        }
        dispatch_async(serialQueue) {
            print("第一个串行\(serialQueue)")
            let concurrent: dispatch_queue_t = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT)
            dispatch_async(concurrent, {
                print("第三个并行\(concurrent)")
            })
        }
    }
    
    func concurrentInBarrierQueue() {
        let concurrent = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT)
        
        dispatch_barrier_async(concurrent) {
            print("障碍1")
            let concurrent1 = dispatch_queue_create("concurrent1", DISPATCH_QUEUE_CONCURRENT)
            dispatch_async(concurrent1, { 
                print("并行1")
            })
        }
        dispatch_barrier_async(concurrent) {
            print("障碍2")
            let concurrent2 = dispatch_queue_create("concurrent2", DISPATCH_QUEUE_CONCURRENT)
            dispatch_async(concurrent2, {
                print("并行2")
            })
        }

        dispatch_barrier_async(concurrent) {
            print("障碍3")
            let concurrent3 = dispatch_queue_create("concurrent3", DISPATCH_QUEUE_CONCURRENT)
            dispatch_async(concurrent3, {
                print("并行3")
            })
        }

    }
    
    func concurrentInGroupQueue() -> Void {
        let groupQueue = dispatch_group_create()
        let concurrent1 = dispatch_queue_create("并行1", DISPATCH_QUEUE_CONCURRENT)
        
        dispatch_group_async(groupQueue, concurrent1) { 
            print("并行1")
        }
        let concurrent2 = dispatch_queue_create("并行2", DISPATCH_QUEUE_CONCURRENT)
        
        dispatch_group_async(groupQueue, concurrent2) {
            print("并行2")
        }
        
        let concurrent3 = dispatch_queue_create("并行3", DISPATCH_QUEUE_CONCURRENT)
        
        dispatch_group_async(groupQueue, concurrent3) {
            print("并行3")
        }

        
    }
    
}


























