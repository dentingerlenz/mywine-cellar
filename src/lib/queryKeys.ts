// Zentrale React-Query-Keys (Plan §6.2): eine Quelle für alle Invalidierungen.
export const qk = {
  membership: (userId?: string) => ["membership", userId] as const,
  members: ["members"] as const,
  wines: ["wines"] as const,
  colours: ["wine_colours"] as const,
  people: ["people"] as const,
  drinkingLog: ["drinking_log"] as const,
  countries: ["countries"] as const,
  regions: ["regions"] as const,
  subRegions: ["sub_regions"] as const,
  appellations: ["appellations"] as const,
} as const;
