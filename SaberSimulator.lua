-- library
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Vonixe Hub V1        ",
    SubTitle = "[UPD🧨] Saber Simulator 💎",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})

-- buka tutup gui
function icons ()
    -- ===================== icon ===================== --
        local screenGui = Instance.new("ScreenGui")
        local minimizeButton = Instance.new("ImageButton")
        local buttonCorner = Instance.new("UICorner")

        screenGui.Name = "MobileMinimize"
        screenGui.Parent = game:GetService("CoreGui")
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

        minimizeButton.Parent = screenGui
        minimizeButton.BackgroundColor3 = Color3.new(0, 0, 0)
        minimizeButton.BorderColor3 = Color3.new(0, 0, 0)
        minimizeButton.BorderSizePixel = 0
        minimizeButton.Position = UDim2.new(0,584,0,14)

        local originalSize = UDim2.new(0, 45, 0, 45)
        minimizeButton.Size = originalSize + UDim2.new(0, originalSize.X.Offset * 0.15, 0, originalSize.Y.Offset * 0.15)
        minimizeButton.Image = "rbxassetid://8569322835"

        buttonCorner.CornerRadius = UDim.new(0.2, 0)
        buttonCorner.Parent = minimizeButton

        local dragging = false
        local dragInput, touchPos, buttonPos

        minimizeButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                touchPos = input.Position
                buttonPos = minimizeButton.Position

                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)

        minimizeButton.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)

        game:GetService("UserInputService").InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - touchPos
                minimizeButton.Position = UDim2.new(
                    buttonPos.X.Scale,
                    buttonPos.X.Offset + delta.X,
                    buttonPos.Y.Scale,
                    buttonPos.Y.Offset + delta.Y
                )
            end
        end)

        minimizeButton.MouseButton1Click:Connect(function()
            Window:Minimize()
        end)
end
icons()

-- Basic 
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local LocalCharacter = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = LocalCharacter:FindFirstChild("HumanoidRootPart")
local TweenService = game:GetService("TweenService")

-- local variable
local IsAutoSwing = false
local IsAutoSell = false
local IsAutoCollectCrown = false
local IsAutoCollectFirework = false
local IsAutoBoss = false
local IsAutoDaily = false
local IsAutoBuySaber = false
local IsAutoBuyDNA = false
local IsAutoBuyMerchant = false
local IsAutoClass = false
local IsAutoBuyEventEgg = false
local IsAutoEquipBest = false
local SelectedEquip = nil
local LastEquipMode = nil
local IsAutoCombine = false
local IsAutoFireGolem = false
local IsAutoFireBoss = false



-- map list


-- local list
local ClassList = {
    "Noob",
    "Apprentice",
    "Soldier",
    "Paladin",
    "Assassin",
    "Warrior",
    "Warlord",
    "Berserker",
    "Saber",
    "Cyborg",
    "Master",
    "Titan",
    "Phantom",
    "Shadow",
    "Ghoul",
    "Tempest",
    "Elementalist",
    "Beast",
    "Dark Ninja",
    "Warlock",
    "Overlord",
    "Demigod",
    "ArchAngel",
    "Wraith",
    "Deity",
    "Nemesis",
    "Executioner",
    "Terminator",
    "Colossus",
    "Zeus",
    "Elf",
    "Santa",
    "Corruptor",
    "Prestige",
    "Caster",
    "Cyclops",
    "King",
    "Hacker",
    "Angel",
    "Minotaur",
    "Cerberus",
    "Yeti",
    "Samurai",
    "Baron",
    "Detective",
    "Red Baron",
    "Witch",
    "Gladiator",
    "Purple Baron",
    "Guard",
    "Shadow Titan",
    "Superhuman",
    "Brain",
    "Shadow Guard",
    "Shadow Gladiator",
    "Red Elf",
    "Gingerbread",
    "Ninja Warrior",
    "Snowman",
    "Lord Of Death",
    "Demonic",
    "Alien",
    "Ghost",
    "Dracula",
    "Golem",
    "Dragon",
    "Spirit",
    "Pharaoh",
    "Mummy",
    "Ape",
    "Robot",
    "Goblin",
    "Techno",
    "Golden Warrior",
    "Golden Royalty",
    "Demonic Imp",
    "Anubis",
    "Illuminati",
    "Hydra",
    "Skeleton",
    "Supervillain",
    "Dark Slayer",
    "Dark Spider",
    "Troll",
    "Shark",
    "Pirate",
    "Kraken",
    "Genie",
    "Cobra",
    "Sphinx",
    "Dark Witch",
    "Knight",
    "Chimera",
    "Kitsune",
    "Odin",
    "Cowboy",
    "Undead",
    "Satyr",
    "Hermes",
    "Hades",
    "Faun",
    "Giant",
    "Ignivar"


}

