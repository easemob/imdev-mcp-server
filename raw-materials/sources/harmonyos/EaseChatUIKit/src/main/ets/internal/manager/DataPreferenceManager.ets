import { Context } from '@ohos.arkui.UIContext';
import dataPreferences from '@ohos.data.preferences';
import { BusinessError } from '@kit.BasicServicesKit';
import { ChatLog } from '@easemob/chatsdk';

export class DataPreferenceManager {
  private declare context: Context;
  private declare preferences: dataPreferences.Preferences;
  private static DATA_PREFERENCES_NAME: string = "chat.uikit.store";
  private static instance: DataPreferenceManager | undefined;

  private constructor(context: Context) {
    this.context = context.getApplicationContext();
    let options: dataPreferences.Options = { name: DataPreferenceManager.DATA_PREFERENCES_NAME };
    this.preferences = dataPreferences.getPreferencesSync(this.context, options);
  }

  static getInstance(context: Context = getContext()): DataPreferenceManager {
    if (!DataPreferenceManager.instance) {
      DataPreferenceManager.instance = new DataPreferenceManager(context);
    }
    return DataPreferenceManager.instance;
  }

  putSync(key: string, value: dataPreferences.ValueType): boolean {
    if (this.preferences) {
      try {
        this.preferences.putSync(key, value);
        this.preferences.flush((err: BusinessError) => {
          if (err) {
            ChatLog.e(`Failed to flush. Code:${err.code}, message:${err.message}`);
            return;
          }
          ChatLog.i('Succeeded in flushing.');
        });
        return true;
      } catch (e) {
        ChatLog.e("putSync error: "+(e as BusinessError).message);
      }
    }
    return false;
  }

  getSync(key: string, defaultValue: dataPreferences.ValueType): dataPreferences.ValueType {
    if (this.preferences) {
      try {
        return this.preferences.getSync(key, defaultValue);
      } catch (e) {
        ChatLog.e("getSync error: "+(e as BusinessError).message);
      }
    }
    return defaultValue;
  }

  deleteSync(key: string): boolean {
    if (this.preferences) {
      try {
        this.preferences.deleteSync(key);
        this.preferences.flush(()=>{});
        return true;
      } catch (e) {
        ChatLog.e("deleteSync error: "+(e as BusinessError).message);
      }
    }
    return false;
  }
}