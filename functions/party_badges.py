"""Server-side parity for the app's monotonic badge unlock behavior."""

from collections.abc import Mapping
from copy import deepcopy
from datetime import datetime
from typing import Any

from party_user_stats import effective_date, user_stats

MAX_BADGES_SHOWN = 6
TOTAL_BEER_BADGES = {"centurion": 100, "millennial": 1_000}
TOTAL_ALCOHOL_BADGES = {"alchemist": 1_000, "ethanol_engine": 10_000}
STREAK_BADGES = {"finding_the_rhythm": 3, "habit_formed": 7}


def evaluate_badges(
    user: Mapping[str, Any],
    *,
    consumed_at: datetime,
    now: datetime,
) -> dict[str, Any]:
    """Return a user copy with newly met badges unlocked, never revoked."""

    updated = deepcopy(dict(user))
    unlocked = updated.get("unlockedBadges", {})
    if not isinstance(unlocked, Mapping):
        raise TypeError("Stored unlockedBadges is invalid")
    updated["unlockedBadges"] = deepcopy(dict(unlocked))
    stats = user_stats(updated, now=now)

    for badge_id, goal in TOTAL_BEER_BADGES.items():
        if stats["totalBeersConsumed"] >= goal:
            _unlock(updated, badge_id, now)
    for badge_id, goal in TOTAL_ALCOHOL_BADGES.items():
        if stats["totalAlcoholConsumed"] >= goal:
            _unlock(updated, badge_id, now)
    for badge_id, goal in STREAK_BADGES.items():
        if stats["isStreakActive"] and stats["streakDays"] >= goal:
            _unlock(updated, badge_id, now)

    boundary = updated.get("endOfDayBoundary")
    if not isinstance(boundary, Mapping):
        boundary = {"hour": 6, "minute": 0}
    logical_date = effective_date(consumed_at, boundary)
    daily = _daily(updated, logical_date)
    if 6 <= logical_date.hour < 8:
        _unlock(updated, "early_riser", now)
    if _number(daily.get("beersAfter6pm", 0)) >= 10:
        _unlock(updated, "night_animal", now)
    if (now - logical_date).days >= 5:
        _unlock(updated, "you_remembeered", now)
    if _number(daily.get("beersConsumed", 0)) >= 20:
        _unlock(updated, "case_closed", now)
    return updated


def _unlock(user: dict[str, Any], badge_id: str, now: datetime) -> None:
    unlocked: dict[str, Any] = user["unlockedBadges"]
    if badge_id in unlocked:
        return
    shown_count = sum(
        1
        for badge in unlocked.values()
        if isinstance(badge, Mapping) and badge.get("isShown") is True
    )
    unlocked[badge_id] = {
        "badgeId": badge_id,
        "unlockedAt": now.isoformat(),
        "isShown": shown_count < MAX_BADGES_SHOWN,
    }


def _daily(user: Mapping[str, Any], date: datetime) -> Mapping[str, Any]:
    monthly_stats = user.get("monthlyStats", {})
    if not isinstance(monthly_stats, Mapping):
        raise TypeError("Stored monthlyStats is invalid")
    monthly = monthly_stats.get(f"{date.year}_{date.month}", {})
    if not isinstance(monthly, Mapping):
        raise TypeError("Stored monthly statistic is invalid")
    daily_stats = monthly.get("dailyStats", {})
    if not isinstance(daily_stats, Mapping):
        raise TypeError("Stored dailyStats is invalid")
    daily = daily_stats.get(str(date.day), {})
    if not isinstance(daily, Mapping):
        raise TypeError("Stored daily statistic is invalid")
    return daily


def _number(value: Any) -> float:
    if isinstance(value, bool) or not isinstance(value, (int, float)):
        raise TypeError("Stored badge statistic must be numeric")
    return float(value)
