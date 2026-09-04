"""Best-effort FCM helpers shared by Party backend features.

Notification failure must never roll back authoritative Party state. Call these
helpers only after a command transaction commits.
"""

from collections.abc import Iterable, Mapping
from typing import Any

from firebase_admin import messaging
from firebase_functions import logger

PARTY_NOTIFICATION_DESTINATIONS = {
    "party_activated": "activity",
    "party_quest_started": "games",
    "party_quest_completed": "activity",
    "party_challenge_started": "games",
    "party_challenge_winner": "activity",
    "party_beerpong_enrollment": "games",
    "party_beerpong_match_ready": "games",
    "party_beerpong_match_result": "games",
    "party_beerpong_completed": "ranking",
    "party_archived": "activity",
}


def party_notification_data(
    notification_type: str,
    session_id: str,
    *,
    source_id: str | None = None,
) -> Mapping[str, str]:
    """Build the stable FCM data contract consumed by the Flutter client."""

    destination = PARTY_NOTIFICATION_DESTINATIONS.get(notification_type)
    if destination is None:
        raise ValueError(f"Unsupported Party notification type: {notification_type}")
    if not session_id:
        raise ValueError("session_id must not be empty")
    if source_id is not None and not source_id:
        raise ValueError("source_id must not be empty")

    data = {
        "type": notification_type,
        "sessionId": session_id,
        "tab": destination,
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
    }
    if source_id is not None:
        data["sourceId"] = source_id
    return data


def send_notification_to_user(
    db: Any,
    receiver_user_id: str,
    *,
    title: str,
    body: str,
    data: Mapping[str, str],
    messenger: Any = messaging,
    log: Any = logger,
) -> Mapping[str, Any]:
    """Send one FCM notification, returning a result instead of raising."""

    context = {"receiverUserId": receiver_user_id}
    try:
        settings = db.collection("user_settings").document(receiver_user_id).get()
        if not settings.exists:
            log.warn("No notification settings found.", **context)  # noqa: G010
            return {"success": False, "error": "user-settings-not-found"}
        token = (settings.to_dict() or {}).get("notificationToken")
        if not isinstance(token, str) or not token:
            log.warn("No FCM token registered.", **context)  # noqa: G010
            return {"success": False, "error": "fcm-token-not-found"}
        if any(
            not isinstance(key, str) or not isinstance(value, str)
            for key, value in data.items()
        ):
            raise ValueError("FCM data keys and values must be strings")

        message = messenger.Message(
            notification=messenger.Notification(title=title, body=body),
            data=dict(data),
            token=token,
        )
        message_id = messenger.send(message)
        log.info("Party notification sent.", messageId=message_id, **context)
        return {"success": True, "messageId": message_id}
    except Exception as error:  # Notification delivery is deliberately best-effort.
        log.error(  # noqa: G201
            "Party notification failed.",
            error=str(error),
            exc_info=True,
            **context,
        )
        return {"success": False, "error": str(error)}


def send_notification_to_users(
    db: Any,
    recipient_user_ids: Iterable[str],
    *,
    actor_user_id: str | None,
    title: str,
    body: str,
    data: Mapping[str, str],
    messenger: Any = messaging,
    log: Any = logger,
) -> Mapping[str, Mapping[str, Any]]:
    """Send once per distinct recipient, always excluding the actor."""

    recipients = dict.fromkeys(recipient_user_ids)
    if actor_user_id is not None:
        recipients.pop(actor_user_id, None)
    return {
        user_id: send_notification_to_user(
            db,
            user_id,
            title=title,
            body=body,
            data=data,
            messenger=messenger,
            log=log,
        )
        for user_id in recipients
    }
