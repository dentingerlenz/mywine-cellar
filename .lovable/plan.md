## Goal

Make the CHF price directly editable from the wine card (grid view) and the row (list view) — just like the quantity already is — without opening the edit form.

## Behaviour

- Click the price (e.g. "45 CHF" or the muted "No price" / "—") → it becomes a focused, auto-selected number input.
- Enter or blur → save to Supabase, show a brief toast ("Price updated · 45 CHF" or "Price cleared").
- Esc → cancel and revert.
- Empty input → clears the price (saved as `null`, displayed as "No price" / "—").
- Negative or invalid input → reverts.
- Decimals allowed (step 0.01), but display stays rounded as today (`toFixed(0)` + " CHF").
- Clicking the price never opens the wine detail dialog (stop propagation).
- Reuses the same luxury styling: gold primary colour, `font-display tabular-nums`, muted italic when empty.

## Changes

1. **New component `src/components/PriceControl.tsx`**
   - Props: `wine: Wine`, `align?: "left" | "right"`, `size?: "sm" | "md"`.
   - Internal `editing` / `draft` state, `useRef` for input, identical pattern to `QuantityControls`.
   - Calls a new `useUpdatePrice` mutation.
   - Renders either the formatted price button or a small inline number input with a "CHF" suffix.

2. **New mutation `useUpdatePrice` in `src/hooks/useWines.ts`**
   - Accepts `{ id, price_chf: number | null }`.
   - Updates the `wines` row, invalidates the `wines` query.
   - Empty / null → writes `null` to the column.

3. **`src/components/WineCard.tsx`**
   - Replace the static `<span>` showing `wine.price_chf` in the bottom row with `<PriceControl wine={wine} size="sm" />`.

4. **`src/components/WineListRow.tsx`**
   - Replace the price `<TableCell>` content with `<PriceControl wine={wine} size="sm" align="right" />`.

No schema, RLS, or form changes are needed — the column already exists and is nullable, and RLS already permits the owner to update.

## Technical detail

- Input uses `type="number"` with `inputMode="decimal"`, `step="0.01"`, `min="0"`, native spinners hidden via the same `[appearance:textfield] [&::-webkit-outer-spin-button]:appearance-none` classes used in `QuantityControls`.
- Width sized for ~5 chars + " CHF" suffix; right-aligned in list view to match current cell alignment.
- Commit logic:
  ```ts
  const trimmed = draft.trim();
  if (trimmed === "") savePrice(null);
  else {
    const n = Number(trimmed);
    if (!Number.isFinite(n) || n < 0) revert();
    else if (n !== (wine.price_chf ?? null)) savePrice(n);
  }
  ```
- Toast: `Price updated · ${n.toFixed(0)} CHF` or `Price cleared`.
- Mutation skips the network call when the value is unchanged.
