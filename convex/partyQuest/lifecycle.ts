import { ConvexError } from "convex/values";
import type { Doc, Id } from "../_generated/dataModel";
import type { MutationCtx } from "../_generated/server";
import { internal } from "../_generated/api";
import { builtInQuests } from "./catalog";
import { loadQuestContext } from "./context";
import { eligiblePairs } from "./eligibility";
import {
  earlyQuestCount,
  regularQuestCount,
  questCycleLength,
  minQuestDurationMinutes,
  maxQuestDurationMinutes,
  minQuestIntervalMinutes,
  maxQuestIntervalMinutes,
  millisecondsPerMinute,
} from "./constants";

export type Party = Extract<Doc<"session">, { kind: "party" }>;
type Schedule = Party["questSchedule"];

export function validateSchedule(
  schedule: Pick<Schedule, "minIntervalMinutes" | "maxIntervalMinutes" | "defaultDurationMinutes">,
) {
  const {
    minIntervalMinutes: min,
    maxIntervalMinutes: max,
    defaultDurationMinutes: duration,
  } = schedule;
  if (
    !Number.isInteger(min) ||
    !Number.isInteger(max) ||
    min < minQuestIntervalMinutes ||
    max > maxQuestIntervalMinutes ||
    min > max
  )
    throw new ConvexError(
      "Quest intervals must be whole minutes from 5 to 180, with minimum <= maximum",
    );

  if (
    !Number.isInteger(duration) ||
    duration < minQuestDurationMinutes ||
    duration > maxQuestDurationMinutes
  )
    throw new ConvexError("Invalid quest duration: use whole minutes from 1 to 60");
}

export function randomBreak(schedule: Schedule) {
  return (
    (schedule.minIntervalMinutes +
      Math.floor(Math.random() * (schedule.maxIntervalMinutes - schedule.minIntervalMinutes + 1))) *
    millisecondsPerMinute
  );
}

export function activeQuests(ctx: MutationCtx, sessionId: Id<"session">) {
  return ctx.db
    .query("partyQuest")
    .withIndex("by_sessionId_and_status", (q) =>
      q.eq("sessionId", sessionId).eq("status", "active"),
    )
    .collect();
}

export async function cancelJob(ctx: MutationCtx, party: Party) {
  if (party.questSchedule.scheduledFunctionId !== null)
    await ctx.scheduler.cancel(party.questSchedule.scheduledFunctionId);
}

export async function stopQuests(ctx: MutationCtx, session: Doc<"session">, now: number) {
  if (session.kind !== "party") return;

  await cancelJob(ctx, session);

  for (const quest of await activeQuests(ctx, session._id)) {
    await ctx.db.patch("partyQuest", quest._id, {
      status: quest.endsAt <= now ? "expired" : "cancelled",
      updatedAt: now,
    });
  }

  await ctx.db.patch("session", session._id, {
    modules: { ...session.modules, socialQuestsEnabled: false },
    questSchedule: {
      ...session.questSchedule,
      nextQuestAt: null,
      scheduledFunctionId: null,
    },
    updatedAt: now,
  });
}

export async function scheduleExpiry(
  ctx: MutationCtx,
  party: Party,
  quest: Doc<"partyQuest">,
  nextQuestAt: number,
  now: number,
) {
  const scheduledFunctionId = await ctx.scheduler.runAt(quest.endsAt, internal.partyQuest.expire, {
    sessionId: party._id,
    questId: quest._id,
    nextQuestAt,
  });

  await ctx.db.patch("session", party._id, {
    questSchedule: { ...party.questSchedule, nextQuestAt, scheduledFunctionId },
    updatedAt: now,
  });
}

export async function scheduleIssuance(
  ctx: MutationCtx,
  party: Party,
  nextQuestAt: number,
  now: number,
) {
  const scheduledFunctionId = await ctx.scheduler.runAt(nextQuestAt, internal.partyQuest.issue, {
    sessionId: party._id,
    nextQuestAt,
  });

  await ctx.db.patch("session", party._id, {
    questSchedule: { ...party.questSchedule, nextQuestAt, scheduledFunctionId },
    updatedAt: now,
  });
}

