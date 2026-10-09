import copy
import unittest

from check_diagrams import check_workspace


class CheckWorkspaceTests(unittest.TestCase):
    def setUp(self):
        self.component = {"name": "Predictor", "technology": "Python"}
        self.relationship = {
            "destinationId": "database",
            "description": "Stores forecasts",
            "technology": "SQL",
        }
        self.container = {
            "name": "API",
            "technology": "Go",
            "components": [self.component],
            "relationships": [self.relationship],
        }
        self.workspace = {
            "model": {
                "people": [{"name": "Dispatcher"}],
                "softwareSystems": [{"name": "Forecasting", "containers": [self.container]}],
            },
            "views": {
                "systemContextViews": [{"key": "Context"}],
                "containerViews": [{"key": "Containers"}],
            },
        }

    def test_complete_workspace_passes(self):
        self.assertEqual(check_workspace(self.workspace), [])

    def test_missing_metadata_is_rejected(self):
        cases = [
            (self.container, "technology", "API: technology"),
            (self.component, "technology", "Predictor: technology"),
            (self.relationship, "description", "relationship description"),
            (self.relationship, "technology", "relationship protocol"),
        ]
        for element, field, expected in cases:
            for value in (None, "   "):
                with self.subTest(field=field, expected=expected, value=value):
                    original = element.pop(field)
                    if value is not None:
                        element[field] = value
                    errors = check_workspace(self.workspace)
                    self.assertTrue(any(expected in error for error in errors), errors)
                    element[field] = original

    def test_required_views_cannot_be_missing_or_empty(self):
        for view_type in ("systemContextViews", "containerViews"):
            for missing in (True, False):
                with self.subTest(view_type=view_type, missing=missing):
                    workspace = copy.deepcopy(self.workspace)
                    if missing:
                        del workspace["views"][view_type]
                    else:
                        workspace["views"][view_type] = []
                    errors = check_workspace(workspace)
                    self.assertTrue(any(view_type in error for error in errors), errors)

    def test_collects_errors_across_elements(self):
        self.container.pop("technology")
        self.component.pop("technology")
        self.relationship.pop("description")
        self.relationship.pop("technology")
        self.assertEqual(len(check_workspace(self.workspace)), 4)


if __name__ == "__main__":
    unittest.main()
