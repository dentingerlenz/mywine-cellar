## Problem

The Rating field is showing up in the "Please fix" banner even though it should be optional. Two related issues:

1. The Rating `<Select>` has no way to clear a value once set — there's no "No rating" entry. If a user picks a star and then changes their mind, the value stays.
2. More importantly, when a star is picked the form value becomes a number, but no path exists to set it back to undefined. Combined with how the Select value is bound (`rating ? String(rating) : ""`), edge cases (e.g. selecting `0` programmatically, or stale state on edit) can leave the field in a state Zod rejects.

The schema in `src/lib/wine.ts` is already correct — `rating` is `optionalNum(...)` and accepts undefined/null. The fix is purely UI.

## Fix (one file: `src/components/WineFormDialog.tsx`)

1. **Add a "No rating" option** to the Rating `<Select>` so users can explicitly clear it.
2. **Wire clearing to `undefined`** — when "No rating" is picked, call `setValue("rating", undefined, { shouldValidate: true })`. When a star is picked, set the number as before, also with `shouldValidate: true`.
3. **Default Rating to `undefined`** explicitly in both `reset()` calls (new bottle and edit), so it never carries a stale value across opens.
4. **Same treatment for Occasion** Select while we're here, since it has the identical pattern and could trip the same way: add a "None" entry that maps to `undefined`.

No schema or hook changes. After this, Rating (and Occasion) can be left empty or cleared, and won't appear in the validation banner.
