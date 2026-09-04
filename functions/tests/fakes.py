from copy import deepcopy
from typing import Any


class Snapshot:
    def __init__(
        self,
        value: dict[str, Any] | None,
        reference: "DocumentReference | None" = None,
    ):
        self._value = deepcopy(value)
        self.exists = value is not None
        self.reference = reference

    @property
    def id(self) -> str:
        if self.reference is None:
            raise ValueError("snapshot has no reference")
        return self.reference.path.rsplit("/", maxsplit=1)[-1]

    def to_dict(self) -> dict[str, Any] | None:
        return deepcopy(self._value)


class DocumentReference:
    def __init__(self, store: dict[str, dict[str, Any]], path: str):
        self.store = store
        self.path = path

    def collection(self, name: str) -> "CollectionReference":
        return CollectionReference(self.store, f"{self.path}/{name}")

    def get(self) -> Snapshot:
        return Snapshot(self.store.get(self.path), self)

    @property
    def parent(self) -> "CollectionReference":
        return CollectionReference(self.store, self.path.rsplit("/", maxsplit=1)[0])


class CollectionReference:
    def __init__(self, store: dict[str, dict[str, Any]], path: str):
        self.store = store
        self.path = path

    def document(self, document_id: str) -> DocumentReference:
        return DocumentReference(self.store, f"{self.path}/{document_id}")

    @property
    def parent(self) -> DocumentReference | None:
        if "/" not in self.path:
            return None
        return DocumentReference(self.store, self.path.rsplit("/", maxsplit=1)[0])


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

    def get(self, reference: DocumentReference | CollectionReference):  # type: ignore[no-untyped-def]
        if isinstance(reference, CollectionReference):
            prefix = f"{reference.path}/"
            depth = prefix.count("/")
            return [
                Snapshot(value, DocumentReference(self.store, path))
                for path, value in sorted(self.store.items())
                if path.startswith(prefix) and path.count("/") == depth
            ]
        return Snapshot(self.store.get(reference.path), reference)

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

    def delete(self, reference: DocumentReference) -> None:
        if reference.path not in self.store:
            raise RuntimeError("document does not exist")
        del self.store[reference.path]
