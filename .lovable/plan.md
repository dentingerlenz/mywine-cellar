## Goal

Allow direct editing of the bottle quantity number in both grid and list views — currently only the − / + buttons work.

## Change

Update `src/components/QuantityControls.tsx`:

- Replace the static `<span>` showing the quantity with a click-to-edit field.
- Click the number → it becomes a focused, auto-selected `<input type="number">`.
- Press Enter or blur → commit the new value via the existing `useUpdateQuantity` mutation (with the same toast feedback).
- Press Escape → cancel and revert.
- Invalid input (empty, NaN, negative) reverts to the current quantity.
- Keep the existing − / + buttons unchanged.
- Preserve muted/italic style when quantity is 0.
- Keep `onClick` propagation stopped so editing on a card doesn't open the detail dialog.

No other files need to change — `WineCard` and `WineListRow` already use this component.

## Technical detail

- Add `useState` for `editing` and `draft` string, `useRef` for the input.
- Sync `draft` from `wine.quantity` when not editing (handles external updates).
- Auto-focus + select on entering edit mode via `useEffect`.
- Reuse existing `useUpdateQuantity` hook; floor + clamp to ≥0 before saving.
- Hide native number spinners with the existing tailwind arbitrary selectors.
