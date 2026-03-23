import { abilityAccessCtrl, PermissionRequestResult, Permissions } from '@kit.AbilityKit';
import { AsyncCallback } from '@kit.BasicServicesKit';

export class PermissionManager {

  /**
   * 申请权限
   * @param context
   * @param permissions
   */
  static async requestPermissions(context: Context, permissions: Permissions[]) {
    let atManager = abilityAccessCtrl.createAtManager();
    // requestPermissionsFromUser会判断权限的授权状态来决定是否唤起弹窗
    return await atManager.requestPermissionsFromUser(context, permissions)
  }

  /**
   * 申请权限
   * @param context
   * @param permissions
   */
  static asyncRequestPermissions(context: Context, permissions: Permissions[], requestCallback: AsyncCallback<PermissionRequestResult>) {
    let atManager = abilityAccessCtrl.createAtManager();
    // requestPermissionsFromUser会判断权限的授权状态来决定是否唤起弹窗
    atManager.requestPermissionsFromUser(context, permissions, requestCallback);
  }
}