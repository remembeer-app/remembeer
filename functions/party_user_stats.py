"""Dart-parity updates for Remembeer's embedded daily and monthly user stats."""

from collections.abc import Mapping
from copy import deepcopy
from datetime import datetime, timedelta
from typing import Any

BEER_VOLUME_ML = 500
DEFAULT_END_OF_DAY_HOUR = 6


def effective_date(consumed_at: datetime, boundary: Mapping[str, Any]) -> datetime:
    """Apply the same wall-clock logical-day boundary as Dart's effectiveDate."""

    hour, minute = _boundary_parts(boundary)
    boundary_at = consumed_at.replace(hour=hour, minute=minute, second=0, microsecond=0)
    return consumed_at - timedelta(days=1) if consumed_at < boundary_at else consumed_at


def apply_drink_stats(
    user: Mapping[str, Any],
    *,
    old_drink: Mapping[str, Any] | None = None,
    new_drink: Mapping[str, Any] | None = None,
) -> dict[str, Any]:
    """Remove and/or add a drink using UserModel/MonthlyStats clamp semantics."""

    updated = deepcopy(dict(user))
    boundary = updated.get("endOfDayBoundary")
    if not isinstance(boundary, Mapping):
        boundary = {"hour": DEFAULT_END_OF_DAY_HOUR, "minute": 0}
    if old_drink is not None:
        _apply_delta(updated, old_drink, boundary, -1)
    if new_drink is not None:
        _apply_delta(updated, new_drink, boundary, 1)
    return updated


def user_stats(user: Mapping[str, Any], *, now: datetime) -> dict[str, Any]:
    """Calculate the aggregate values consumed by BadgeService."""

    monthly_stats = _monthly_stats(user)
    total_beers = 0.0
    total_alcohol = 0.0
    for monthly in monthly_stats.values():
        total_beers += _number(monthly.get("beersConsumed", 0), "beersConsumed")
        total_alcohol += _number(
            monthly.get("alcoholConsumedMl", 0), "alcoholConsumedMl"
        )

    boundary = user.get("endOfDayBoundary")
    if not isinstance(boundary, Mapping):
        boundary = {"hour": DEFAULT_END_OF_DAY_HOUR, "minute": 0}
    today = effective_date(now, boundary)
    is_streak_active = _daily_alcohol(monthly_stats, today) > 0
    cursor = today if is_streak_active else today - timedelta(days=1)
    streak_days = 0
    while _daily_alcohol(monthly_stats, cursor) > 0:
        streak_days += 1
        cursor -= timedelta(days=1)

    return {
        "totalBeersConsumed": total_beers,
        "totalAlcoholConsumed": total_alcohol,
        "streakDays": streak_days,
        "isStreakActive": is_streak_active,
    }


def _apply_delta(
    user: dict[str, Any],
    drink: Mapping[str, Any],
    boundary: Mapping[str, Any],
    direction: int,
) -> None:
    consumed_at = _drink_datetime(drink)
    logical_date = effective_date(consumed_at, boundary)
    drink_type = drink.get("drinkType")
    if not isinstance(drink_type, Mapping):
        raise TypeError("Stored drinkType is invalid")
    category = drink_type.get("category")
    volume = _number(drink.get("volumeInMilliliters"), "volumeInMilliliters")
    percentage = _number(drink_type.get("alcoholPercentage"), "alcoholPercentage")
    beers = volume / BEER_VOLUME_ML if category == "beer" else 0.0
    alcohol = volume * percentage / 100
    after_six = consumed_at > logical_date.replace(
        hour=18, minute=0, second=0, microsecond=0
    )

    monthly_stats = deepcopy(_monthly_stats(user))
    month_key = f"{logical_date.year}_{logical_date.month}"
    monthly = deepcopy(
        monthly_stats.get(
            month_key,
            {
                "year": logical_date.year,
                "month": logical_date.month,
                "beersConsumed": 0.0,
                "alcoholConsumedMl": 0.0,
                "dailyStats": {},
            },
        )
    )
    daily_stats = monthly.get("dailyStats", {})
    if not isinstance(daily_stats, Mapping):
        raise TypeError("Stored dailyStats is invalid")
    daily_stats = deepcopy(dict(daily_stats))
    day_key = str(logical_date.day)
    daily = deepcopy(
        daily_stats.get(
            day_key,
            {
                "day": logical_date.day,
                "beersConsumed": 0.0,
                "alcoholConsumedMl": 0.0,
                "beersAfter6pm": 0.0,
            },
        )
    )

    monthly["beersConsumed"] = _changed(
        monthly.get("beersConsumed", 0), beers, direction
    )
    monthly["alcoholConsumedMl"] = _changed(
        monthly.get("alcoholConsumedMl", 0), alcohol, direction
    )
    daily["beersConsumed"] = _changed(daily.get("beersConsumed", 0), beers, direction)
    daily["alcoholConsumedMl"] = _changed(
        daily.get("alcoholConsumedMl", 0), alcohol, direction
    )
    daily["beersAfter6pm"] = _changed(
        daily.get("beersAfter6pm", 0), beers if after_six else 0, direction
    )
    daily_stats[day_key] = daily
    monthly["dailyStats"] = daily_stats
    monthly_stats[month_key] = monthly
    user["monthlyStats"] = monthly_stats


def _changed(stored: Any, amount: float, direction: int) -> float:
    value = _number(stored, "stored statistic") + direction * amount
    return max(0.0, value) if direction < 0 else value


def _monthly_stats(user: Mapping[str, Any]) -> dict[str, Mapping[str, Any]]:
    value = user.get("monthlyStats", {})
    if not isinstance(value, Mapping) or any(
        not isinstance(key, str) or not isinstance(monthly, Mapping)
        for key, monthly in value.items()
    ):
        raise ValueError("Stored monthlyStats is invalid")
    return dict(value)


def _daily_alcohol(
    monthly_stats: Mapping[str, Mapping[str, Any]], date: datetime
) -> float:
    monthly = monthly_stats.get(f"{date.year}_{date.month}", {})
    daily_stats = monthly.get("dailyStats", {})
    if not isinstance(daily_stats, Mapping):
        raise TypeError("Stored dailyStats is invalid")
    daily = daily_stats.get(str(date.day), {})
    if not isinstance(daily, Mapping):
        raise TypeError("Stored daily statistic is invalid")
    return _number(daily.get("alcoholConsumedMl", 0), "alcoholConsumedMl")


def _boundary_parts(boundary: Mapping[str, Any]) -> tuple[int, int]:
    hour = boundary.get("hour")
    minute = boundary.get("minute")
    if (
        isinstance(hour, bool)
        or not isinstance(hour, int)
        or not 0 <= hour <= 23
        or isinstance(minute, bool)
        or not isinstance(minute, int)
        or not 0 <= minute <= 59
    ):
        raise ValueError("Stored endOfDayBoundary is invalid")
    return hour, minute


def _drink_datetime(drink: Mapping[str, Any]) -> datetime:
    value = drink.get("consumedAt")
    if isinstance(value, datetime):
        return value
    if isinstance(value, str):
        try:
            return datetime.fromisoformat(value.replace("Z", "+00:00"))
        except ValueError as error:
            raise ValueError("Stored consumedAt is invalid") from error
    raise ValueError("Stored consumedAt is invalid")


def _number(value: Any, name: str) -> float:
    if isinstance(value, bool) or not isinstance(value, (int, float)):
        raise TypeError(f"{name} must be numeric")
    return float(value)
