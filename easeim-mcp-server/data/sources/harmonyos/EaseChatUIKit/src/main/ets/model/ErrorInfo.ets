import { ChatError } from '@easemob/chatsdk';

export class ErrorInfo {
  errorCode: number;
  errorMessage: string;
  method: string;

  constructor(method: string, errorMessage: string = '', errorCode: number = ChatError.EM_NO_ERROR) {
    this.method = method;
    this.errorMessage = errorMessage;
    this.errorCode = errorCode;
  }

  static create(method: string, error: ChatError): ErrorInfo;
  static create(method: string, errorMessage?: string, errorCode?: number): ErrorInfo;
  static create(method: string, errorMessage?: string |ChatError, errorCode: number = ChatError.EM_NO_ERROR): ErrorInfo {
    if (typeof errorMessage === 'undefined') {
      return new ErrorInfo(method, "", errorCode ?? ChatError.EM_NO_ERROR);
    } else if (typeof errorMessage === 'string') {
      return new ErrorInfo(method, errorMessage ?? "", errorCode ?? ChatError.EM_NO_ERROR);
    } else {
      return new ErrorInfo(method, errorMessage!.description, errorMessage!.errorCode);
    }
  }
}