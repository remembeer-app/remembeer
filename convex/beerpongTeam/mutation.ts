import { ConvexError, v } from "convex/values";
import { convexToZod } from "convex-helpers/server/zod4";
import { WithZod } from "fluent-convex/zod";
import { z } from "zod";
import { authMutation } from "../lib/authenticated";
import { getMembership } from "../session/access";
import { editableTeamAccess } from "./access";
import { maxTeamNameLength } from "./constants";

const memberInput = { id: v.id("beerpongTeam"), userId: v.id("user") };

export const rename = authMutation
  .extend(WithZod)
  .input(z.object({
    id: convexToZod(v.id("beerpongTeam")),
    name: z.string().trim().min(1).max(maxTeamNameLength),
  }))
  .returns(v.null())
  .extend(editableTeamAccess().extend)
  .handler(async (ctx, { id, name }) => {
    const { team } = ctx;

    const now = Date.now();
    await ctx.db.patch("beerpongTeam", id, { name, updatedAt: now });
    await ctx.db.patch("beerpongTournament", team.tournamentId, { updatedAt: now });

    return null;
  });

export const addMember = authMutation
  .input(memberInput)
  .returns(v.null())
  .extend(editableTeamAccess().extend)
  .handler(async (ctx, { id, userId }) => {
    const { team, tournament } = ctx;

    const member = await getMembership(ctx, tournament.sessionId, userId);
    if (
      member?.kind !== "partyMember" ||
      member.sessionMemberStatus.kind !== "joined" ||
      !(await ctx.db.get("user", userId))
    )
      throw new ConvexError("Player must be a joined party member");

    const teams = await ctx.db
      .query("beerpongTeam")
      .withIndex("by_tournamentId", (q) => q.eq("tournamentId", team.tournamentId))
      .collect();
    if (teams.some((other) => other._id !== id && other.memberUserIds.includes(userId)))
      throw new ConvexError("Player already belongs to another team; move them instead");

    if (team.memberUserIds.includes(userId)) return null;

    const now = Date.now();
    await ctx.db.patch("beerpongTeam", id, {
      memberUserIds: [...team.memberUserIds, userId], updatedAt: now,
    });
    await ctx.db.patch("beerpongTournament", team.tournamentId, { updatedAt: now });

    return null;
  });

export const removeMember = authMutation
  .input(memberInput)
  .returns(v.null())
  .extend(editableTeamAccess().extend)
  .handler(async (ctx, { id, userId }) => {
    const { team } = ctx;
    if (!team.memberUserIds.includes(userId)) return null;

    const now = Date.now();
    await ctx.db.patch("beerpongTeam", id, {
      memberUserIds: team.memberUserIds.filter((memberId) => memberId !== userId),
      updatedAt: now,
    });
    await ctx.db.patch("beerpongTournament", team.tournamentId, { updatedAt: now });

    return null;
  });

export const moveMember = authMutation
  .input({ ...memberInput, targetTeamId: v.id("beerpongTeam") })
  .returns(v.null())
  .extend(editableTeamAccess().extend)
  .handler(async (ctx, { id, userId, targetTeamId }) => {
    const { team, tournament } = ctx;

    const target = await ctx.db.get("beerpongTeam", targetTeamId);
    if (!target) throw new ConvexError("Target team not found");

    if (target.tournamentId !== team.tournamentId)
      throw new ConvexError("Teams must belong to the same tournament");

    if (!team.memberUserIds.includes(userId))
      throw new ConvexError("Player does not belong to the source team");

    const member = await getMembership(ctx, tournament.sessionId, userId);
    if (
      member?.kind !== "partyMember" ||
      member.sessionMemberStatus.kind !== "joined" ||
      !(await ctx.db.get("user", userId))
    )
      throw new ConvexError("Player must be a joined party member");

    if (id === targetTeamId) return null;

    const now = Date.now();
    await ctx.db.patch("beerpongTeam", id, {
      memberUserIds: team.memberUserIds.filter((memberId) => memberId !== userId),
      updatedAt: now,
    });
    await ctx.db.patch("beerpongTeam", targetTeamId, {
      memberUserIds: [...target.memberUserIds.filter((memberId) => memberId !== userId), userId],
      updatedAt: now,
    });
    await ctx.db.patch("beerpongTournament", team.tournamentId, { updatedAt: now });

    return null;
  });
