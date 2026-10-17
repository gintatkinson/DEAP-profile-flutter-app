import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

/// Verifies DO-178C DAL-A / ARINC 661 7-Section Regulatory Docstring compliance
/// across all Dart library source files under `lib/`.
///
/// Realises: [ARCH-DOC-001, REQ-DOC-001]
void main() {
  group('DO-178C DAL-A / ARINC 661 7-Section Docstring Compliance', () {
    final Directory libDir = Directory('lib').existsSync()
        ? Directory('lib')
        : Directory('app_flutter/lib');

    test('should_discover_dart_files_under_lib_when_scanning_workspace', () {
      expect(
        libDir.existsSync(),
        isTrue,
        reason: 'Expected lib/ directory to exist in workspace.',
      );
      final List<File> dartFiles = libDir
          .listSync(recursive: true)
          .whereType<File>()
          .where((File f) => f.path.endsWith('.dart'))
          .toList();
      expect(
        dartFiles,
        isNotEmpty,
        reason: 'Expected at least one .dart file under lib/.',
      );
    });

    test(
      'should_contain_7_section_regulatory_headers_unfenced_realises_and_zero_em_dashes_in_every_lib_file',
      () {
        final List<File> dartFiles = libDir
            .listSync(recursive: true)
            .whereType<File>()
            .where((File f) => f.path.endsWith('.dart'))
            .toList()
          ..sort((File a, File b) => a.path.compareTo(b.path));

        const List<String> requiredHeaders = <String>[
          '/// ## 1. Safety Intent',
          '/// ## 2. Invariants',
          '/// ## 3. Preconditions',
          '/// ## 4. Postconditions',
          '/// ## 5. Algorithmic Complexity',
          '/// ## 6. Failure Modes',
          '/// ## 7. Realization',
        ];

        final String emDash = String.fromCharCode(0x2014);
        final List<String> violations = <String>[];

        for (final File file in dartFiles) {
          final String relativePath = file.path.replaceAll(r'\', '/');
          final String content = file.readAsStringSync();

          if (content.trim().isEmpty) {
            violations.add('$relativePath: file is empty');
            continue;
          }

          for (final String header in requiredHeaders) {
            if (!content.contains(header)) {
              violations.add(
                '$relativePath: missing required docstring header "$header"',
              );
            }
          }

          if (content.contains(emDash)) {
            violations.add(
              '$relativePath: contains forbidden Unicode em dash (\\u2014)',
            );
          }

          final List<String> lines = content.split('\n');
          bool inDocCodeFence = false;
          bool hasUnfencedRealises = false;

          for (int i = 0; i < lines.length; i++) {
            final String trimmed = lines[i].trim();
            if (trimmed.startsWith('///')) {
              final String docBody = trimmed.substring(3).trim();
              if (docBody.startsWith('```')) {
                inDocCodeFence = !inDocCodeFence;
              } else if (trimmed.startsWith('/// Realises:')) {
                if (inDocCodeFence) {
                  violations.add(
                    '$relativePath:${i + 1}: "/// Realises:" must not appear inside a markdown code fence',
                  );
                } else if (trimmed.contains('/// Realises: [')) {
                  hasUnfencedRealises = true;
                }
              }
            } else {
              inDocCodeFence = false;
            }
          }

          if (!hasUnfencedRealises) {
            violations.add(
              '$relativePath: missing unfenced "/// Realises: [...]" traceability tag',
            );
          }
        }

        expect(
          violations,
          isEmpty,
          reason:
              'Docstring compliance violations found:\n${violations.join('\n')}',
        );
      },
    );
  });
}
