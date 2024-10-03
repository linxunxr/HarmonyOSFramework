import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { BreakpointConstants, CommonConstants, KvUtil, PreferenceUtil, WindowUtil } from 'base';
import { deviceInfo } from '@kit.BasicServicesKit';

export default class EntryAbility extends UIAbility {
  private windowObject?: window.Window;
  private windowUtil?: WindowUtil;
  private prefUtil?: PreferenceUtil;
  private kvUtil?: KvUtil;
  private onWindowSizeChange: (windowSize: window.Size) => void = (windowSize: window.Size) => {
    this.windowUtil?.updateBreakpoint(windowSize.width);
    AppStorage.setOrCreate(BreakpointConstants.WINDOW_WIDTH, windowSize.width);
  }
  private onWindowStatusChange: (windowStatusType: window.WindowStatusType) => void =
    (windowStatusType: window.WindowStatusType) => {
    this.windowUtil?.updateWindowStatusType(windowStatusType);
  }
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    this.windowUtil = WindowUtil.getInstance();
    this.prefUtil = PreferenceUtil.getInstance();
    this.kvUtil = KvUtil.getInstance();
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  async onWindowStageCreate(windowStage: window.WindowStage): Promise<void> {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    windowStage.getMainWindow().then((data: window.Window) => {
      this.windowObject = data;
      this.windowUtil?.updateBreakpoint(this.windowObject.getWindowProperties().windowRect.width);
      AppStorage.setOrCreate(BreakpointConstants.WINDOW_WIDTH, this.windowObject.getWindowProperties().windowRect.width);
      this.windowObject.on("windowSizeChange", this.onWindowSizeChange);
      this.windowObject.on("windowStatusChange", this.onWindowStatusChange);
    })
    if (this.windowUtil !== undefined) {
      this.windowUtil.setWindowStage(windowStage);
      await this.windowUtil.setMainWindow();
      if (deviceInfo.deviceType !== CommonConstants.DEVICE_TYPES[0]) {
        this.windowUtil.setFullScreen();
      }
      this.windowUtil.setAvoidRectHeight();
    }
    // 用户首选项初始化
    this.prefUtil?.loadPreference(this.context);
    // 键值数据库初始化
    this.kvUtil?.initKv(this.context);
    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
