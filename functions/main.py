from firebase_functions.options import set_global_options
from firebase_functions import firestore_fn, logger
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
    sender_name = request_data.get("senderUsername")

    log_context = {
        "requestId": request_id,
        "senderId": sender_id,
        "receiverId": receiver_id
    }

    if not receiver_id or not sender_id:
        logger.error("Invalid request data: Missing sender or receiver ID.", **log_context)
        return

    db = firestore.client()

    try:
        receiver_ref = db.collection("user_settings").document(receiver_id)
        receiver_doc = receiver_ref.get()

        if not receiver_doc.exists:
            logger.warn(f"No settings found for user {receiver_id}", **log_context)
            return

        fcm_token = receiver_doc.to_dict().get("notificationToken")
        if not fcm_token:
            logger.warn(f"No FCM token registered for user {receiver_id}", **log_context)
            return

        message = messaging.Message(
            notification=messaging.Notification(
                title="New Friend Request",
                body=f"{sender_name} wants to be your friend!",
            ),
            data={
                "type": "friend_request",
                "requestId": request_id,
            },
            token=fcm_token,
        )

        response = messaging.send(message)

        logger.info(f"Successfully sent FCM message: {response}", **log_context)

    except Exception as e:
        logger.error(f"Error sending notification: {e}", exc_info=True, **log_context)
