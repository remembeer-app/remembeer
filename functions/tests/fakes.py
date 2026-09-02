from copy import deepcopy
from typing import Any


class Snapshot:
    def __init__(self, value: dict[str, Any] | None):
        self._value = deepcopy(value)
        self.exists = value is not None

    def to_dict(self) -> dict[str, Any] | None:
        return deepcopy(self._value)


class DocumentReference:
    def __init__(self, store: dict[str, dict[str, Any]], path: str):
        self.store = store
        self.path = path

    def collection(self, name: str) -> "CollectionReference":
        return CollectionReference(self.store, f"{self.path}/{name}")

    def get(self) -> Snapshot:
        return Snapshot(self.store.get(self.path))


class CollectionReference:
    def __init__(self, store: dict[str, dict[str, Any]], path: str):
        self.store = store
        self.path = path

    def document(self, document_id: str) -> DocumentReference:
        return DocumentReference(self.store, f"{self.path}/{document_id}")


class Database:
    def __init__(self, store: dict[str, dict[str, Any]] | None = None):
        self.store = store or {}

    def collection(self, name: str) -> CollectionReference:
        return CollectionReference(self.store, name)


class Transaction:
    def __init__(self, store: dict[str, dict[str, Any]]):
        self.store = store
        self.created_paths: list[str] = []
        self.updated_paths: list[str] = []

    def get(self, reference: DocumentReference) -> Snapshot:
        return Snapshot(self.store.get(reference.path))

    def create(self, reference: DocumentReference, value: dict[str, Any]) -> None:
        if reference.path in self.store:
            raise RuntimeError("document already exists")
        self.store[reference.path] = deepcopy(value)
        self.created_paths.append(reference.path)

    def update(self, reference: DocumentReference, value: dict[str, Any]) -> None:
        if reference.path not in self.store:
            raise RuntimeError("document does not exist")
        self.store[reference.path].update(deepcopy(value))
        self.updated_paths.append(reference.path)