// Auth belongs to callers; scheduled mutations use the same issuance path.
export async function issueQuest(
  ctx: MutationCtx,
  party: Party,
  now: number,
): Promise<Id<"partyQuest">> {
  const active = await activeQuests(ctx, party._id);

  const running = active.find((quest) => quest.endsAt > now);
  if (running) {
    if (
      party.questSchedule.scheduledFunctionId === null ||
      party.questSchedule.nextQuestAt === null
    ) {
      await cancelJob(ctx, party);
      await scheduleExpiry(
        ctx,
        party,
        running,
        party.questSchedule.nextQuestAt ?? running.endsAt + randomBreak(party.questSchedule),
        now,
      );
    }

    return running._id;
  }

  validateSchedule(party.questSchedule);
  await cancelJob(ctx, party);

  for (const quest of active)
    await ctx.db.patch("partyQuest", quest._id, {
      status: "expired",
      updatedAt: now,
    });

  const quests = await ctx.db
    .query("partyQuest")
    .withIndex("by_sessionId_and_startsAt", (q) => q.eq("sessionId", party._id))
    .collect();

  const cycleCount = quests.length % questCycleLength;
  const cycle = cycleCount === 0 ? [] : quests.slice(-cycleCount);
  const identity = (quest: { kind: string; drinkCategory?: { kind: string } }) =>
    `${quest.kind}:${quest.drinkCategory?.kind ?? ""}`;
  const used = new Set(cycle.map(identity));
  const beerpongContext =
    party.modules.beerpongEnabled && cycleCount >= earlyQuestCount
      ? await loadQuestContext(ctx, party, now)
      : null;

  const candidates = builtInQuests.filter(
    (quest) =>
      (!["differentBeerpongTeam", "sameBeerpongTeam", "finalistTeam"].includes(quest.kind) ||
        (beerpongContext !== null &&
          eligiblePairs(
            quest,
            beerpongContext.players,
            beerpongContext.previousPairs,
            beerpongContext.finalistTeamIds,
          ).length > 0)) &&
      (quest.availability === "early" ||
        (quest.availability === "regular" && cycleCount >= earlyQuestCount) ||
        (quest.availability === "final" && cycleCount >= regularQuestCount)),
  );
  const unused = candidates.filter((quest) => !used.has(identity(quest)));
  const choices = unused.length ? unused : candidates;
  const chosen = choices[Math.floor(Math.random() * choices.length)];
  if (!chosen) throw new ConvexError("No quest templates available");

  const { availability, ...definition } = chosen;
  const endsAt = now + party.questSchedule.defaultDurationMinutes * millisecondsPerMinute;
  const fields = {
    ...definition,
    sessionId: party._id,
    startsAt: now,
    endsAt,
    status: "active" as const,
    updatedAt: now,
    selections: [],
    results: [],
  };
  const questId = await ctx.db.insert("partyQuest", fields);

  await scheduleExpiry(
    ctx,
    party,
    { ...fields, _id: questId, _creationTime: now },
    endsAt + randomBreak(party.questSchedule),
    now,
  );

  return questId;
}

export async function ensureLifecycle(ctx: MutationCtx, party: Party, now: number) {
  const active = await activeQuests(ctx, party._id);
  if (active.some((quest) => quest.endsAt > now)) {
    await issueQuest(ctx, party, now);

    return;
  }

  if (party.questSchedule.nextQuestAt !== null) {
    if (party.questSchedule.scheduledFunctionId === null) {
      for (const quest of active)
        await ctx.db.patch("partyQuest", quest._id, {
          status: "expired",
          updatedAt: now,
        });

      await scheduleIssuance(ctx, party, party.questSchedule.nextQuestAt, now);
    }

    return;
  }

  await issueQuest(ctx, party, now);
}
