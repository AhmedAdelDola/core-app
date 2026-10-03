const fs = require('fs');
let c = fs.readFileSync('lib/core/security/content_protection_service.dart', 'utf8');

c = c.replace(/      \(id\) => id,\n    \);\n\n    if \(deviceId\.isEmpty\) \{\n      throw ContentProtectionException\(\n        'ENROLLMENT_FAILED',\n        'Device enrollment returned an empty device ID\.',\n      \);\n    \}/g,       (id) => id,\n    );\n    } on ContentProtectionException {\n      rethrow;\n    } catch (e) {\n      _logger.w('Device enrollment failed, falling back. Error: ' + e);\n      return await _fallbackEnrollment();\n    }\n\n    if (deviceId.isEmpty) {\n      throw ContentProtectionException(\n        'ENROLLMENT_FAILED',\n        'Device enrollment returned an empty device ID.',\n      );\n    });

fs.writeFileSync('lib/core/security/content_protection_service.dart', c);
