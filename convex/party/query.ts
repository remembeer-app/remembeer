import { ConvexError, v } from "convex/values";
import { authQuery } from "../lib/authenticated";
import { requireSessionAccess } from "../session/access";
import { publicUserValidator } from "../user/publicProfile";
import { drinkCategoryValidator } from "../drink/schema";
import { loadPartyScores } from "./scores";
import { rankByScore } from "./scoring";

// All joined party members rank, including members without a class. Scores use
// the current class/catalogue and recorded quest results, also for ended parties.
// Points are integer units (1000 per point); drinkCount counts live log rows.
export const standings = authQuery
  .input({ sessionId: v.id("session") })
  .returns(
    v.object({
      entries: v.array(
        v.object({
          userId: v.id("user"),
          user: v.nullable(publicUserValidator),
          selectedClass: v.nullable(drinkCategoryValidator),
          rank: v.number(),
          scoreUnits: v.number(),
          baseDrinkScoreUnits: v.number(),
          classBonusScoreUnits: v.number(),
          questScoreUnits: v.number(),
          challengeScoreUnits: v.number(),
          beerpongScoreUnits: v.number(),
          wonChallengeCount: v.number(),
          completedQuestCount: v.number(),
          drinkCount: v.number(),
          volumeMl: v.number(),
          alcoholMl: v.number(),
        }),
      ),
    }),
  )
  .handler(async (ctx, { sessionId }) => {
    const { session } = await requireSessionAccess(ctx, sessionId, "joined");
    if (session.kind !== "party") throw new ConvexError("A party is required");
    const now = Date.now();
    const { entries } = await loadPartyScores(ctx, sessionId, now);
    const ranked = rankByScore(
      entries.map((entry) => ({
        ...entry,
        username: entry.user?.username ?? "Unavailable user",
      })),
    );
    return {
      entries: await Promise.all(
        ranked.map(async ({ member, user, username, ...score }) => ({
          ...score,
          selectedClass: member.selectedClass,
          user: user
            ? {
                _id: user._id,
                username: user.username,
                accentColor: user.accentColor,
                avatarUrl: user.avatarStorageId
                  ? await ctx.storage.getUrl(user.avatarStorageId)
                  : null,
              }
            : null,
        })),
      ),
    };
  });
