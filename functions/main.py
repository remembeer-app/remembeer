from collections.abc import Mapping
from typing import Any

import party_beerpong
import party_challenges
import party_commands
import party_drinks
import party_quests
import party_scheduler as party_scheduler_module
from firebase_admin import firestore, initialize_app, messaging
from firebase_functions import firestore_fn, https_fn, logger, scheduler_fn
from firebase_functions.options import set_global_options

REGION = "europe-west4"

set_global_options(max_instances=10)

initialize_app()


@https_fn.on_call(region=REGION)
def activate_party(request: Any) -> Mapping[str, Any]:
    return party_commands.activate_party(request)


@https_fn.on_call(region=REGION)
def archive_party(request: Any) -> Mapping[str, Any]:
    return party_commands.archive_party(request)


@https_fn.on_call(region=REGION)
def sync_party_membership(request: Any) -> Mapping[str, Any]:
    return party_commands.sync_party_membership(request)


@https_fn.on_call(region=REGION)
def select_party_class(request: Any) -> Mapping[str, Any]:
    return party_commands.select_party_class(request)


@https_fn.on_call(region=REGION)
def set_party_member_class(request: Any) -> Mapping[str, Any]:
    return party_commands.set_party_member_class(request)


@https_fn.on_call(region=REGION)
def create_party_drink(request: Any) -> Mapping[str, Any]:
    return party_drinks.create_party_drink(request)


@https_fn.on_call(region=REGION)
def update_party_drink(request: Any) -> Mapping[str, Any]:
    return party_drinks.update_party_drink(request)


@https_fn.on_call(region=REGION)
def delete_party_drink(request: Any) -> Mapping[str, Any]:
    return party_drinks.delete_party_drink(request)


@https_fn.on_call(region=REGION)
def set_party_module_settings(request: Any) -> Mapping[str, Any]:
    return party_challenges.set_party_module_settings(request)


@https_fn.on_call(region=REGION)
def create_admin_challenge(request: Any) -> Mapping[str, Any]:
    return party_challenges.create_admin_challenge(request)


@https_fn.on_call(region=REGION)
def award_admin_challenge_winner(request: Any) -> Mapping[str, Any]:
    return party_challenges.award_admin_challenge_winner(request)


@https_fn.on_call(region=REGION)
def complete_admin_challenge(request: Any) -> Mapping[str, Any]:
    return party_challenges.complete_admin_challenge(request)


@https_fn.on_call(region=REGION)
def cancel_admin_challenge(request: Any) -> Mapping[str, Any]:
    return party_challenges.cancel_admin_challenge(request)


@https_fn.on_call(region=REGION)
def reverse_admin_challenge_winner(request: Any) -> Mapping[str, Any]:
    return party_challenges.reverse_admin_challenge_winner(request)


@https_fn.on_call(region=REGION)
def set_party_quest_schedule(request: Any) -> Mapping[str, Any]:
    return party_quests.set_party_quest_schedule(request)


@https_fn.on_call(region=REGION)
def create_custom_quest_template(request: Any) -> Mapping[str, Any]:
    return party_quests.create_custom_quest_template(request)


@https_fn.on_call(region=REGION)
def update_custom_quest_template(request: Any) -> Mapping[str, Any]:
    return party_quests.update_custom_quest_template(request)


@https_fn.on_call(region=REGION)
def delete_custom_quest_template(request: Any) -> Mapping[str, Any]:
    return party_quests.delete_custom_quest_template(request)


@https_fn.on_call(region=REGION)
def set_quest_template_enabled(request: Any) -> Mapping[str, Any]:
    return party_quests.set_quest_template_enabled(request)


@https_fn.on_call(region=REGION)
def select_quest_partner(request: Any) -> Mapping[str, Any]:
    return party_quests.select_quest_partner(request)


@https_fn.on_call(region=REGION)
def set_beerpong_opt_in(request: Any) -> Mapping[str, Any]:
    return party_beerpong.set_beerpong_opt_in(request)


@https_fn.on_call(region=REGION)
def create_beerpong_tournament(request: Any) -> Mapping[str, Any]:
    return party_beerpong.create_beerpong_tournament(request)


@https_fn.on_call(region=REGION)
def redraw_beerpong_tournament(request: Any) -> Mapping[str, Any]:
    return party_beerpong.redraw_beerpong_tournament(request)


@https_fn.on_call(region=REGION)
def draw_beerpong_tournament(request: Any) -> Mapping[str, Any]:
    return party_beerpong.draw_beerpong_tournament(request)


@https_fn.on_call(region=REGION)
def rename_beerpong_team(request: Any) -> Mapping[str, Any]:
    return party_beerpong.rename_beerpong_team(request)


