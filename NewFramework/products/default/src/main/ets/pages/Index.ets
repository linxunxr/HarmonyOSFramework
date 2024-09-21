import { BreakpointConstants, CommonConstants, Logger, WindowUtil } from 'base';
import { window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { MainPage } from 'home';

@Entry
@Component
struct Index {
  @Provide(CommonConstants.PAGE_INFOS) pageInfos: NavPathStack = new NavPathStack();
  @StorageLink(BreakpointConstants.IS_SPLIT_MODE) isSplitMode: boolean = false;
  private windowUtil?: WindowUtil;
  private mainWindow?: window.Window;

  aboutToAppear(): void {
    if (this.isSplitMode) {
      // 跟路由推送页面
    }
  }

  aboutToDisappear(): void {
    if (this.windowUtil === undefined) {
      return;
    }
    this.mainWindow = this.windowUtil.getMainWindow();
    if (this.mainWindow === undefined) {
      return;
    }
    try {
      this.mainWindow.off("windowSizeChange");
      this.mainWindow.off("windowStatusChange");
    } catch (exception) {
      Logger.error("取消监听失败:" + JSON.stringify(exception));
    }
  }
  @State message: string = 'Hello World';

  build() {
    Navigation() {
      // 页面
      MainPage()
    }
    .width(CommonConstants.FULL_WIN)
    .height(CommonConstants.FULL_WIN)
    .mode(NavigationMode.Stack)
    .hideTitleBar(true)
  }
}