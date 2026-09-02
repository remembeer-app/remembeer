from decimal import Decimal

import pytest
from firebase_functions import https_fn
from party_scoring import (
    AwardInput,
    calculate_drink_score,
    canonical_pair_key,
    create_award,
    create_awards,
    create_reversal,
    deterministic_event_id,
)

from tests.fakes import Database, Transaction


def test_drink_score_base_and_matching_class_bonus() -> None:
    matching = calculate_drink_score(
        500,
        5,
        drink_category="beer",
        selected_class="beer",
    )
    assert matching.alcohol_ml == Decimal(25)
    assert matching.base_units == 25_000
    assert matching.class_bonus_units == 2_500
    assert matching.awarded_units == 27_500
    assert matching.applied_multiplier == Decimal("1.1")

    base_only = calculate_drink_score(
        500,
        5,
        drink_category="beer",
        selected_class="wine",
    )
    assert base_only.awarded_units == 25_000
    assert base_only.class_bonus_units == 0


def test_drink_score_uses_half_up_rounding_for_base_and_bonus() -> None:
    base_boundary = calculate_drink_score(
        Decimal(1),
        Decimal("0.05"),
        drink_category="spirit",
        selected_class=None,
    )
    assert base_boundary.base_units == 1

    bonus_boundary = calculate_drink_score(
        Decimal(1),
        Decimal("4.5"),
        drink_category="spirit",
        selected_class="spirit",
    )
    assert bonus_boundary.base_units == 45
    assert bonus_boundary.class_bonus_units == 5


def test_canonical_pair_and_event_ids_are_stable_and_collision_safe() -> None:
    assert canonical_pair_key("user:b", "user/a") == canonical_pair_key(
        "user/a", "user:b"
    )
    assert canonical_pair_key("user:b", "user/a") == "pair:user%2Fa:user%3Ab"
    assert deterministic_event_id("drink", "a/b", "v", "1") == "drink:a%2Fb:v:1"
    with pytest.raises(ValueError):
        canonical_pair_key("same", "same")


def test_award_and_reversal_are_atomic_immutable_and_exactly_once() -> None:
    db = Database(
        {
            "parties/party-a/members/user-a": {
                "scoreUnits": 100,
                "drinkCount": 0,
            }
        }
    )
    party_ref = db.collection("parties").document("party-a")
    transaction = Transaction(db.store)
    event_id = deterministic_event_id("drink", "drink-a", "v", "1")
    award = create_award(
        transaction,
        party_ref,
        event_id=event_id,
        kind="drink",
        recipient_user_id="user-a",
        participant_ids=["user-a", "user-a"],
        points_units=25_000,
        source_collection="drinks",
        source_id="drink-a",
        occurred_at="award-time",
        payload={"category": "beer"},
    )
    assert award.created
    assert transaction.created_paths == [f"parties/party-a/events/{event_id}"]
    assert transaction.updated_paths == ["parties/party-a/members/user-a"]
    assert db.store["parties/party-a/members/user-a"]["scoreUnits"] == 25_100
    assert db.store["parties/party-a/members/user-a"]["drinkCount"] == 1

    duplicate = create_award(
        transaction,
        party_ref,
        event_id=event_id,
        kind="drink",
        recipient_user_id="user-a",
        participant_ids=["user-a"],
        points_units=25_000,
        source_collection="drinks",
        source_id="drink-a",
        occurred_at="award-time",
        payload={"category": "beer"},
    )
    assert not duplicate.created
    assert db.store["parties/party-a/members/user-a"]["scoreUnits"] == 25_100

    reversal = create_reversal(
        transaction,
        party_ref,
        award_event_id=event_id,
        occurred_at="reversal-time",
        actor_user_id="admin-a",
        reason="Correction",
    )
    assert reversal.created
    assert reversal.event["pointsUnits"] == -25_000
    assert reversal.event["reversesEventId"] == event_id
    assert db.store["parties/party-a/members/user-a"]["scoreUnits"] == 100
    assert db.store["parties/party-a/members/user-a"]["drinkCount"] == 0

    duplicate_reversal = create_reversal(
        transaction,
        party_ref,
        award_event_id=event_id,
        occurred_at="different-retry-time",
        actor_user_id="someone-else",
    )
    assert not duplicate_reversal.created
    assert db.store["parties/party-a/members/user-a"]["scoreUnits"] == 100


def test_deterministic_award_id_rejects_different_content() -> None:
    db = Database(
        {"parties/party-a/members/user-a": {"scoreUnits": 0, "drinkCount": 0}}
    )
    party_ref = db.collection("parties").document("party-a")
    transaction = Transaction(db.store)
    arguments = {
        "event_id": "challenge:one:winner:user-a",
        "kind": "adminChallenge",
        "recipient_user_id": "user-a",
        "participant_ids": ["user-a"],
        "source_collection": "challenges",
        "source_id": "one",
        "occurred_at": "now",
    }
    create_award(transaction, party_ref, points_units=1_000, **arguments)
    with pytest.raises(https_fn.HttpsError) as error:
        create_award(transaction, party_ref, points_units=2_000, **arguments)
    assert error.value.code == https_fn.FunctionsErrorCode.ALREADY_EXISTS


def test_bulk_awards_group_member_aggregate_update() -> None:
    db = Database(
        {"parties/party-a/members/user-a": {"scoreUnits": 0, "drinkCount": 0}}
    )
    party_ref = db.collection("parties").document("party-a")
    transaction = Transaction(db.store)
    results = create_awards(
        transaction,
        party_ref,
        [
            AwardInput(
                event_id=f"drink:drink-{revision}:v:1",
                kind="drink",
                recipient_user_id="user-a",
                participant_ids=["user-a"],
                points_units=revision * 1_000,
                source_collection="drinks",
                source_id=f"drink-{revision}",
                occurred_at=f"time-{revision}",
            )
            for revision in (1, 2)
        ],
    )
    assert all(result.created for result in results)
    assert db.store["parties/party-a/members/user-a"]["scoreUnits"] == 3_000
    assert db.store["parties/party-a/members/user-a"]["drinkCount"] == 2
    assert transaction.updated_paths == ["parties/party-a/members/user-a"]
