# Fake Friend: Sleepover

A Roblox social deduction game. 6 to 10 friends are at a sleepover and one of them is secretly a shapeshifter. When the lights go out, the shapeshifter copies someone's look or swaps an item between rooms. Friends check their stuff, compare memories, and vote. Friends win by voting out the shapeshifter. The shapeshifter wins by surviving until sunrise, or when only 2 friends are left.

All code is Luau, synced into Studio with Rojo. You build the house map in Studio and connect it with tags.

## 1. Install the tools

1. Install Rokit, the toolchain manager: <https://github.com/rojo-rbx/rokit>
2. In this `fake-friend` folder, run:
   ```
   rokit install
   ```
   That installs the pinned versions of Rojo, Selene, StyLua and Lune from `rokit.toml`.
3. In Roblox Studio, install the Rojo plugin. Run `rojo plugin install`, or get it from the Creator Store.

## 2. Open the game in Studio

Live sync, best while building:

```
rojo serve
```

Then in Studio open a new Baseplate, click the Rojo plugin, and press **Connect**.

Or build a place file once:

```
rojo build -o FakeFriend.rbxl
```

Rojo puts the code here:

| Folder | Goes to |
|---|---|
| `src/shared` | ReplicatedStorage > Shared |
| `src/server` | ServerScriptService > Server |
| `src/client` | StarterPlayer > StarterPlayerScripts > Client |

## 3. Studio settings to change once

1. **Game Settings > Security > Enable Studio Access to API Services.** This lets saving work in Studio. Without it, the game still runs with temporary data.
2. **Game Settings > Places > Server size:** set it to 10, to match `MaxPlayers` in Config.
3. **TextChatService > ChatVersion:** must be `TextChatService`. This is the default for new places. Ghost chat filtering needs it.
4. Publish the place before testing purchases. Game passes and products only exist for published games.

## 4. Build and tag the map

The code finds map pieces by **tags** and **attributes**. Add both in the Properties panel, under Tags and Attributes, with the part selected.

| Tag | Put it on | Attributes | Notes |
|---|---|---|---|
| `Room` | One Part covering each room's whole space | `RoomName` (string), for example `Attic` | Required. The game makes these invisible and non-solid. Items are matched to the room they sit inside. |
| `Item` | Each object players can inspect, a Part or a Model | `ItemName` (string), for example `blue pillow` | Required. Anchor items. Use at least one item per player. 10 or more is ideal. The game adds the prompt and the `Owner` attribute itself. |
| `SpawnPoint` | Parts inside the house | none | Required. Players spread across these at the start of each game. |
| `MeetingSpot` | One Part in the living room | none | Required. Players gather in a circle around it for meetings. |
| `Light` | Light objects, or Parts and Models that contain lights | none | Optional but recommended. Turned off in blackouts. Neon parts go dark too. |
| `LobbySpawn` | Parts outside the house | none | Optional. Where people wait between games. Falls back to `SpawnPoint`. |

Spread items across rooms. The shapeshifter can only swap an item with one in a **different** room.

The Output window prints a clear warning for every missing tag when the server starts.

## 5. Test alone in Studio

1. In `src/shared/Config.luau`, set `Config.DebugMode = true`.
2. Press **Play**. Debug mode only works inside Studio, so it can't leak into the live game.
3. You start a game alone, as the role set in `Config.Debug.ForceRole`. Phases run at 30% speed, and a red **Skip phase** button appears.
4. Switch `ForceRole` to `"Friend"` to test the other side.
5. For a real multiplayer test, use **Test > Clients and Servers** with 3 or more players.

Set `DebugMode` back to `false` before publishing.

## 6. Set up monetization

1. On the Creator Dashboard, create the game passes and developer products.
2. Paste their IDs into `Config.GamePasses` and `Config.DevProducts`.
3. Upload clothing for each pajama cosmetic and put the shirt and pants asset IDs into `Config.Cosmetics`. A pajama cosmetic with ID `0` simply does nothing until you add one.
4. Private servers are switched on in the game's settings page. The private server owner gets a **Start now** button that starts a game with 3 players instead of 6.

Nothing for sale reveals roles or changes who wins.

## How a game runs

1. **Lobby.** Waits for enough players, then counts down.
2. **Setup.** One player becomes the shapeshifter. Everyone gets an item and 2 private memories, then sees their role.
3. **Explore.** Lights on. Hold an item's prompt to inspect it.
4. **Blackout.** Lights flicker, then go out. Everyone gets a flashlight. The shapeshifter gets 1 action: copy a player's look, or hold an item's prompt to swap it with an item in another room. A disguise lasts until the next blackout.
5. **Investigate.** Lights on. Owners who inspect a moved item are told it isn't where they left it.
6. **Discussion.** Everyone is teleported to the meeting spot. Players talk in chat and can share memories.
7. **Vote.** One vote each, or skip. A tie or a skip majority sends nobody home. The player sent home becomes a ghost.
8. Repeat from Explore. After 5 meetings, the sun rises and the shapeshifter wins.

Every number above lives in `src/shared/Config.luau`.

## Code layout

```
src/shared/Config.luau        every tunable number
src/shared/Logic/             pure rules with no Roblox API calls: roles, rounds, votes, items,
                              memories, rate limits, save locking, cosmetics
src/server/Services/          RoundService runs the state machine; the other services wrap one system each
src/client/                   State store plus one module per screen
tests/                        offline tests for everything in src/shared/Logic
```

The server owns all game state. Clients only send requests through RemoteEvents. Every request is rate limited and checked for the right phase, role, alive status and argument types. Clients never learn another player's role until a vote result or the end of the game announces it.

## Checks

Run these from the `fake-friend` folder:

```
lune run tests/run.luau
stylua --check src tests
selene src tests
```

Selene needs the Roblox definitions file once, generated with `selene generate-roblox-std`. It is not committed.
