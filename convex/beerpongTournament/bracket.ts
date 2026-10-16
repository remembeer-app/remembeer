import type { Doc, Id } from "../_generated/dataModel";
import type { AuthMutationCtx } from "../lib/authenticated";

type Slot = Doc<"beerpongMatch">["slotA"];

export async function createBracket(
  ctx: AuthMutationCtx,
  tournament: Doc<"beerpongTournament">,
  teamIds: Id<"beerpongTeam">[],
  now: number,
) {
  for (let index = teamIds.length - 1; index > 0; index--) {
    const other = Math.floor(Math.random() * (index + 1));

    [teamIds[index], teamIds[other]] = [teamIds[other]!, teamIds[index]!];
  }

  // Spread the empty slots across the bracket so no match has two byes.
  // These positions are temporary; the stored matches define the bracket.
  let positions = [1, 2];

  while (positions.length < teamIds.length) {
    const size = positions.length * 2;

    positions = positions.flatMap((position) => [position, size + 1 - position]);
  }

  const slot = (position: number): Slot => {
    const teamId = teamIds[position - 1];

    return teamId ? { kind: "team", teamId } : { kind: "bye" };
  };
  let previous: Id<"beerpongMatch">[] = [];

  for (let index = 0; index < positions.length; index += 2) {
    const slotA = slot(positions[index]!);
    const slotB = slot(positions[index + 1]!);
    const byeWinner =
      slotA.kind === "bye" && slotB.kind === "team"
        ? slotB.teamId
        : slotB.kind === "bye" && slotA.kind === "team"
          ? slotA.teamId
          : null;

    previous.push(
      await ctx.db.insert("beerpongMatch", {
        tournamentId: tournament._id,
        round: 1,
        position: index / 2 + 1,
        kind: "main",
        slotA,
        slotB,
        winnerTeamId: byeWinner,
        completedAt: byeWinner === null ? null : now,
        updatedAt: now,
      }),
    );
  }

  let round = 1;
  let semifinals: Id<"beerpongMatch">[] = [];

  while (previous.length > 1) {
    if (previous.length === 2) semifinals = previous;

    round++;

    const current: Id<"beerpongMatch">[] = [];

    for (let index = 0; index < previous.length; index += 2) {
      current.push(
        await ctx.db.insert("beerpongMatch", {
          tournamentId: tournament._id,
          round,
          position: index / 2 + 1,
          kind: "main",
          slotA: { kind: "winner", matchId: previous[index]! },
          slotB: { kind: "winner", matchId: previous[index + 1]! },
          winnerTeamId: null,
          completedAt: null,
          updatedAt: now,
        }),
      );
    }

    previous = current;
  }

  // Two semifinal losers exist only with at least four teams.
  if (tournament.thirdPlaceEnabled && teamIds.length >= 4) {
    await ctx.db.insert("beerpongMatch", {
      tournamentId: tournament._id,
      round,
      position: 2,
      kind: "thirdPlace",
      slotA: { kind: "loser", matchId: semifinals[0]! },
      slotB: { kind: "loser", matchId: semifinals[1]! },
      winnerTeamId: null,
      completedAt: null,
      updatedAt: now,
    });
  }
}
