from datetime import datetime, timedelta, timezone

from party_badges import evaluate_badges
from party_user_stats import apply_drink_stats

NOW = datetime(2026, 1, 10, 12, tzinfo=timezone.utc)


def _user() -> dict[str, object]:
    return {
        "monthlyStats": {},
        "unlockedBadges": {},
        "endOfDayBoundary": {"hour": 6, "minute": 0},
    }


def _beer(at: datetime, volume: int = 500) -> dict[str, object]:
    return {
        "consumedAt": at.isoformat(),
        "drinkType": {
            "name": "Beer",
            "category": "beer",
            "alcoholPercentage": 5.0,
        },
        "volumeInMilliliters": volume,
    }


def test_total_streak_and_one_time_badges_match_dart_thresholds() -> None:
    user = _user()
    for days_ago in (2, 1, 0):
        user = apply_drink_stats(
            user,
            new_drink=_beer(NOW - timedelta(days=days_ago), volume=20_000),
        )

    updated = evaluate_badges(user, consumed_at=NOW, now=NOW)
    unlocked = updated["unlockedBadges"]

    assert {
        "centurion",
        "alchemist",
        "finding_the_rhythm",
        "case_closed",
    }.issubset(unlocked)
    assert "millennial" not in unlocked
    assert "habit_formed" not in unlocked


def test_effective_timestamp_controls_early_and_late_logging_badges() -> None:
    consumed_at = NOW - timedelta(days=6, hours=5)
    user = apply_drink_stats(_user(), new_drink=_beer(consumed_at))

    updated = evaluate_badges(user, consumed_at=consumed_at, now=NOW)

    assert "early_riser" in updated["unlockedBadges"]
    assert "you_remembeered" in updated["unlockedBadges"]


def test_badges_are_not_revoked_and_only_six_are_shown() -> None:
    user = _user()
    user["unlockedBadges"] = {
        f"existing-{index}": {
            "badgeId": f"existing-{index}",
            "unlockedAt": NOW.isoformat(),
            "isShown": True,
        }
        for index in range(6)
    }
    user["unlockedBadges"]["centurion"] = {
        "badgeId": "centurion",
        "unlockedAt": NOW.isoformat(),
        "isShown": False,
    }
    drink = _beer(NOW.replace(hour=7))
    user = apply_drink_stats(user, new_drink=drink)
    updated = evaluate_badges(user, consumed_at=NOW.replace(hour=7), now=NOW)

    assert "centurion" in updated["unlockedBadges"]
    assert updated["unlockedBadges"]["early_riser"]["isShown"] is False
