"""Metadata serialization for git features.

This module provides base metadata classes with JSON serialization support
for git worktree and virtual worktree features.
"""

import json
from dataclasses import asdict, dataclass
from typing import Any, Dict


@dataclass
class BaseMetadata:
    """Base metadata class for git features.

    Provides JSON serialization and deserialization for feature metadata.
    Subclasses should inherit from this and add feature-specific fields.

    Common fields:
        base_branch: Branch this feature is based on
        created_at: ISO 8601 timestamp of creation
        created_by: Git user name who created the feature
        slug: Feature identifier slug
    """

    base_branch: str
    created_at: str
    created_by: str
    slug: str

    def to_json(self) -> str:
        """Serialize metadata to JSON string.

        Returns:
            JSON representation of metadata with 2-space indentation
        """
        return json.dumps(asdict(self), indent=2)

    @classmethod
    def from_json(cls, data: str) -> "BaseMetadata":
        """Deserialize metadata from JSON string.

        Args:
            data: JSON string containing metadata

        Returns:
            Metadata instance

        Raises:
            ValueError: If JSON is invalid or missing required fields
        """
        try:
            parsed = json.loads(data)
            return cls(**parsed)
        except (json.JSONDecodeError, TypeError, KeyError) as e:
            raise ValueError(f"Invalid metadata format: {e}") from e

    def to_dict(self) -> Dict[str, Any]:
        """Convert metadata to dictionary.

        Returns:
            Dictionary representation of metadata
        """
        return asdict(self)

    @classmethod
    def from_dict(cls, data: Dict[str, Any]) -> "BaseMetadata":
        """Create metadata from dictionary.

        Args:
            data: Dictionary containing metadata fields

        Returns:
            Metadata instance

        Raises:
            TypeError: If required fields are missing
        """
        return cls(**data)
