import { editMessageCheckboxBuilder } from '../../components/chat/MessageBuilders';

export class EditMessageCheckBoxStyle implements ContentModifier<CheckBoxConfiguration> {

  applyContent(): WrappedBuilder<[CheckBoxConfiguration]> {
    return wrapBuilder(editMessageCheckboxBuilder)
  }

}
