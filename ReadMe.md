**TDAppMonitorKit**
====
`TDAppMonitorKit`是一套轻量级的应用性能管理组件,目前集成了UI卡顿检测、CPU占用分析以及Memory占用分析。


**安装要求**
====
- iOS 8.0+
- Xcode 9.0+

**CocoaPod安装**
====
- pod "TDAppMonitorKit"


**Objective-C项目中使用**
====
`TDAppMonitorKit`监控任务实现如下：

- UI卡顿监控 `TDAppFluencyMonitor` 

		[TD_FLUENCYMONITOR startMonitoring];
		
- FPS监控 `TDFPSMonitor` 

		[TD_FPSMONITOR startMonitoring];

- CPU&Memory监控 `TDResourceMonitor` 

		[TD_RESOURCEMONITOR startMonitoring];


**Swift项目中使用**
===
  - import TDAppMonitorKit
  
  - TDAppFluencyMonitor.shared().startMonitoring()
  - TDFPSMonitor.shared().startMonitoring()
  - TDResourceMonitor().startMonitoring()

**原理简析**
====
- 获取栈上下文

     感谢bestswifter的[BSBacktraceLogger](https://github.com/bestswifter/BSBacktraceLogger)，这是一个强大且轻量的线程调用栈分析器，它支持现有所有模拟器、真机的 CPU 架构，可以获取任意线程的调用栈，因此可以在检测到 runloop 检测到卡顿时获取卡顿处的代码执行情况。

- UI卡顿监控
  
     利用`RunnLoop`机制，通过创建子线程获取标志位flag的变化来检测主线程RunnLoop的`event loop`事件开始和结束时间段内，是否发生了阻塞。
  
     关于[RunnLoop](https://blog.ibireme.com/2015/05/18/runloop/)的详情介绍。 
 
- FPS监控（CADisplayLink监控）
  
     监听`RunLoop`无疑会污染主线程。死循环在线程间通信会造成大量的不必要损耗。so，寻找更佳的检测方案变得迫不及待，我们知道从计算机的角度来说，假设屏幕在连续的屏幕刷新周期之内无法刷新屏幕内容，即是发生了卡顿。
  
     FPS方案采用`CADisplayLink`的方式来处理, 思路是每个屏幕刷新周期派发标记位设置任务到主线程中，如果多次超出16.7ms的刷新阙值(iOS屏幕刷新周期为1/60s)，即可看作是发生了卡顿。
  
- CPU&Memory监控
    
     检测当前利用情况,这里监测的Memory占用情况与模拟器差别比较大，参考价值一般。

**性能**
====
采用与[YYDispatchQueuePool](https://github.com/ibireme/YYDispatchQueuePool)相同的多线程封装技术，实现关键数据采集的异步处理。所有监控数据的展示采用异步渲染方式，对性能几乎无影响。同时数据展示控件和监控实现都只在`DEBUG`模式下生效，无需关注Release版本移除。

**演示效果**
====
![](http://upload-images.jianshu.io/upload_images/783864-3adef6f9d8cabc88.gif?imageMogr2/auto-orient/strip)
