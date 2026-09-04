import os
import sys
import tempfile
import unittest
from unittest.mock import patch, MagicMock

# Add scripts directory to sys.path
scripts_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "scripts"))
if scripts_dir not in sys.path:
    sys.path.insert(0, scripts_dir)

from reconcile_backlog import (
    update_checklist_in_file,
    resolve_issue_on_tracker,
    is_already_resolved,
    get_resolved_label,
)

class TestReconcileBacklogDependencyGating(unittest.TestCase):
    """
    Unit and integration tests ensuring reconcile_backlog.py strictly blocks automated issue
    resolution when dependencies or blocker checklist items are unmapped, missing, or open.
    (Fixes Issue #4)
    """

    def setUp(self):
        self.temp_dir = tempfile.TemporaryDirectory()
        self.rules = {
            "tracker_rules": {
                "provider": "github",
                "dependency_regex": r"(-\s*\[\s*([ xX])\s*\]\s*(#|#\[|\#\s*)?([A-Za-z0-9\-]+))",
                "keys": {
                    "issue_id": "number",
                    "title": "title",
                    "labels": "labels",
                    "state": "state",
                    "closed_state_value": "CLOSED",
                    "open_state_value": "OPEN",
                },
                "labels": {
                    "resolved": "status:fixed-resolved",
                },
                "commands": {
                    "resolve_issue": ["gh", "issue", "edit", "{number}", "--add-label", "{label}"],
                    "comment_issue": ["gh", "issue", "comment", "{number}", "--body", "{comment}"],
                },
            }
        }

    def tearDown(self):
        self.temp_dir.cleanup()

    def _create_spec_file(self, filename: str, content: str) -> str:
        filepath = os.path.join(self.temp_dir.name, filename)
        with open(filepath, "w", encoding="utf-8") as f:
            f.write(content)
        return filepath

    def test_unmapped_missing_dependency_prevents_resolution(self):
        """
        If a dependency issue referenced in the checklist is not found in the tracker (dep_issue is None),
        update_checklist_in_file MUST return completed=False to prevent premature resolution (#4).
        """
        content = (
            "# Epic: Autonomous Guidance\n\n"
            "## Dependencies\n"
            "- [x] #101 - Core Engine (Closed)\n"
            "- [ ] #999 - Missing / Unmapped Dependency\n"
        )
        spec_file = self._create_spec_file("epic-01.md", content)
        issue_dict = {
            101: {"number": 101, "title": "Core Engine", "state": "CLOSED", "labels": []},
            # Note: 999 is intentionally missing from issue_dict
        }

        updated_content, completed = update_checklist_in_file(spec_file, issue_dict, self.rules)
        self.assertFalse(completed, "Specification with missing/unmapped dependency must NOT be completed")

    def test_unmapped_missing_dependency_already_checked_prevents_resolution(self):
        """
        If a dependency issue referenced in the checklist is missing from tracker but was pre-checked [x] in markdown,
        update_checklist_in_file MUST return completed=False.
        """
        content = (
            "# Epic: Autonomous Guidance\n\n"
            "## Dependencies\n"
            "- [x] #101 - Core Engine (Closed)\n"
            "- [x] #999 - Unmapped Hallucinated Dep\n"
        )
        spec_file = self._create_spec_file("epic-01b.md", content)
        issue_dict = {
            101: {"number": 101, "title": "Core Engine", "state": "CLOSED", "labels": []},
        }

        updated_content, completed = update_checklist_in_file(spec_file, issue_dict, self.rules)
        self.assertFalse(completed, "Specification with unmapped dependency marked [x] must NOT be completed")

    def test_unresolved_placeholder_prevents_resolution(self):
        """
        If a dependency checklist item contains an unresolved placeholder like #[IssueID],
        update_checklist_in_file MUST return completed=False.
        """
        content = (
            "# User Story: Obstacle Avoidance\n\n"
            "## Dependencies\n"
            "- [x] #101 - Sensor Driver (Closed)\n"
            "- [ ] #[StoryIssueID] - Unassigned Story\n"
        )
        spec_file = self._create_spec_file("us-01.md", content)
        issue_dict = {
            101: {"number": 101, "title": "Sensor Driver", "state": "CLOSED", "labels": []},
        }

        updated_content, completed = update_checklist_in_file(spec_file, issue_dict, self.rules)
        self.assertFalse(completed, "Specification with unresolved placeholder token must NOT be completed")

    def test_open_dependency_prevents_resolution(self):
        """
        If any referenced dependency is still in OPEN state on the tracker,
        update_checklist_in_file MUST return completed=False.
        """
        content = (
            "# Use Case: Waypoint Navigation\n\n"
            "## Dependencies\n"
            "- [x] #101 - Path Planning (Closed)\n"
            "- [ ] #102 - Actuator Control (Open)\n"
        )
        spec_file = self._create_spec_file("uc-01.md", content)
        issue_dict = {
            101: {"number": 101, "title": "Path Planning", "state": "CLOSED", "labels": []},
            102: {"number": 102, "title": "Actuator Control", "state": "OPEN", "labels": []},
        }

        updated_content, completed = update_checklist_in_file(spec_file, issue_dict, self.rules)
        self.assertFalse(completed, "Specification with open dependencies must NOT be completed")

    def test_unchecked_plain_checkbox_prevents_resolution(self):
        """
        If a specification checklist contains unchecked manual blocker items (e.g. - [ ] Manual Task),
        it MUST NOT be marked completed even if tracker issues are closed.
        """
        content = (
            "# Epic: Safety Architecture\n\n"
            "## Dependencies\n"
            "- [x] #101 - Safety Boundary Validator (Closed)\n"
            "- [ ] Manual flight clearance sign-off\n"
        )
        spec_file = self._create_spec_file("epic-02.md", content)
        issue_dict = {
            101: {"number": 101, "title": "Safety Boundary Validator", "state": "CLOSED", "labels": []},
        }

        updated_content, completed = update_checklist_in_file(spec_file, issue_dict, self.rules)
        self.assertFalse(completed, "Specification with unchecked manual blocker checkbox must NOT be completed")

    def test_all_closed_dependencies_allow_resolution(self):
        """
        When all declared dependencies are CLOSED on the tracker,
        update_checklist_in_file returns completed=True and updates checkbox marks to [x].
        """
        content = (
            "# Epic: Flight Control\n\n"
            "## Dependencies\n"
            "- [ ] #101 - Yaw Control\n"
            "- [ ] #102 - Pitch Control\n"
        )
        spec_file = self._create_spec_file("epic-03.md", content)
        issue_dict = {
            101: {"number": 101, "title": "Yaw Control", "state": "CLOSED", "labels": []},
            102: {"number": 102, "title": "Pitch Control", "state": "CLOSED", "labels": []},
        }

        updated_content, completed = update_checklist_in_file(spec_file, issue_dict, self.rules)
        self.assertTrue(completed, "Specification with all closed dependencies must be completed")
        self.assertIn("- [x] #101", updated_content)
        self.assertIn("- [x] #102", updated_content)

    def test_empty_checklist_prevents_resolution(self):
        """
        A specification without any tracked dependencies / checklist items must NOT be marked completed.
        """
        content = (
            "# Epic: Empty Spec\n\n"
            "This specification has no deliverables or dependency checklist items.\n"
        )
        spec_file = self._create_spec_file("epic-04.md", content)
        issue_dict = {101: {"number": 101, "state": "CLOSED"}}

        updated_content, completed = update_checklist_in_file(spec_file, issue_dict, self.rules)
        self.assertFalse(completed, "Specification with no dependency checklist items must NOT be marked completed")

    def test_mock_tracker_resolution_gated_by_dependencies(self):
        """
        Verify resolve_issue_on_tracker is never called when unmapped dependencies are present.
        """
        content = (
            "# Epic: Tracker Integration Guard\n\n"
            "## Dependencies\n"
            "- [x] #101 - Subsystem A (Closed)\n"
            "- [ ] #999 - Missing Subsystem\n"
        )
        spec_file = self._create_spec_file("epic-06.md", content)
        issue_dict = {
            101: {"number": 101, "title": "Subsystem A", "state": "CLOSED", "labels": []},
            200: {"number": 200, "title": "Tracker Integration Guard", "state": "OPEN", "labels": []},
        }

        mock_adapter = MagicMock()
        updated_content, completed = update_checklist_in_file(spec_file, issue_dict, self.rules)

        if completed and not is_already_resolved(issue_dict[200], self.rules):
            resolve_issue_on_tracker(200, "Epic completed.", rules=self.rules, provider_adapter=mock_adapter)

        # resolve_issue_on_tracker must not have been invoked
        mock_adapter.add_label.assert_not_called()
        mock_adapter.comment_issue.assert_not_called()

if __name__ == "__main__":
    unittest.main()
