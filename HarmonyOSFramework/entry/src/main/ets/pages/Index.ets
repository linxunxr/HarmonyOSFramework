import { window } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  @State topAvoidHeight: number = 0;
  @State bottomAvoidHeight: number = 0;
  @State message: string = 'Hello World';

  onPageShow(): void {
    /**
     * 1. 获取上下的安全区高度
     */
    window.getLastWindow(getContext())
      .then(win => {
        // 1.1. 获取顶部安全区高度
        this.topAvoidHeight = px2vp(win.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM)
          .topRect.height);
        // 1.2. 获取底部安全区高度
        this.bottomAvoidHeight = px2vp(win.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM)
          .bottomRect.height);
        // 1.3. 存入全局变量
        AppStorage.setOrCreate('topAvoidHeight', this.topAvoidHeight);
        AppStorage.setOrCreate('bottomAvoidHeight', this.bottomAvoidHeight);
      });
  }

  build() {
    Column() {
      Text('hello word')
    }
    .width('100%')
    .height('100%')
    .padding({top: this.topAvoidHeight, bottom: this.bottomAvoidHeight})
  }
}