import { BreakpointConstants, CommonConstants } from 'base';
import { deviceInfo } from '@kit.BasicServicesKit';

@Component
export struct MainPage {
  @State currentBottomIndex: number = 0;
  @StorageLink(BreakpointConstants.CURRENT_BREAKPOINT) currentBreakpoint: string = BreakpointConstants.BREAKPOINT_LG;
  @StorageLink(CommonConstants.AVOID_RECT_HEIGHT_TOP) TopRectHeight: number = 0;

  @Builder
  BottomTabBuilder(name: string, index: number) {
    Column() {
      Text(name)
        .fontSize(20)
        .fontWeight(500)
        .fontColor(index === this.currentBottomIndex ? Color.Orange : Color.Black)
        .margin({ top: 5 })
        .opacity(index === this.currentBottomIndex ? 1 : 0.4)
    }
    .padding({
      bottom: deviceInfo.deviceType === CommonConstants.DEVICE_TYPES[0] ? 0 : 24
    })
    .height(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG ? "80vp" : CommonConstants.FULL_WIN)
    .width(CommonConstants.FULL_WIN)
    .justifyContent(FlexAlign.Center)
  }

  build() {
    Column() {
      Tabs({
        barPosition: this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG ? BarPosition.Start : BarPosition.End
      }) {
        TabContent() {
          Text("test01")
        }.tabBar(this.BottomTabBuilder("t01", 0))
        TabContent() {
          Text("test02")
        }.tabBar(this.BottomTabBuilder("t02", 1))
        TabContent() {
          Text("test03")
        }.tabBar(this.BottomTabBuilder("t03", 2))
        TabContent() {
          Text("test04")
        }.tabBar(this.BottomTabBuilder("t04", 3))
      }
      .barWidth(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG ? CommonConstants.BAR_WIDTH_LG :
      CommonConstants.FULL_WIN)
      .barHeight(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG ? CommonConstants.FULL_WIN :
        ((deviceInfo.deviceType === CommonConstants.DEVICE_TYPES[0] ? CommonConstants.BAR_HEIGHT_LIST[0] :
        CommonConstants.BAR_HEIGHT_LIST[1])))
      .vertical(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG)
      .onChange((index: number) => {
        this.currentBottomIndex = index;
      })
      .scrollable(false)
    }
  }
}
