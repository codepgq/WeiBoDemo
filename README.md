# WeiBoDemo
swift 练手

1、把除了AppDelegate、Assets.xcassets、Info.Plist意外的文件全部删除
2、在项目目录中创建一个真实的目录，并分好区，在拖入项目工程中
3、点击项目工程名，
    在右侧的Deployment Info中
        Main Interface：删除Main
        Device Orientation：只留下竖屏
    在App Icons and Launch Images中
        Launch Images Source → 创建一个APP加载页（然后在点击Assets.xcassets，在AppIcon栏空白处右键 → APP Icon & Launch Images → New IOS Launch Images，选中LaunchImage 在最右侧的选项栏中选择最后一项 → 只勾选IOS 8.0 and Later 下的 Protrait）
        Launch Screen File → 删除LaunchScreen 因为这个默认级比上一个高，只要设置了这个上面一个就会失效

4、分析项目结构如下：
初始结构
UITabBarController -> UINavigationController -> UITableViewController
优化结构
UITabBarController -> UINavigationController -> BaseTableViewController -> UITableViewController