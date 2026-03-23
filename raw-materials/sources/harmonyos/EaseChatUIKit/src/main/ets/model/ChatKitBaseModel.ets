export abstract class ChatKitBaseModel<T> {
  declare origin: T;
  abstract update();
}