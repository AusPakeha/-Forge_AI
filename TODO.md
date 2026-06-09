# TODO - Frontline & Territory Analysis integration

- [x] Step 1: Merge `chat28.sqf` Frontline & Territory Analysis system into `addons/ids_docs/AI_DEVELOPMENT_PROMPT.md` under the best-fit heading.

- [x] Step 2: Inspect existing commander territory/operations code to find integration points (init, world scan, tick loops, operation generation).

- [x] Step 3: Implement SQF functions:

  - [x] `fn_buildLocationGraph.sqf`
  - [x] `fn_updateFrontlines.sqf`

- [x] Frontier region grouping + RegionID assignment

  - [x] fn_updateFrontlineRegions.sqf + RegionID assignment wired
  - [ ] Frontline scoring + primary/secondary/reserve selection (doctrine-aware)
  - [ ] Rear/support/frontline reinforcement integration hook (spawning decisions)
  - [ ] Debug marker visualization helper

- [ ] Step 4: Wire functions into existing flows:

  - [ ] Call graph builder during world generation/init
  - [ ] Call frontline update on an interval/loop
  - [ ] Update operation generation to target front regions
- [x] Step 5: Register new functions in `addons/ids_commander_core/CfgFunctions.hpp` (or equivalent) so they’re callable.

- [x] Step 6: Syntax-check + quick static sanity: ensure all functions referenced exist and are in correct namespace.



