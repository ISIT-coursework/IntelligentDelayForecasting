"""Check team architecture rules against a Structurizr JSON export."""

import argparse
import json
import sys
from pathlib import Path


def check_workspace(workspace: dict) -> list[str]:
    errors = []

    def check_element(element: dict, needs_technology: bool = False) -> None:
        name = element.get("name", element.get("id", "?"))
        if needs_technology and not element.get("technology", "").strip():
            errors.append(f"{name}: technology is required")

        for relationship in element.get("relationships", []):
            label = f"{name} -> {relationship.get('destinationId', '?')}"
            if not relationship.get("description", "").strip():
                errors.append(f"{label}: relationship description is required")
            if not relationship.get("technology", "").strip():
                errors.append(f"{label}: relationship protocol is required")

        for child_type in ("containers", "components"):
            for child in element.get(child_type, []):
                check_element(child, needs_technology=True)

    model = workspace.get("model", {})
    for element_type in ("people", "softwareSystems"):
        for element in model.get(element_type, []):
            check_element(element)

    views = workspace.get("views", {})
    for view_type in ("systemContextViews", "containerViews"):
        if not views.get(view_type):
            errors.append(f"At least one {view_type} entry is required")

    return errors


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("workspace", type=Path, help="Structurizr JSON export")
    args = parser.parse_args()

    try:
        workspace = json.loads(args.workspace.read_text(encoding="utf-8"))
    except (OSError, UnicodeError, json.JSONDecodeError) as error:
        print(f"ERROR: cannot read {args.workspace}: {error}", file=sys.stderr)
        return 1

    if not isinstance(workspace, dict):
        print("ERROR: workspace must be a JSON object", file=sys.stderr)
        return 1

    errors = check_workspace(workspace)
    for error in errors:
        print(f"ERROR: {error}", file=sys.stderr)
    if errors:
        return 1

    print("Architecture rules passed.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
