--!strict
-- Every RemoteEvent the game uses. The server creates them, clients wait for them.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = {}

Remotes.FolderName = "FakeFriendRemotes"

Remotes.Names = {
	-- Server -> client
	"PhaseChanged",
	"PlayersUpdated",
	"RoleAssigned",
	"PrivateMessage",
	"ShapeshifterState",
	"VoteUpdate",
	"VoteResult",
	"MemoryShared",
	"GameOver",
	"ProfileUpdate",
	-- Client -> server
	"RequestSync",
	"CastVote",
	"ShareMemory",
	"ShapeshifterAction",
	"EquipCosmetic",
	"DebugSkipPhase",
	"PrivateServerStart",
}

-- Client-side lookup. Yields until the server has created the remote.
function Remotes.get(name: string): RemoteEvent
	local folder = ReplicatedStorage:WaitForChild(Remotes.FolderName)
	return folder:WaitForChild(name) :: RemoteEvent
end

return Remotes
