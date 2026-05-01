## Problem

Editing a wine fails unless you fill in "Ready from" and "Drink by" (and potentially other optional number fields). The schema marks them as optional, but empty number inputs come through as empty strings `""`, which `z.coerce.number()` converts to `0` — and `0` then fails the `min(1800)` year check, producing a validation error that blocks saving.

This affects every optional numeric field: `cl`, `residual_sugar_gl`, `alcohol_pct`, `price_chf`, `ready_from`, `drink_by`, `rating`.

## Fix

Update `src/lib/wine.ts` to add a small `optionalNum` helper that preprocesses empty strings / null / NaN into `undefined` before the number schema runs. Apply it to all seven optional numeric fields. No UI changes needed.

After this, leaving "Ready from" and "Drink by" blank (or any other optional field) will save without errors. Producer, colour, and quantity remain the only required fields.

## Technical detail

```ts
const optionalNum = (schema) =>
  z.preprocess(
    (v) => (v === "" || v === null || v === undefined || Number.isNaN(v) ? undefined : v),
    schema.optional().nullable()
  );
```

Then `ready_from: optionalNum(z.coerce.number().int().min(1800).max(2200))`, etc.
