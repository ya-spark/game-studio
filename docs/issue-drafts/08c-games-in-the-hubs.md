# [change] include the game modules in the Mind hubs (issue 08c)

**Repos:** game-mind-1 (Mind Ember), game-mind-9 (Mind Presto). **Depends on:** 08a and 08b done.

## Goal
Mind Ember includes Block Puzzle and Blockfall; Mind Presto includes Wingy. Each game appears as a tile in the hub (stars, best score, coin price when locked) and shares the hub's single coin balance, one Remove Ads purchase and the ad pacing (banner before and after a game only, optional rewarded Continue, no interstitials).

## Notes
The game modules must work with the hub's coins and ads through the module API from 08a. Saves are separate from the standalone apps (a player who has both apps has two saves). No release or store upload without the owner's approval.