local MerchList = {
    1,
    2,
    3,
    4,
    5,
    6
}

local EquipList = {
    ["Select"] = nil,
    ["Normal"] = false,
    ["Event"] = true
}

-- Tween
local function Tween(P1, Speed)
    local Distance = (P1.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    TweenService:Create(game.Players.LocalPlayer.Character.HumanoidRootPart,TweenInfo.new(Distance/Speed, Enum.EasingStyle.Linear),{CFrame = CFrame.new(P1.Position) * CFrame.new(-5, -25, 0)}):Play()
    if _G.StopTween then
        TweenService:Create(game.Players.LocalPlayer.Character.HumanoidRootPart,TweenInfo.new(Distance/Speed, Enum.EasingStyle.Linear),{CFrame = CFrame.new(P1.Position) * CFrame.new(-5, 1, 0)}):Cancel()
    end
end

-- Main Farm
local MainTabs = {
    Main = Window:AddTab({ Title = "Farm", Icon = "rbxassetid://86598402138633" }),
    Event = Window:AddTab({ Title = "Event", Icon = "rbxassetid://95997782221202" }),
    Elemental = Window:AddTab({ Title = "Element Zone Farm", Icon = "rbxassetid://3885374547" }), 
    Pets = Window:AddTab({ Title = "Pets", Icon = "rbxassetid://82074568291888" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

local sliderselect = 0

    local TabBuy = MainTabs.Main:AddSection("Auto Farm Option")

local ToggleClick = MainTabs.Main:AddToggle("AutoClickToggle", 
{
    Title = "Auto Swing Saber", 
    Description = nil,
    Default = false,
    Callback = function(state)
        IsAutoSwing = state
        task.spawn(function()
        while IsAutoSwing do
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("SwingSaber"):FireServer()
        wait()

        end
    end)
end
})

local ToggleSell = MainTabs.Main:AddToggle("AutoSellToggle", 
{
    Title = "Auto Sell", 
    Description = nil,
    Default = false,
    Callback = function(state)
        IsAutoSell = state
        task.spawn(function()
            while IsAutoSell do
             game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("SellStrength"):FireServer()
                local args = {
	"SetRegionLoaded"
}
game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("UIAction"):FireServer(unpack(args))


        wait(1)

        end
    end)
end
})

local TogglCollectCrown = MainTabs.Main:AddToggle("AutoCollectCrownToggle", 
{
    Title = "Auto Collect Crown", 
    Description = nil,
    Default = false,
    Callback = function(state)
        IsAutoCollectCrown = state
        while IsAutoCollectCrown do
            task.wait()
            for _, instance in pairs(workspace.Gameplay.CurrencyPickup.CurrencyHolder:GetChildren()) do
                if instance then
                    if instance.Name == "Crown" then
                       firetouchinterest(HumanoidRootPart, instance, 0)
                        wait(0.1)
                        firetouchinterest(HumanoidRootPart, instance, 1)
                    end
                end
                task.wait(0.2)
            end
        end
    end
   })

local ToggleBoss = MainTabs.Main:AddToggle("AutoBossToggle", 
{
    Title = "Auto Boss", 
    Description = nil,
    Default = false,
    Callback = function(state)
        IsAutoBoss = state

        task.spawn(function()
            while IsAutoBoss do
                local boss = workspace:FindFirstChild("Gameplay")
                    and workspace.Gameplay:FindFirstChild("Boss")
                    and workspace.Gameplay.Boss:FindFirstChild("BossHolder")
                    and workspace.Gameplay.Boss.BossHolder:FindFirstChild("Boss")

                if boss and boss:FindFirstChild("HumanoidRootPart") then
                    print("Attacking Boss:", boss.Name)
                    Tween(boss.HumanoidRootPart, 500)

                    local args = {
                        { boss }
                    }

                    local weapon = nil
                    for _, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
                        if v:FindFirstChild("RemoteClick") then
                            weapon = v
                            break
                        end
                    end

                    if weapon then
                        weapon.RemoteClick:FireServer(unpack(args))
                    else
                        warn("❌ Tidak menemukan weapon dengan RemoteClick")
                    end
                else
                    print("Boss belum spawn, menunggu...")
                end

                task.wait(0.5)
            end
        end)
    end
})


local ToggleDaily = MainTabs.Main:AddToggle("AutoDailyToggle", 
{
    Title = "Auto Claim Daily", 
    Description = nil,
    Default = false,
    Callback = function(state)
        IsAutoDaily = state
        task.spawn(function()
            while IsAutoDaily do
                local dailyText = workspace.Gameplay.Locations.DailyReward.BillboardGui.Frame.Desc.Text

                if dailyText == "Collect Reward" then
                    local args = { "ClaimDailyTimedReward" }
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("UIAction"):FireServer(unpack(args))

                    print("✅ Daily reward claimed!")
                    
                    repeat
                        task.wait(1)
                        dailyText = workspace.Gameplay.Locations.DailyReward.BillboardGui.Frame.Desc.Text
                    until dailyText ~= "Collect Reward"
                end

                task.wait(1)
            end
        end)
    end
})



    local TabBuy = MainTabs.Main:AddSection("Buy Option")

    local ToggleBuySaber = MainTabs.Main:AddToggle("AutoBuySaberToggle", 
{
    Title = "Auto Buy Saber", 
    Description = nil,
    Default = false,
    Callback = function(state)
        IsAutoBuySaber = state
        while IsAutoBuySaber do
            task.wait()
            local args = {
            "BuyAllWeapons"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("UIAction"):FireServer(unpack(args))

            wait()
        end
    end
})

local ToggleBuyDNA = MainTabs.Main:AddToggle("AutoBuyDNAToggle", 
{
    Title = "Auto Buy DNA", 
    Description = nil,
    Default = false,
    Callback = function(state)
        IsAutoBuyDNA = state
        while IsAutoBuyDNA do
            task.wait()
            local args = {
	        "BuyAllDNAs"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("UIAction"):FireServer(unpack(args))

            wait()
        end
    end
})

local function getNextClass(currentClass)
	for i, className in ipairs(ClassList) do
		if className == currentClass then
			return ClassList[i + 1]
		end
	end
	return nil
end


local ToggleBuyClass = MainTabs.Main:AddToggle("AutoBuyClassToggle", 
{
    Title = "Auto Buy Class", 
    Description = nil,
    Default = false,
    Callback = function(state)
        IsAutoClass = state
        while IsAutoClass do
            task.wait(0.2)
            local currentClass = game:GetService("Players").LocalPlayer.leaderstats.Class.Value
            local nextClass = getNextClass(currentClass)
                local args = {
	             "BuyClass",
	             nextClass
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("UIAction"):FireServer(unpack(args))
                
                task.wait(1)
            end
        end
})

local ToggleBuyAura = MainTabs.Main:AddToggle("AutoBuyAuraToggle", 
{
    Title = "Auto Buy Aura", 
    Description = nil,
    Default = false,
    Callback = function(state)
        IsAutoBuyAura = state 
        while IsAutoBuyAura and task.wait(1) do 
            local args = {
	        "BuyAllAuras"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("UIAction"):FireServer(unpack(args))

        end
    end
    })

local MerchList = {1, 2, 3, 4, 5, 6}

local ToggleBuyMerch = MainTabs.Main:AddToggle("AutoBuyMerchToggle", 
{
    Title = "Auto Buy Traveling Merchant", 
    Description = nil,
    Default = false,
    Callback = function(state)
        IsAutoBuyMerch = state

        task.spawn(function()
            while IsAutoBuyMerch do
                local success, merchantKey = pcall(function()
                    return require(game:GetService("Players").LocalPlayer.PlayerScripts.MainClient.ClientDataManager).Data.TravelingMerchant.ResetDT
                end)

                if success and merchantKey then
                    for _, merchID in ipairs(MerchList) do
                        local args = {
                            "TravelingMerchantBuyItem",
                            merchID,
                            merchantKey
                        }

                        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("UIAction"):FireServer(unpack(args))
                        task.wait(0.3)
                    end
                end

                task.wait(2)
            end
        end)
    end
})


local ToggleBuyUpgrade = MainTabs.Main:AddToggle("AutoBuyUpgradeToggle", 
{
    Title = "Auto Buy Skill", 
    Description = nil,
    Default = false,
    Callback = function(state)
        IsAutoUpgrade = state
        while IsAutoUpgrade and task.wait(0.5) do
        local args = {
        "BuyAllBossBoosts"
        }
        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("UIAction"):FireServer(unpack(args))

        end
    end
    })

    local TogglCollectFireWork = MainTabs.Event:AddToggle("AutoCollectFireworkToggle", 
{
    Title = "Auto Collect Firework", 
    Description = nil,
    Default = false,
    Callback = function(state)
        IsAutoCollectFirework = state
        while IsAutoCollectFirework do
            task.wait()
            for _, instance in pairs(workspace.Gameplay.CurrencyPickup.CurrencyHolder:GetChildren()) do
                if instance then
                    if instance.Name == "Firework" then
                       firetouchinterest(HumanoidRootPart, instance, 0)
                        wait(0.1)
                        firetouchinterest(HumanoidRootPart, instance, 1)
                    end
                end
                task.wait(0.2)
            end
        end
    end
   })

    local TogglBuyEventEgg = MainTabs.Event:AddToggle("AutoBuyEventEggToggle", 
{
    Title = "Auto Buy Event Egg", 
    Description = nil,
    Default = false,
    Callback = function(state)
        IsAutoBuyEventEgg = state
        while IsAutoBuyEventEgg and task.wait(1) do
        local args = {
	    "BuyEgg",
	    "EO Egg"
        }
        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("UIAction"):FireServer(unpack(args))
        end
    end
})


local IsAutoFireGolem = false
local Radius = 50 -- Jarak sekitar karakter
local ElementType = "Fire"

MainTabs.Elemental:AddToggle("AutoKillAuraGolemToggle", {
    Title = "Kill Aura Golem (No Tween)",
    Default = false,
    Callback = function(state)
        IsAutoFireGolem = state
    end
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local function GetWeapon()
    for _, tool in pairs(LocalPlayer.Character:GetChildren()) do
        if tool:FindFirstChild("RemoteClick") then
            return tool
        end
    end
end

RunService.RenderStepped:Connect(function()
    if not IsAutoFireGolem then return end

    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local gameplay = workspace:FindFirstChild("Gameplay")
    local map = gameplay and gameplay:FindFirstChild("Map")
    local zones = map and map:FindFirstChild("ElementZones")
    local fireFolder = zones and zones:FindFirstChild(ElementType)
    local zone = fireFolder and fireFolder:FindFirstChild(ElementType)

    if not zone then return end

    for _, golem in ipairs(zone:GetChildren()) do
        if golem:IsA("Model") and golem:FindFirstChild("HumanoidRootPart") then
            local dist = (hrp.Position - golem.HumanoidRootPart.Position).Magnitude
            if dist <= Radius then
                local weapon = GetWeapon()
                if weapon then
                    weapon.RemoteClick:FireServer({ golem })
                end
            end
        end
    end
end)

local TogglAutoFire = MainTabs.Elemental:AddToggle("AutoBuyEventEggToggle", {
    Title = "Auto Fire Boss", 
    Description = nil,
    Default = false,
    Callback = function(state)
local function BringAllFireGolems()
    local character = game.Players.LocalPlayer.Character
    if not character then return end

    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local elementType = "Fire"
    local gameplay = workspace:FindFirstChild("Gameplay")
    local map = gameplay and gameplay:FindFirstChild("Map")
    local zones = map and map:FindFirstChild("ElementZones")
    local fireFolder = zones and zones:FindFirstChild(elementType)
    local zone = fireFolder and fireFolder:FindFirstChild(elementType)

    if not zone then return end

    for _, golem in ipairs(zone:GetChildren()) do
        if golem:IsA("Model") and golem:FindFirstChild("HumanoidRootPart") then
            golem:PivotTo(hrp.CFrame * CFrame.new(math.random(-5, 5), 0, math.random(-5, 5)))
        end
    end
end
end
    })

local TogglAutoFire = MainTabs.Elemental:AddToggle("AutoBuyEventEggToggle", {
    Title = "Auto Fire Boss", 
    Description = nil,
    Default = false,
    Callback = function(state)
        IsAutoFireBoss = state

        task.spawn(function()
            while IsAutoFireBoss do
                local fireboss = workspace:FindFirstChild("Gameplay")
                    and workspace.Gameplay:FindFirstChild("Map")
                    and workspace.Gameplay.Map:FindFirstChild("ElementZones")
                    and workspace.Gameplay.Map.ElementZones:FindFirstChild("Fire")
                    and workspace.Gameplay.Map.ElementZones["Fire"]:FindFirstChild("Fire")
                    and workspace.Gameplay.Map.ElementZones["Fire"]["Fire"]:FindFirstChild("Fire Boss")

                if fireboss and fireboss:FindFirstChild("HumanoidRootPart") then
                    print("🔥 Attacking Fire Boss:", fireboss.Name)
                    Tween(fireboss.HumanoidRootPart, 500)

                    local args = {
                        { fireboss }
                    }

                    local weapon = nil
                    for _, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
                        if v:FindFirstChild("RemoteClick") then
                            weapon = v
                            break
                        end
                    end

                    if weapon then
                        weapon.RemoteClick:FireServer(unpack(args))
                    else
                        warn("❌ Weapon with RemoteClick not found!")
                    end
                else
                    print("⏳ Fire Golem not found, waiting...")
                end

                task.wait(0.5)
            end
        end)
    end
})

local Dropdown = MainTabs.Pets:AddDropdown("Select", {
    Title = "Dropdown",
    Description = "Select Normal or Event Pets",
    Values = {"Select", "Normal", "Event"},
    Multi = false,
    Default = 1,
    Callback = function(Option)
        SelectedEquip = EquipList[Option]
    end
})

    local TogglEquipBest = MainTabs.Pets:AddToggle("AutoEquipBestEggToggle", 
{
    Title = "Auto Equip Best", 
    Description = nil,
    Default = false,
    Callback = function(state)
        IsAutoEquipBest = state
        task.spawn(function()
        while IsAutoEquipBest and task.wait(0.1) do
            if SelectedEquip ~= nil then
                if SelectedEquip ~= LastEquipMode then
                    LastEquipMode = SelectedEquip
            local args = {
	        "EquipBestPets",
	        SelectedEquip
            } 
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("UIAction"):FireServer(unpack(args))
                end
            end
        end
    end)
end
 })

    local TogglCombine = MainTabs.Pets:AddToggle("AutoCombinePetsToggle", 
{
    Title = "Auto Combine Pets", 
    Description = nil,
    Default = false,
    Callback = function(state)
        IsAutoCombine = state
        while IsAutoCombine and task.wait(0.1) do
        local args = {
        "CombineAllPets"
        }
        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("UIAction"):FireServer(unpack(args))
        print("Combined", IsAutoCombine)
        end
    end
})

    local TabSettings = MainTabs.Settings:AddSection("Keybind")

    local Keybind = MainTabs.Settings:AddKeybind("Keybind", {
        Title = "KeyBind",
        Mode = "Toggle", -- Always, Toggle, Hold
        Default = "LeftControl", -- String as the name of the keybind (MB1, MB2 for mouse buttons)

        -- Occurs when the keybind is clicked, Value is `true`/`false`
        Callback = function(Value)
            print("Keybind clicked!", Value)
        end,

        -- Occurs when the keybind itself is changed, `New` is a KeyCode Enum OR a UserInputType Enum
        ChangedCallback = function(New)
            print("Keybind changed!", New)
        end
    })

    -- OnClick is only fired when you press the keybind and the mode is Toggle
    -- Otherwise, you will have to use Keybind:GetState()
    Keybind:OnClick(function()
        print("Keybind clicked:", Keybind:GetState())
    end)

    Keybind:OnChanged(function()
        print("Keybind changed:", Keybind.Value)
    end)

    task.spawn(function()
        while true do
            wait(1)

            -- example for checking if a keybind is being pressed
            local state = Keybind:GetState()
            if state then
                print("Keybind is being held down")
            end

            if Fluent.Unloaded then break end
        end
    end)

    Keybind:SetValue("MB2", "Toggle") -- Sets keybind to MB2, mode to Hold


    local Input = MainTabs.Settings:AddInput("Input", {
        Title = "Input",
        Default = "Default",
        Placeholder = "Placeholder",
        Numeric = false, -- Only allows numbers
        Finished = false, -- Only calls callback when you press enter
        Callback = function(Value)
            print("Input changed:", Value)
        end
    })

    Input:OnChanged(function()
        print("Input updated:", Input.Value)
    end)


-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- InterfaceManager (Allows you to have a interface managment system)

-- Hand the library over to our managers
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- You can add indexes of elements the save manager should ignore
SaveManager:SetIgnoreIndexes({})

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
InterfaceManager:SetFolder("Vonixe Hub")
SaveManager:SetFolder("Vonixe Hub/Saber Simulator")

InterfaceManager:BuildInterfaceSection(MainTabs.Settings)
SaveManager:BuildConfigSection(MainTabs.Settings)


Window:SelectTab(1)

Fluent:Notify({
    Title = "Vonixe Hub",
    Content = "The script has been loaded.",
    Duration = 8
})

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()
