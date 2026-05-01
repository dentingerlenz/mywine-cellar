## Problem

When saving a bottle, the form shows a generic "Please review highlighted fields" message but no field is actually highlighted, so users can't tell what's wrong. The most common cause is the required **Colour** field being empty (it's a custom Select, not a registered Input, so it doesn't get any visible error styling), but the same is true for **Producer** and **Quantity** — there's no inline error text anywhere in the form, only the generic banner.

## Fix

Make validation errors visible and specific in `src/components/WineFormDialog.tsx`:

1. **Inline error messages under each field.** For every field bound to react-hook-form (Producer, Quantity, Colour, Vintage, numeric fields, year fields, etc.), render a small red text under the input when `errors.<field>` exists, showing the actual zod message ("Producer is required", "Expected number, received nan", etc.).

2. **Red ring on invalid inputs.** Add `aria-invalid={!!errors.<field>}` and a conditional `border-destructive` class so the field visually lights up.

3. **Highlight the Colour Select when invalid.** The `SelectTrigger` for Colour gets the same red border / aria-invalid treatment when `errors.colour` is set — this is the most likely silent failure today.

4. **Replace the generic banner with a specific summary.** Instead of "Please review highlighted fields.", list the names of the fields that failed (e.g. "Missing: Colour, Quantity"). This gives an immediate answer even if the user hasn't scrolled.

5. **Scroll to first error on submit.** When `handleSubmit` rejects, scroll the dialog to the first invalid field so it's visible without hunting.

## Out of scope

No schema changes — `Producer`, `Colour`, and `Quantity` remain the only required fields. The earlier "drink window required" rule is not currently in the schema and is not being re-added.

## Technical notes

- File touched: `src/components/WineFormDialog.tsx` only.
- Use `formState.errors` from the existing `useForm` call.
- Add a tiny `<FieldError name="..." />` helper inside the file to keep markup tidy.
- For the Colour Select, pass `className={errors.colour ? "border-destructive" : ""}` to `SelectTrigger`.
- Use `handleSubmit(onSubmit, onInvalid)` where `onInvalid` focuses/scrolls to the first errored field via `document.querySelector('[aria-invalid="true"]')`.
