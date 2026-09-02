"""Best-effort FCM helpers shared by Party backend features.

Notification failure must never roll back authoritative Party state. Call these
helpers only after a command transaction commits.
"""

from collections.abc import Iterable, Mapping
from typing import Any

from firebase_admin import messaging
from firebase_functions import logger


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
