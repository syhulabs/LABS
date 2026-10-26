--!strict
-- Shared type definitions used by server, client and tests.

export type Role = "Friend" | "Shapeshifter"
export type Winner = "Friends" | "Shapeshifter"
export type WinReason = "Caught" | "ShapeshifterLeft" | "Outnumbered" | "Sunrise"

export type Phase =
	"Lobby"
	| "Countdown"
	| "Setup"
	| "Explore"
	| "Blackout"
	| "Investigate"
	| "Discussion"
	| "Vote"
	| "VoteResult"
	| "Results"

-- 0-indexed RNG compatible with Random:NextInteger(min, max).
export type Rng = (min: number, max: number) -> number

return {}
