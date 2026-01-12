from firebase_functions.options import set_global_options
from firebase_functions import firestore_fn, logger, https_fn
from firebase_admin import initialize_app, firestore, messaging

set_global_options(max_instances=10)

initialize_app()

@firestore_fn.on_document_created(
    document="friend_requests/{requestId}",
    region="europe-west4"
)
def on_friend_request_created(event: firestore_fn.Event[firestore_fn.DocumentSnapshot]) -> None:
    request_snapshot = event.data
    if not request_snapshot:
        logger.warn("Received event with no snapshot data.")
        return

    request_id = request_snapshot.id
    request_data = request_snapshot.to_dict()

    receiver_id = request_data.get("toUserId")
    sender_id = request_data.get("userId")
    sender_name = request_data.get("senderUsername", "Someone")

    log_context = {
        "requestId": request_id,
        "senderId": sender_id,
        "receiverId": receiver_id,
        "trigger": "firestore_create"
    }

    if not receiver_id or not sender_id:
        logger.error("Invalid request data: Missing sender or receiver ID.", **log_context)
        return

    _send_notification_to_user(
        receiver_id=receiver_id,
        title="New Friend Request",
        body=f"{sender_name} wants to be your friend!",
        data={
            "type": "friend_request_received",
            "requestId": request_id,
            "click_action": "FLUTTER_NOTIFICATION_CLICK" # Crucial for Android
        },
        log_context=log_context
    )


@https_fn.on_call(region="europe-west4")
def notify_friend_request_acceptance(req: https_fn.CallableRequest):
    receiver_id = req.data.get("toUserId")
    sender_id = req.data.get("fromUserId")
    sender_name = req.data.get("fromUsername", "A friend")

    log_context = {
        "senderId": sender_id,
        "receiverId": receiver_id,
        "trigger": "https_callable"
    }

    if not receiver_id or not sender_id:
        logger.error("Invalid request data: Missing sender or receiver ID.", **log_context)
        return

    _send_notification_to_user(
        receiver_id=receiver_id,
        title="Friend Request Accepted",
        body=f"{sender_name} is now your friend!",
        data={
            "type": "friend_request_accepted",
            "fromUserId": sender_id,
            "click_action": "FLUTTER_NOTIFICATION_CLICK"
        },
        log_context=log_context
    )

@https_fn.on_call(region="europe-west4")
def notify_added_to_session(req: https_fn.CallableRequest):
    receiver_id = req.data.get("toUserId")
    sender_name = req.data.get("fromUserName", "A friend")
    session_name = req.data.get("sessionName", "a session")

    log_context = {
        "receiverId": receiver_id,
        "senderName": sender_name,
        "sessionName": session_name,
        "trigger": "https_callable"
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
            "click_action": "FLUTTER_NOTIFICATION_CLICK"
        },
        log_context=log_context
    )


def _send_notification_to_user(receiver_id: str, title: str, body: str, data: dict, log_context: dict) -> dict:
    db = firestore.client()

    try:
        receiver_ref = db.collection("user_settings").document(receiver_id)
        receiver_doc = receiver_ref.get()

        if not receiver_doc.exists:
            logger.warn(f"No settings found for user {receiver_id}", **log_context)
            return {"success": False, "error": "User settings not found"}

        fcm_token = receiver_doc.to_dict().get("notificationToken")
        if not fcm_token:
            logger.warn(f"No FCM token registered for user {receiver_id}", **log_context)
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

    except Exception as e:
        logger.error(f"Error sending notification: {e}", exc_info=True, **log_context)
        return {"success": False, "error": str(e)}
