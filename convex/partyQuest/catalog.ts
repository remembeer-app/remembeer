import type { Infer } from "convex/values";
import type { partyQuestKindValidator } from "./schema";
import { partyScoreUnitsPerPoint } from "./constants";

type BuiltInQuest = Infer<typeof partyQuestKindValidator> & {
  title: string;
  instructions: string;
  pointsUnits: number;
  availability: "early" | "regular" | "final";
};

const partyClasses = [
  ["beer", "Beer Paladin"],
  ["cider", "Cider Sentinel"],
  ["cocktail", "Cocktail Druid"],
  ["spirit", "Spirit Shaman"],
  ["wine", "Wine Warrior"],
] as const;

export const builtInQuests = [
  ...partyClasses.map(([kind, title]) => ({
    kind: "toastWithClass" as const,
    drinkCategory: { kind },
    title: `Toast with a ${title}`,
    instructions: `Have a toast together and select each other before time runs out. Exactly one of you must be a ${title}.`,
    pointsUnits: 30 * partyScoreUnitsPerPoint,
    availability: "early" as const,
  })),
  {
    kind: "sameAccent",
    title: "Color Alliance",
    instructions:
      "Have a toast with someone with the same profile accent and select each other.",
    pointsUnits: 25 * partyScoreUnitsPerPoint,
    availability: "early",
  },
  {
    kind: "differentAccent",
    title: "Color Contrast",
    instructions:
      "Have a toast with someone with a different profile accent and select each other.",
    pointsUnits: 20 * partyScoreUnitsPerPoint,
    availability: "early",
  },
  {
    kind: "newAlly",
    title: "New Ally",
    instructions:
      "Have a toast with someone you have not completed a social quest with before and select each other.",
    pointsUnits: 30 * partyScoreUnitsPerPoint,
    availability: "early",
  },
  {
    kind: "differentClass",
    title: "Cross-Class Alliance",
    instructions:
      "Have a toast with someone from a different Party class and select each other.",
    pointsUnits: 25 * partyScoreUnitsPerPoint,
    availability: "early",
  },
  {
    kind: "sameClass",
    title: "Class Fellowship",
    instructions:
      "Have a toast with someone from your Party class and select each other.",
    pointsUnits: 25 * partyScoreUnitsPerPoint,
    availability: "early",
  },
  {
    kind: "bottomQuarter",
    title: "Rescue the Underdog",
    instructions:
      "Have a toast and select each other. Exactly one of you must be in the bottom quarter of the ranking.",
    pointsUnits: 30 * partyScoreUnitsPerPoint,
    availability: "regular",
  },
  {
    kind: "leader",
    title: "Challenge the Champion",
    instructions:
      "Have a toast and select each other. Exactly one of you must currently share first place.",
    pointsUnits: 30 * partyScoreUnitsPerPoint,
    availability: "regular",
  },
  {
    kind: "topThree",
    title: "Medalist Hunt",
    instructions:
      "Have a toast and select each other. Exactly one of you must currently hold a top-three rank.",
    pointsUnits: 30 * partyScoreUnitsPerPoint,
    availability: "regular",
  },
  {
    kind: "oppositeRankingHalves",
    title: "Helping Hand",
    instructions:
      "Have a toast across the ranking halves and select each other. One of you must be in the top half and the other in the bottom half.",
    pointsUnits: 30 * partyScoreUnitsPerPoint,
    availability: "regular",
  },
  {
    kind: "nearbyRank",
    title: "Close Rivals",
    instructions:
      "Have a toast with someone no more than three shared ranks away and select each other.",
    pointsUnits: 25 * partyScoreUnitsPerPoint,
    availability: "regular",
  },
  {
    kind: "differentBeerpongTeam",
    title: "Beerpong Diplomat",
    instructions:
      "Have a toast with someone assigned to a different beerpong team and select each other.",
    pointsUnits: 25 * partyScoreUnitsPerPoint,
    availability: "regular",
  },
  {
    kind: "sameBeerpongTeam",
    title: "Team Morale",
    instructions:
      "Have a toast with a member of your beerpong team and select each other.",
    pointsUnits: 25 * partyScoreUnitsPerPoint,
    availability: "regular",
  },
  {
    kind: "finalistTeam",
    title: "Finalist Aura",
    instructions:
      "Have a toast and select each other. At least one of you must belong to a beerpong finalist team.",
    pointsUnits: 30 * partyScoreUnitsPerPoint,
    availability: "final",
  },
] as const satisfies readonly BuiltInQuest[];
