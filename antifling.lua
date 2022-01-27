if (getgenv().ANTIFLINGING) then return; end

getgenv().ANTIFLINGING = true

loadstring(game:HttpGet("https://raw.githubusercontent.com/L8X/phys/main/source.lua"))()

local PhysicsService = game:GetService("PhysicsService")

local function check4property(obj, prop)
    return ({pcall(function()if(typeof(obj[prop])=="Instance")then error()end end)})[1]
end

local antifling = true
local check = true
        for _,g in pairs(PhysicsService:GetCollisionGroups()) do
            for i,v in pairs(g) do
                if v == "KPlayers" then
                    check = false
                end
            end
        end
        if check then
            PhysicsService:CreateCollisionGroup("KPlayers")
        end
        PhysicsService:CollisionGroupSetCollidable("KPlayers", "KPlayers", false)
        local function OnCharacterAdded(Chr)
            coroutine.resume(coroutine.create(function()
                wait()
                local stringgroup
                if antifling then stringgroup = "KPlayers"
                    else stringgroup = "Default"
                end
                for i,v in pairs(Chr:GetDescendants()) do
                    spawn(function()
                        if check4property(v,"CanCollide") then
                            PhysicsService:SetPartCollisionGroup(v, stringgroup)
                        end
                    end)
                end
                Chr.DescendantAdded:Connect(function(v)
                    spawn(function()
                        if check4property(v,"CanCollide") then
                            PhysicsService:SetPartCollisionGroup(v, stringgroup)
                        end
                    end)
                end)
            end))
        end
        local function OnPlayerAdded(Plr)
            Plr.CharacterAdded:Connect(OnCharacterAdded)
            if Plr.Character then
                OnCharacterAdded(Plr.Character)
            end
        end

        game:GetService("Players").PlayerAdded:Connect(OnPlayerAdded)

        for i,v in pairs(game:GetService("Players"):GetPlayers()) do
            OnPlayerAdded(v)
        end
