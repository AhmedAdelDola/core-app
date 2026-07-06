import 'package:elhanbly/models/general/register_stage_model.dart';

Map<String, dynamic> registerStageJson() => {
      'id': 1,
      'name': 'Stage 1',
      'levels': [
        {'id': 10, 'name': 'Level 1'},
        {'id': 11, 'name': 'Level 2'},
      ],
    };

List<RegisterStage> registerStagesFixture() {
  return [RegisterStage.fromJson(registerStageJson())];
}