@https_fn.on_call(region=REGION)
def record_beerpong_match_result(request: Any) -> Mapping[str, Any]:
    return party_beerpong.record_beerpong_match_result(request)


@https_fn.on_call(region=REGION)
def correct_beerpong_match_result(request: Any) -> Mapping[str, Any]:
    return party_beerpong.correct_beerpong_match_result(request)


@https_fn.on_call(region=REGION)
def finalize_beerpong_tournament(request: Any) -> Mapping[str, Any]:
    return party_beerpong.finalize_beerpong_tournament(request)


@scheduler_fn.on_schedule(schedule="every 1 minutes", region=REGION)
def party_quest_scheduler(event: scheduler_fn.ScheduledEvent) -> None:
    party_scheduler_module.party_quest_scheduler(event)


@firestore_fn.on_document_created(
    document="friend_requests/{requestId}",
    region=REGION,
)
def on_friend_request_created(
    event: firestore_fn.Event[firestore_fn.DocumentSnapshot],
) -> None:
    request_snapshot = event.data
    if not request_snapshot:
        logger.warn("Received event with no snapshot data.")
        return

    request_id = request_snapshot.id
    request_data = request_snapshot.to_dict() or {}

    receiver_id = request_data.get("toUserId")
    sender_id = request_data.get("userId")
    sender_name = request_data.get("senderUsername", "Someone")

    log_context = {
        "requestId": request_id,
        "senderId": sender_id,
        "receiverId": receiver_id,
        "trigger": "firestore_create",
    }

    if not receiver_id or not sender_id:
        logger.error(
            "Invalid request data: Missing sender or receiver ID.",
            **log_context,
        )
        return

    _send_notification_to_user(
        receiver_id=receiver_id,
        title="New Friend Request",
        body=f"{sender_name} wants to be your friend!",
        data={
            "type": "friend_request_received",
            "requestId": request_id,
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
        },
        log_context=log_context,
    )


@https_fn.on_call(region=REGION)
def notify_friend_request_acceptance(req: https_fn.CallableRequest) -> None:
    receiver_id = req.data.get("toUserId")
    sender_id = req.data.get("fromUserId")
    sender_name = req.data.get("fromUsername", "A friend")

    log_context = {
        "senderId": sender_id,
        "receiverId": receiver_id,
        "trigger": "https_callable",
    }

    if not receiver_id or not sender_id:
        logger.error(
            "Invalid request data: Missing sender or receiver ID.",
            **log_context,
        )
        return

    _send_notification_to_user(
        receiver_id=receiver_id,
        title="Friend Request Accepted",
        body=f"{sender_name} is now your friend!",
        data={
            "type": "friend_request_accepted",
            "fromUserId": sender_id,
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
        },
        log_context=log_context,
    )


@https_fn.on_call(region=REGION)
def notify_added_to_session(req: https_fn.CallableRequest) -> None:
    receiver_id = req.data.get("toUserId")
    sender_name = req.data.get("fromUserName", "A friend")
    session_name = req.data.get("sessionName", "a session")

    log_context = {
        "receiverId": receiver_id,
        "senderName": sender_name,
        "sessionName": session_name,
        "trigger": "https_callable",
    }

    if not receiver_id:
        logger.error("Invalid request data: Missing receiver ID.", **log_context)
        return

    _send_notification_to_user(
        receiver_id=receiver_id,
        title="Added to Session",
        body=f"{sender_name} added you to {session_name}!",
        data={
            "type": "added_to_session",
            "sessionName": session_name,
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
        },
        log_context=log_context,
    )


def _send_notification_to_user(
    receiver_id: str,
    title: str,
    body: str,
    data: dict[str, str],
    log_context: Mapping[str, Any],
) -> dict[str, Any]:
    db = firestore.client()

    try:
        receiver_ref = db.collection("user_settings").document(receiver_id)
        receiver_doc = receiver_ref.get()

        if not receiver_doc.exists:
            logger.warn(f"No settings found for user {receiver_id}", **log_context)
            return {"success": False, "error": "User settings not found"}

        fcm_token = receiver_doc.to_dict().get("notificationToken")
        if not fcm_token:
            logger.warn(
                f"No FCM token registered for user {receiver_id}",
                **log_context,
            )
            return {"success": False, "error": "No FCM token found"}

        message = messaging.Message(
            notification=messaging.Notification(
                title=title,
                body=body,
            ),
            data=data,
            token=fcm_token,
        )

        response = messaging.send(message)
        logger.info(f"Successfully sent FCM message: {response}", **log_context)
        return {"success": True, "messageId": response}

    except Exception as error:  # noqa: BLE001 - Push failure must not fail commands.
        logger.error(
            f"Error sending notification: {error}",
            exc_info=True,
            **log_context,
        )
        return {"success": False, "error": str(error)}
