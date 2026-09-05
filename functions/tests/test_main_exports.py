import ast
from pathlib import Path

CALLABLE_EXPORTS = {
    "activate_party",
    "archive_party",
    "sync_party_membership",
    "select_party_class",
    "set_party_member_class",
    "create_party_drink",
    "update_party_drink",
    "delete_party_drink",
    "set_party_module_settings",
    "create_admin_challenge",
    "award_admin_challenge_winner",
    "complete_admin_challenge",
    "cancel_admin_challenge",
    "reverse_admin_challenge_winner",
    "set_party_quest_schedule",
    "create_custom_quest_template",
    "update_custom_quest_template",
    "delete_custom_quest_template",
    "set_quest_template_enabled",
    "select_quest_partner",
    "set_beerpong_opt_in",
    "create_beerpong_tournament",
    "redraw_beerpong_tournament",
    "draw_beerpong_tournament",
    "rename_beerpong_team",
    "record_beerpong_match_result",
    "correct_beerpong_match_result",
    "finalize_beerpong_tournament",
}


def test_all_party_functions_are_exported_in_europe_west4() -> None:
    module = ast.parse(Path("main.py").read_text())
    functions = {
        node.name: node
        for node in module.body
        if isinstance(node, (ast.FunctionDef, ast.AsyncFunctionDef))
    }

    for name in CALLABLE_EXPORTS:
        assert name in functions
        decorator = functions[name].decorator_list[0]
        assert isinstance(decorator, ast.Call)
        assert ast.unparse(decorator.func) == "https_fn.on_call"
        assert any(
            keyword.arg == "region"
            and isinstance(keyword.value, ast.Name)
            and keyword.value.id == "REGION"
            for keyword in decorator.keywords
        )

    scheduler = functions["party_quest_scheduler"].decorator_list[0]
    assert isinstance(scheduler, ast.Call)
    assert ast.unparse(scheduler.func) == "scheduler_fn.on_schedule"
    keywords = {keyword.arg: keyword.value for keyword in scheduler.keywords}
    assert ast.literal_eval(keywords["schedule"]) == "every 1 minutes"
    assert isinstance(keywords["region"], ast.Name)
    assert keywords["region"].id == "REGION"

    region = next(
        node
        for node in module.body
        if isinstance(node, ast.Assign)
        and any(
            isinstance(target, ast.Name) and target.id == "REGION"
            for target in node.targets
        )
    )
    assert ast.literal_eval(region.value) == "europe-west4"
