from datetime import datetime, timezone

import pytest
from party_user_stats import apply_drink_stats, effective_date, user_stats


def _drink(
    consumed_at: str,
    *,
    category: str = "beer",
    volume: int = 500,
    percentage: float = 5,
) -> dict[str, object]:
    return {
        "consumedAt": consumed_at,
        "drinkType": {
            "name": category,
            "category": category,
            "alcoholPercentage": percentage,
        },
        "volumeInMilliliters": volume,
    }


def _user() -> dict[str, object]:
    return {
        "monthlyStats": {},
        "endOfDayBoundary": {"hour": 6, "minute": 0},
    }


def test_effective_date_uses_strict_custom_boundary() -> None:
    boundary = {"hour": 6, "minute": 30}

    assert (
        effective_date(datetime.fromisoformat("2026-03-01T06:29:59"), boundary)
        .date()
        .isoformat()
        == "2026-02-28"
    )
    assert (
        effective_date(datetime.fromisoformat("2026-03-01T06:30:00"), boundary)
        .date()
        .isoformat()
        == "2026-03-01"
    )


def test_add_remove_matches_dart_monthly_daily_and_after_six_calculations() -> None:
    user = _user()
    beer = _drink("2026-02-02T02:00:00+01:00")
    wine = _drink(
        "2026-02-01T17:00:00+01:00",
        category="wine",
        volume=200,
        percentage=12,
    )

    updated = apply_drink_stats(user, new_drink=beer)
    updated = apply_drink_stats(updated, new_drink=wine)
    stats = updated["monthlyStats"]["2026_2"]
    daily = stats["dailyStats"]["1"]

    assert stats["beersConsumed"] == 1
    assert stats["alcoholConsumedMl"] == 49
    assert daily == {
        "day": 1,
        "beersConsumed": 1,
        "alcoholConsumedMl": 49,
        "beersAfter6pm": 1,
    }
    removed = apply_drink_stats(updated, old_drink=beer)
    assert removed["monthlyStats"]["2026_2"]["dailyStats"]["1"] == {
        "day": 1,
        "beersConsumed": 0,
        "alcoholConsumedMl": 24,
        "beersAfter6pm": 0,
    }


def test_remove_clamps_each_stat_at_zero_like_dart_models() -> None:
    removed = apply_drink_stats(_user(), old_drink=_drink("2026-01-01T20:00:00"))
    stats = removed["monthlyStats"]["2026_1"]

    assert stats["beersConsumed"] == 0
    assert stats["alcoholConsumedMl"] == 0
    assert stats["dailyStats"]["1"]["beersAfter6pm"] == 0


def test_streak_uses_current_logical_day_and_previous_day_fallback() -> None:
    user = _user()
    for day in (1, 2, 3):
        user = apply_drink_stats(
            user,
            new_drink=_drink(f"2026-01-{day:02}T20:00:00+00:00"),
        )

    active = user_stats(user, now=datetime.fromisoformat("2026-01-04T02:00:00+00:00"))
    inactive = user_stats(user, now=datetime.fromisoformat("2026-01-04T12:00:00+00:00"))

    assert active["isStreakActive"] is True
    assert active["streakDays"] == 3
    assert inactive["isStreakActive"] is False
    assert inactive["streakDays"] == 3


def test_invalid_boundary_is_rejected() -> None:
    with pytest.raises(ValueError, match="endOfDayBoundary"):
        effective_date(datetime.now(timezone.utc), {"hour": 24, "minute": 0})
