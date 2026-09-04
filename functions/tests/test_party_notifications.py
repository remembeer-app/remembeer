from typing import ClassVar

import pytest
from party_notifications import party_notification_data, send_notification_to_users

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


@pytest.mark.parametrize(
    ("notification_type", "tab"),
    [
        ("party_activated", "activity"),
        ("party_quest_started", "games"),
        ("party_quest_completed", "activity"),
        ("party_challenge_started", "games"),
        ("party_challenge_winner", "activity"),
        ("party_beerpong_enrollment", "games"),
        ("party_beerpong_match_ready", "games"),
        ("party_beerpong_match_result", "games"),
        ("party_beerpong_completed", "ranking"),
        ("party_archived", "activity"),
    ],
)
def test_party_payload_has_stable_destination(
    notification_type: str,
    tab: str,
) -> None:
    assert party_notification_data(
        notification_type,
        "party-a",
        source_id="source-a",
    ) == {
        "type": notification_type,
        "sessionId": "party-a",
        "tab": tab,
        "sourceId": "source-a",
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
    }


def test_party_payload_rejects_unknown_types_and_empty_ids() -> None:
    with pytest.raises(ValueError):
        party_notification_data("unknown", "party-a")
    with pytest.raises(ValueError):
        party_notification_data("party_activated", "")
    with pytest.raises(ValueError):
        party_notification_data("party_quest_started", "party-a", source_id="")
