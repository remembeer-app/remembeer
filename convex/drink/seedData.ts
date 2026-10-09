import { z } from "zod";

const seedValidator = z
  .object({
    id: z.string().min(1),
    userId: z.literal("global"),
    name: z.string().trim().min(1),
    category: z.enum(["beer", "cider", "cocktail", "spirit", "wine"]),
    alcoholPercentage: z.number().min(0.1).max(99.99),
  })
  .strict()
  .refine((seed) => seed.id.startsWith(`global-${seed.category}-`), {
    message: "Seed ID must start with global-<category>-",
  });

export function globalDrinkSeeds(data: unknown) {
  const seeds = z.array(seedValidator).min(1).parse(data);
  const keys = new Set<string>();
  return seeds.map((seed) => {
    if (keys.has(seed.id)) {
      throw new Error(`Duplicate drink seed key: ${seed.id}`);
    }
    keys.add(seed.id);
    return {
      seedKey: seed.id,
      name: seed.name,
      drinkCategory: { kind: seed.category },
      alcoholPercentage: seed.alcoholPercentage,
    };
  });
}
