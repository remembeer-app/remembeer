import type { GenericDatabaseReader } from "convex/server";
import { type Change, Triggers } from "convex-helpers/server/triggers";
import type { DataModel, Doc } from "../_generated/dataModel";
import type { Event } from "./schema";

export const triggers = new Triggers<DataModel>();

triggers.register("drinkLog", async (ctx, change) => {
  const event = await toDrinkLogEvent(ctx.db, change);
  if (event) await ctx.innerDb.insert("event", event);
});

async function toDrinkLogEvent(
  db: GenericDatabaseReader<DataModel>,
  change: Change<DataModel, "drinkLog">,
): Promise<Event | null> {
  if (change.operation === "insert") {
    return {
      kind: "drinkLogCreated",
      userId: change.newDoc.userId,
      drinkLogId: change.id,
      drinkLog: await drinkLogSnapshot(db, change.newDoc),
    };
  }
  if (change.operation !== "update" || change.oldDoc.deletedAt !== null) {
    return null;
  }

  const { oldDoc, newDoc } = change;
  if (newDoc.deletedAt !== null) {
    return {
      kind: "drinkLogDeleted",
      userId: oldDoc.userId,
      drinkLogId: change.id,
      drinkLog: await drinkLogSnapshot(db, oldDoc),
    };
  }
  if (trackedDrinkLogFields(oldDoc) === trackedDrinkLogFields(newDoc)) return null;

  return {
    kind: "drinkLogUpdated",
    userId: newDoc.userId,
    drinkLogId: change.id,
    before: await drinkLogSnapshot(db, oldDoc),
    after: await drinkLogSnapshot(db, newDoc),
  };
}

// Drinks are immutable -> we care only about drinkId.
// Editing custom drink is represented by archiving the old record and creating new one.
function trackedDrinkLogFields(drinkLog: Doc<"drinkLog">) {
  const { drinkId, consumedAt, volumeMl } = drinkLog;
  return JSON.stringify([drinkId, consumedAt, volumeMl]);
}

async function drinkLogSnapshot(db: GenericDatabaseReader<DataModel>, drinkLog: Doc<"drinkLog">) {
  const drink = await db.get("drink", drinkLog.drinkId);
  if (!drink) throw new Error("Drink log references are missing");

  return {
    consumedAt: drinkLog.consumedAt,
    volumeMl: drinkLog.volumeMl,
    drink: {
      id: drink._id,
      drinkCategory: drink.drinkCategory,
      alcoholPercentage: drink.alcoholPercentage,
    },
  };
}
