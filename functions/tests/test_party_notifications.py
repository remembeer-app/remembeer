from typing import ClassVar

from party_notifications import send_notification_to_users

from tests.fakes import Database


class Messenger:
    sent: ClassVar[list] = []

    class Notification:
        def __init__(self, *, title: str, body: str):
            self.title = title
            self.body = body

    class Message:
        def __init__(self, **values):  # type: ignore[no-untyped-def]
            self.__dict__.update(values)

    @classmethod
    def send(cls, message):  # type: ignore[no-untyped-def]
        cls.sent.append(message)
        return f"message-{len(cls.sent)}"


class Log:
    def warn(self, *_args, **_kwargs):  # type: ignore[no-untyped-def]
        pass

    def info(self, *_args, **_kwargs):  # type: ignore[no-untyped-def]
        pass

    def error(self, *_args, **_kwargs):  # type: ignore[no-untyped-def]
        pass


def test_fan_out_deduplicates_recipients_and_excludes_actor() -> None:
    Messenger.sent = []
    db = Database(
        {
            "user_settings/actor": {"notificationToken": "actor-token"},
            "user_settings/user-a": {"notificationToken": "token-a"},
            "user_settings/user-b": {"notificationToken": "token-b"},
        }
    )
    results = send_notification_to_users(
        db,
        ["actor", "user-a", "user-a", "user-b"],
        actor_user_id="actor",
        title="Party",
        body="A thing happened",
        data={"type": "party_event", "sessionId": "party-a"},
        messenger=Messenger,
        log=Log(),
    )
    assert list(results) == ["user-a", "user-b"]
    assert len(Messenger.sent) == 2
    assert {message.token for message in Messenger.sent} == {"token-a", "token-b"}
