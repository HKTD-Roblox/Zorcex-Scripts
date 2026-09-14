local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")
local CommE = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommE")

pcall(function()
	local deathEffect = require(ReplicatedStorage.Effect.Container.Death)
	hookfunction(deathEffect, function() end)
end)
pcall(function()
	local respawnEffect = require(ReplicatedStorage.Effect.Container.Respawn)
	hookfunction(respawnEffect, function() end)
end)

local SEA1_IDS = {
	[2753915549] = true,
	[85211729168715] = true,
}
local SEA2_IDS = {
	[4442272183] = true,
	[79091703265657] = true,
}
local SEA3_IDS = {
	[7449423635] = true,
	[100117331123089] = true,
}

local World1 = SEA1_IDS[game.PlaceId] == true
local World2 = SEA2_IDS[game.PlaceId] == true
local World3 = SEA3_IDS[game.PlaceId] == true

_G.AutoFarm = _G.AutoFarm or false
_G.BringMonster = _G.BringMonster or false
_G.SelectWeapon = _G.SelectWeapon or "Melee"
_G.SelectMaterial = _G.SelectMaterial or "Angel Wings"
_G.AutoHaki = _G.AutoHaki or false
_G.AutoRaceV3 = _G.AutoRaceV3 or false
_G.AutoRaceV4 = _G.AutoRaceV4 or false
_G.WalkWater = _G.WalkWater or true
_G.CheckPoint = _G.CheckPoint or false
_G.AutoStatsMelee = _G.AutoStatsMelee or false
_G.AutoStatsDefense = _G.AutoStatsDefense or false
_G.AutoStatsSword = _G.AutoStatsSword or false
_G.AutoStatsGun = _G.AutoStatsGun or false
_G.AutoStatsFruit = _G.AutoStatsFruit or false

local Mon, NameMon, NameQuest, LevelQuest
local CFrameQuest, CFrameMon, PosMon
local MonFarm, StartBring
local MMon, MPos, SP

local function GetHRP(character)
	return character and character:FindFirstChild("HumanoidRootPart")
end

local function GetHumanoid(character)
	return character and character:FindFirstChildOfClass("Humanoid")
end

local function GetLevel()
	local data = LocalPlayer:FindFirstChild("Data")
	local level = data and data:FindFirstChild("Level")
	return level and level.Value or 1
end

local function InvokeComm(...)
	return CommF:InvokeServer(...)
end

local function EquipWeapon(weaponType)
	local character = LocalPlayer.Character
	local backpack = LocalPlayer:FindFirstChild("Backpack")
	if not character or not backpack then
		return
	end
	local function tryEquip(container)
		for _, item in ipairs(container:GetChildren()) do
			if item:IsA("Tool") then
				local name = string.lower(item.Name)
				if weaponType == "Melee" and (string.find(name, "combat") or string.find(name, "black leg") or string.find(name, "electro") or string.find(name, "fishman") or string.find(name, "dragon") or string.find(name, "superhuman") or string.find(name, "death step") or string.find(name, "sharkman") or string.find(name, "electric") or string.find(name, "godhuman") or string.find(name, "sanguine") or string.find(name, "karate") or string.find(name, "claw") or string.find(name, "talon") or string.find(name, "human")) then
					character.Humanoid:EquipTool(item)
					return true
				elseif weaponType == "Sword" and item.ToolTip == "Sword" then
					character.Humanoid:EquipTool(item)
					return true
				elseif weaponType == "Gun" and item.ToolTip == "Gun" then
					character.Humanoid:EquipTool(item)
					return true
				elseif weaponType == "Blox Fruit" and item.ToolTip == "Blox Fruit" then
					character.Humanoid:EquipTool(item)
					return true
				end
			end
		end
		return false
	end
	if not tryEquip(character) then
		tryEquip(backpack)
	end
end

local function AutoHaki()
	local character = LocalPlayer.Character
	if not character then
		return
	end
	if not character:FindFirstChild("HasBuso") then
		InvokeComm("Buso")
	end
end

local function Click()
	pcall(function()
		VirtualUser:CaptureController()
		VirtualUser:Button1Down(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
	end)
end

local function topos(targetCFrame)
	local hrp = GetHRP(LocalPlayer.Character)
	if not hrp then
		return
	end
	pcall(function()
		hrp.CFrame = targetCFrame
	end)
end

local function TP1(targetCFrame)
	topos(targetCFrame)
end

local function StopTween(state)
	if not state then
		pcall(function()
			local hrp = GetHRP(LocalPlayer.Character)
			if hrp then
				hrp.Anchored = false
			end
		end)
	end
end

local function Hop()
	pcall(function()
		TeleportService:Teleport(game.PlaceId, LocalPlayer)
	end)
end

local function StoreFruit()
	pcall(function()
		InvokeComm("StoreFruit")
	end)
end

local function CheckItem(itemName)
	local character = LocalPlayer.Character
	local backpack = LocalPlayer:FindFirstChild("Backpack")
	if character and character:FindFirstChild(itemName) then
		return true
	end
	if backpack and backpack:FindFirstChild(itemName) then
		return true
	end
	return false
end

local function MaterialMon()
	if _G.SelectMaterial == "Angel Wings" then
		MMon = "Royal Soldier"
		MPos = CFrame.new(-7759.45898, 5606.93652, -1862.70276)
		SP = "SkyArea2"
	elseif _G.SelectMaterial == "Mystic Droplet" then
		MMon = "Water Fighter"
		MPos = CFrame.new(-3331.70459, 239.138336, -10553.3564)
		SP = "ForgottenIsland"
	elseif _G.SelectMaterial == "Vampire Fang" then
		MMon = "Vampire"
		MPos = CFrame.new(-6132.39453, 9.00769424, -1466.16919)
		SP = "Graveyard"
	elseif _G.SelectMaterial == "Gunpowder" then
		MMon = "Pistol Billionaire"
		MPos = CFrame.new(-185.693283, 84.7088699, 6103.62744)
		SP = "Mansion"
	elseif _G.SelectMaterial == "Conjured Cocoa" then
		MMon = "Chocolate Bar Battler"
		MPos = CFrame.new(582.828674, 25.5824986, -12550.7041)
		SP = "Chocolate"
	elseif _G.SelectMaterial == "Mini Tusk" then
		MMon = "Mythological Pirate"
		MPos = CFrame.new(-13456.0498, 469.433228, -7039.96436)
		SP = "BigMansion"
	elseif _G.SelectMaterial == "Fish Tail" then
		if World1 then
			MMon = "Fishman Warrior"
			MPos = CFrame.new(60943.9023, 17.9492188, 1744.11133)
			SP = "Underwater City"
		elseif World3 then
			MMon = "Fishman Captain"
			MPos = CFrame.new(-10828.1064, 331.825989, -9049.14648)
			SP = "PineappleTown"
		end
	elseif _G.SelectMaterial == "Magma Ore" then
		if World1 then
			MMon = "Military Soldier"
			MPos = CFrame.new(-5565.60156, 9.10001755, 8327.56934)
			SP = "Magma"
		elseif World2 then
			MMon = "Lava Pirate"
			MPos = CFrame.new(-5158.77051, 14.4791956, -4654.2627)
			SP = "CircleIslandFire"
		end
	elseif _G.SelectMaterial == "Leather + Scrap Metal" then
		if World1 then
			MMon = "Pirate"
			MPos = CFrame.new(-967.433105, 13.5999937, 4034.24707)
			SP = "Pirate"
		elseif World2 then
			MMon = "Factory Staff"
			MPos = CFrame.new(-105.889565, 72.8076935, -670.247986)
			SP = "Bar"
		elseif World3 then
			MMon = "Pirate Millionaire"
			MPos = CFrame.new(-118.809372, 55.4874573, 5649.17041)
			SP = "Default"
		end
	elseif _G.SelectMaterial == "Radiactive Material" then
		MMon = "Factory Staff"
		MPos = CFrame.new(-105.889565, 72.8076935, -670.247986)
		SP = "Bar"
	end
end

local function CheckQuest()
	local level = GetLevel()
	if not World1 then
		return
	end
	if level >= 1 and level <= 9 then
		Mon = "Bandit"
		LevelQuest = 1
		NameQuest = "BanditQuest1"
		NameMon = "Bandit"
		CFrameQuest = CFrame.new(1059.37195, 15.4495068, 1550.4231)
		CFrameMon = CFrame.new(1045.962646484375, 27.002508163452148, 1560.8203125)
	elseif level >= 10 and level <= 14 then
		Mon = "Monkey"
		LevelQuest = 1
		NameQuest = "JungleQuest"
		NameMon = "Monkey"
	elseif level >= 15 and level <= 29 then
		Mon = "Gorilla"
		LevelQuest = 2
		NameQuest = "JungleQuest"
		NameMon = "Gorilla"
	elseif level >= 30 and level <= 39 then
		Mon = "Pirate"
		LevelQuest = 1
		NameQuest = "BuggyQuest1"
		NameMon = "Pirate"
	elseif level >= 40 and level <= 59 then
		Mon = "Brute"
		LevelQuest = 2
		NameQuest = "BuggyQuest1"
		NameMon = "Brute"
	elseif level >= 60 and level <= 74 then
		Mon = "Desert Bandit"
		LevelQuest = 1
		NameQuest = "DesertQuest"
		NameMon = "Desert Bandit"
		CFrameQuest = CFrame.new(894.488647, 5.14000702, 4392.43359)
		CFrameMon = CFrame.new(924.7998046875, 6.4486746788024902, 4481.5859375)
	elseif level >= 75 and level <= 89 then
		Mon = "Desert Officer"
		LevelQuest = 2
		NameQuest = "DesertQuest"
		NameMon = "Desert Officer"
	elseif level >= 90 and level <= 99 then
		Mon = "Snow Bandit"
		LevelQuest = 1
		NameQuest = "SnowQuest"
		NameMon = "Snow Bandit"
	elseif level >= 100 and level <= 119 then
		Mon = "Snowman"
		LevelQuest = 2
		NameQuest = "SnowQuest"
		NameMon = "Snowman"
		CFrameQuest = CFrame.new(1389.74451, 88.1519318, -1298.90796)
		CFrameMon = CFrame.new(1201.6412353515625, 144.57958984375, -1550.0670166015625)
	elseif level >= 120 and level <= 149 then
		Mon = "Chief Petty Officer"
		LevelQuest = 1
		NameQuest = "MarineQuest2"
		NameMon = "Chief Petty Officer"
	elseif level >= 150 and level <= 174 then
		Mon = "Sky Bandit"
		LevelQuest = 1
		NameQuest = "SkyQuest"
		NameMon = "Sky Bandit"
	elseif level >= 175 and level <= 189 then
		Mon = "Dark Master"
		LevelQuest = 2
		NameQuest = "SkyQuest"
		NameMon = "Dark Master"
	elseif level >= 190 and level <= 209 then
		Mon = "Prisoner"
		LevelQuest = 1
		NameQuest = "PrisonerQuest"
		NameMon = "Prisoner"
		CFrameQuest = CFrame.new(5308.93115, 1.65517521, 475.120514)
		CFrameMon = CFrame.new(5098.9736328125, -0.32040581107139587, 474.23733520507812)
	elseif level >= 210 and level <= 249 then
		Mon = "Dangerous Prisoner"
		LevelQuest = 2
		NameQuest = "PrisonerQuest"
		NameMon = "Dangerous Prisoner"
	elseif level >= 250 and level <= 274 then
		Mon = "Toga Warrior"
		LevelQuest = 1
		NameQuest = "ColosseumQuest"
		NameMon = "Toga Warrior"
		CFrameQuest = CFrame.new(-1580.04663, 6.35000277, -2986.47534)
		CFrameMon = CFrame.new(-1820.21484375, 51.683856964111328, -2740.6650390625)
	elseif level >= 275 and level <= 299 then
		Mon = "Gladiator"
		LevelQuest = 2
		NameQuest = "ColosseumQuest"
		NameMon = "Gladiator"
	elseif level >= 300 and level <= 324 then
		Mon = "Military Soldier"
		LevelQuest = 1
		NameQuest = "MagmaQuest"
		NameMon = "Military Soldier"
	elseif level >= 325 and level <= 374 then
		Mon = "Military Spy"
		LevelQuest = 2
		NameQuest = "MagmaQuest"
		NameMon = "Military Spy"
	elseif level >= 375 and level <= 399 then
		Mon = "Fishman Warrior"
		LevelQuest = 1
		NameQuest = "FishmanQuest"
		NameMon = "Fishman Warrior"
	elseif level >= 400 and level <= 449 then
		Mon = "Fishman Commando"
		LevelQuest = 2
		NameQuest = "FishmanQuest"
		NameMon = "Fishman Commando"
	elseif level >= 450 and level <= 474 then
		Mon = "God's Guard"
		LevelQuest = 1
		NameQuest = "SkyExp1Quest"
		NameMon = "God's Guard"
		CFrameQuest = CFrame.new(-4721.88867, 843.874695, -1949.96643)
		CFrameMon = CFrame.new(-4710.04296875, 845.2769775390625, -1927.3079833984375)
	elseif level >= 475 and level <= 524 then
		Mon = "Shanda"
		LevelQuest = 2
		NameQuest = "SkyExp1Quest"
		NameMon = "Shanda"
		CFrameQuest = CFrame.new(-7859.09814, 5544.19043, -381.476196)
		CFrameMon = CFrame.new(-7678.48974609375, 5566.40380859375, -497.21560668945312)
	elseif level >= 525 and level <= 549 then
		Mon = "Royal Squad"
		LevelQuest = 1
		NameQuest = "SkyExp2Quest"
		NameMon = "Royal Squad"
		CFrameQuest = CFrame.new(-7906.81592, 5634.6626, -1411.99194)
		CFrameMon = CFrame.new(-7624.25244140625, 5658.13330078125, -1467.354248046875)
	elseif level >= 550 and level <= 624 then
		Mon = "Royal Soldier"
		LevelQuest = 2
		NameQuest = "SkyExp2Quest"
		NameMon = "Royal Soldier"
		CFrameQuest = CFrame.new(-7906.81592, 5634.6626, -1411.99194)
		CFrameMon = CFrame.new(-7836.75341796875, 5645.6640625, -1790.6236572265625)
	elseif level >= 625 and level <= 649 then
		Mon = "Galley Pirate"
		LevelQuest = 1
		NameQuest = "FountainQuest"
		NameMon = "Galley Pirate"
		CFrameQuest = CFrame.new(5259.81982, 37.3500175, 4050.0293)
		CFrameMon = CFrame.new(5551.02197265625, 78.901351928710938, 3930.412841796875)
	elseif level >= 650 then
		Mon = "Galley Captain"
		LevelQuest = 2
		NameQuest = "FountainQuest"
		NameMon = "Galley Captain"
		CFrameQuest = CFrame.new(5259.81982, 37.3500175, 4050.0293)
		CFrameMon = CFrame.new(5441.95166015625, 42.502059936523438, 4950.09375)
	end
end

local function BringMob()
	if not _G.BringMonster or not StartBring or not PosMon then
		return
	end
	pcall(function()
		for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
			if (enemy.Name == MonFarm or enemy.Name == Mon) and enemy:FindFirstChild("Humanoid") and enemy:FindFirstChild("HumanoidRootPart") then
				if enemy.Humanoid.Health > 0 then
					local distance = (enemy.HumanoidRootPart.Position - PosMon.Position).Magnitude
					if distance <= 320 then
						enemy.HumanoidRootPart.CFrame = PosMon
						enemy.HumanoidRootPart.CanCollide = false
						enemy.Head.CanCollide = false
						enemy.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
						pcall(function()
							sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
						end)
					end
				end
			end
		end
	end)
end

task.spawn(function()
	while task.wait() do
		if _G.BringMonster then
			BringMob()
		end
	end
end)

task.spawn(function()
	while task.wait(0.1) do
		if _G.AutoHaki then
			pcall(AutoHaki)
		end
	end
end)

task.spawn(function()
	while task.wait() do
		if _G.AutoRaceV3 then
			pcall(function()
				CommE:FireServer("ActivateAbility")
			end)
		end
	end
end)

task.spawn(function()
	while task.wait() do
		if _G.AutoRaceV4 then
			pcall(function()
				VirtualInputManager:SendKeyEvent(true, "Y", false, game)
				task.wait()
				VirtualInputManager:SendKeyEvent(false, "Y", false, game)
			end)
		end
	end
end)

task.spawn(function()
	while task.wait() do
		pcall(function()
			local water = Workspace.Map:FindFirstChild("WaterBase-Plane")
			if water then
				if _G.WalkWater then
					water.Size = Vector3.new(1000, 80, 1000)
				else
					water.Size = Vector3.new(1000, 112, 1000)
				end
			end
		end)
	end
end)

task.spawn(function()
	while task.wait() do
		if _G.AutoStatsMelee or _G.AutoStatsDefense or _G.AutoStatsSword or _G.AutoStatsGun or _G.AutoStatsFruit then
			pcall(function()
				local points = LocalPlayer.Data.Points.Value
				if points > 0 then
					if _G.AutoStatsMelee then
						InvokeComm("AddPoint", "Melee", 1)
					end
					if _G.AutoStatsDefense then
						InvokeComm("AddPoint", "Defense", 1)
					end
					if _G.AutoStatsSword then
						InvokeComm("AddPoint", "Sword", 1)
					end
					if _G.AutoStatsGun then
						InvokeComm("AddPoint", "Gun", 1)
					end
					if _G.AutoStatsFruit then
						InvokeComm("AddPoint", "Demon Fruit", 1)
					end
				end
			end)
		end
	end
end)

local RedzLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/farehamhz/RedzLib/main/RedzLib"))()
local Window = RedzLib:MakeWindow({
	Title = "Zorcex Hub",
	SubTitle = "Blox Fruits",
	SaveFolder = "ZorcexHub",
})

local TabMain = Window:MakeTab({ Name = "Main" })
local TabFarm = Window:MakeTab({ Name = "Farm" })
local TabStats = Window:MakeTab({ Name = "Stats" })
local TabQuest = Window:MakeTab({ Name = "Quest" })
local TabSea = Window:MakeTab({ Name = "Sea Event" })
local TabRaid = Window:MakeTab({ Name = "Raid" })
local TabFruit = Window:MakeTab({ Name = "Fruit" })
local TabShop = Window:MakeTab({ Name = "Shop" })
local TabTeleport = Window:MakeTab({ Name = "Teleport" })
local TabESP = Window:MakeTab({ Name = "ESP" })
local TabLocal = Window:MakeTab({ Name = "Local" })
local TabSettings = Window:MakeTab({ Name = "Settings" })

TabMain:AddParagraph({ Title = "World", Content = World1 and "Sea 1" or World2 and "Sea 2" or World3 and "Sea 3" or "Unknown" })
TabMain:AddDropdown({
	Name = "Select Weapon",
	Options = { "Melee", "Sword", "Gun", "Blox Fruit" },
	Default = _G.SelectWeapon,
	Callback = function(value)
		_G.SelectWeapon = value
	end,
})
TabMain:AddToggle({
	Name = "Auto Farm Level",
	Default = false,
	Callback = function(value)
		_G.AutoFarm = value
	end,
})
TabMain:AddToggle({
	Name = "Bring Mob",
	Default = true,
	Callback = function(value)
		_G.BringMonster = value
		StopTween(value)
	end,
})
TabMain:AddToggle({
	Name = "Auto Kill Near",
	Default = false,
	Callback = function(value)
		_G.AutoKillNear = value
	end,
})
TabMain:AddToggle({
	Name = "Auto Farm Boss",
	Default = false,
	Callback = function(value)
		_G.AutoFarmBoss = value
	end,
})
TabMain:AddToggle({
	Name = "Auto Select Boss",
	Default = false,
	Callback = function(value)
		_G.AutoSelectBoss = value
	end,
})

TabFarm:AddToggle({
	Name = "Farm Bone",
	Default = false,
	Callback = function(value)
		_G.FarmBone = value
	end,
})
TabFarm:AddToggle({
	Name = "Farm Cake Prince",
	Default = false,
	Callback = function(value)
		_G.FarmKatakuri = value
	end,
})
TabFarm:AddToggle({
	Name = "Farm Katakuri V2",
	Default = false,
	Callback = function(value)
		_G.FarmKatakuriV2 = value
	end,
})
TabFarm:AddToggle({
	Name = "Auto Collect Berry",
	Default = false,
	Callback = function(value)
		_G.AutoCollectBerry = value
	end,
})
TabFarm:AddToggle({
	Name = "Auto Farm Chest",
	Default = false,
	Callback = function(value)
		_G.AutoFarmChest = value
	end,
})
TabFarm:AddDropdown({
	Name = "Select Material",
	Options = {
		"Angel Wings",
		"Mystic Droplet",
		"Vampire Fang",
		"Gunpowder",
		"Conjured Cocoa",
		"Mini Tusk",
		"Fish Tail",
		"Magma Ore",
		"Leather + Scrap Metal",
		"Radiactive Material",
	},
	Default = _G.SelectMaterial,
	Callback = function(value)
		_G.SelectMaterial = value
		MaterialMon()
	end,
})
TabFarm:AddToggle({
	Name = "Start Material Farm",
	Default = false,
	Callback = function(value)
		_G.StartMaterialFarm = value
		if value then
			MaterialMon()
		end
	end,
})
TabFarm:AddToggle({
	Name = "Auto Fishing",
	Default = false,
	Callback = function(value)
		_G.AutoFishing = value
	end,
})
TabFarm:AddToggle({
	Name = "Farm Pirate",
	Default = false,
	Callback = function(value)
		_G.FarmPirate = value
	end,
})
TabFarm:AddToggle({
	Name = "Auto Farm Tyrant",
	Default = false,
	Callback = function(value)
		_G.AutoFarmTyrant = value
	end,
})

TabStats:AddToggle({
	Name = "Melee",
	Default = false,
	Callback = function(value)
		_G.AutoStatsMelee = value
	end,
})
TabStats:AddToggle({
	Name = "Defense",
	Default = false,
	Callback = function(value)
		_G.AutoStatsDefense = value
	end,
})
TabStats:AddToggle({
	Name = "Sword",
	Default = false,
	Callback = function(value)
		_G.AutoStatsSword = value
	end,
})
TabStats:AddToggle({
	Name = "Gun",
	Default = false,
	Callback = function(value)
		_G.AutoStatsGun = value
	end,
})
TabStats:AddToggle({
	Name = "Fruit",
	Default = false,
	Callback = function(value)
		_G.AutoStatsFruit = value
	end,
})

TabQuest:AddToggle({
	Name = "Auto Second Sea",
	Default = false,
	Callback = function(value)
		_G.AutoSecondSea = value
	end,
})
TabQuest:AddToggle({
	Name = "Auto Third Sea",
	Default = false,
	Callback = function(value)
		_G.AutoThirdSea = value
	end,
})
TabQuest:AddToggle({
	Name = "Auto Saber",
	Default = false,
	Callback = function(value)
		_G.AutoGetSaber = value
	end,
})
TabQuest:AddToggle({
	Name = "Auto Bartilo Quest",
	Default = false,
	Callback = function(value)
		_G.AutoBartilo = value
	end,
})
TabQuest:AddToggle({
	Name = "Auto Factory",
	Default = false,
	Callback = function(value)
		_G.AutoFactory = value
	end,
})
TabQuest:AddToggle({
	Name = "Kill Greybeard",
	Default = false,
	Callback = function(value)
		_G.KillGreybeard = value
	end,
})
TabQuest:AddToggle({
	Name = "Kill Darkbeard",
	Default = false,
	Callback = function(value)
		_G.KillDarkbeard = value
	end,
})
TabQuest:AddToggle({
	Name = "Kill Cursed Captain",
	Default = false,
	Callback = function(value)
		_G.KillCursedCaptain = value
	end,
})
TabQuest:AddToggle({
	Name = "Kill Rip Indra",
	Default = false,
	Callback = function(value)
		_G.KillRipIndra = value
	end,
})
TabQuest:AddToggle({
	Name = "Kill Elite Hunter",
	Default = false,
	Callback = function(value)
		_G.KillEliteHunter = value
	end,
})
TabQuest:AddToggle({
	Name = "Auto CDK",
	Default = false,
	Callback = function(value)
		_G.AutoCDK = value
	end,
})
TabQuest:AddToggle({
	Name = "Auto Skull Guitar",
	Default = false,
	Callback = function(value)
		_G.AutoSkullGuitar = value
	end,
})
TabQuest:AddToggle({
	Name = "Auto Yama",
	Default = false,
	Callback = function(value)
		_G.AutoYama = value
	end,
})
TabQuest:AddToggle({
	Name = "Auto Tushita",
	Default = false,
	Callback = function(value)
		_G.AutoTushita = value
	end,
})
TabQuest:AddToggle({
	Name = "Auto Holy Torch Tushita",
	Default = false,
	Callback = function(value)
		_G.AutoHolyTorch = value
	end,
})
TabQuest:AddToggle({
	Name = "Trade Bone",
	Default = false,
	Callback = function(value)
		_G.TradeBone = value
	end,
})
TabQuest:AddToggle({
	Name = "Auto Pray",
	Default = false,
	Callback = function(value)
		_G.AutoPray = value
	end,
})
TabQuest:AddToggle({
	Name = "Auto Try Luck",
	Default = false,
	Callback = function(value)
		_G.AutoTryLuck = value
	end,
})

TabSea:AddToggle({
	Name = "Check Kitsune Island",
	Default = false,
	Callback = function(value)
		_G.CheckKitsune = value
	end,
})
TabSea:AddToggle({
	Name = "Tween Kitsune Island",
	Default = false,
	Callback = function(value)
		_G.TweenKitsune = value
	end,
})
TabSea:AddToggle({
	Name = "ESP Kitsune Island",
	Default = false,
	Callback = function(value)
		_G.EspKitsune = value
	end,
})
TabSea:AddToggle({
	Name = "Check Mirage Island",
	Default = false,
	Callback = function(value)
		_G.CheckMirage = value
	end,
})
TabSea:AddToggle({
	Name = "Tween Mirage Island",
	Default = false,
	Callback = function(value)
		_G.TweenMirage = value
	end,
})
TabSea:AddToggle({
	Name = "ESP Mirage Island",
	Default = false,
	Callback = function(value)
		_G.EspMirage = value
	end,
})
TabSea:AddToggle({
	Name = "Check Prehistoric Island",
	Default = false,
	Callback = function(value)
		_G.CheckPrehistoric = value
	end,
})
TabSea:AddToggle({
	Name = "Tween Prehistoric Island",
	Default = false,
	Callback = function(value)
		_G.TweenPrehistoric = value
	end,
})
TabSea:AddToggle({
	Name = "Defend Prehistoric",
	Default = false,
	Callback = function(value)
		_G.DefendPrehistoric = value
	end,
})
TabSea:AddToggle({
	Name = "Auto Drive Boat",
	Default = false,
	Callback = function(value)
		_G.AutoDriveBoat = value
	end,
})
TabSea:AddToggle({
	Name = "Kill Terror Shark",
	Default = false,
	Callback = function(value)
		_G.KillTerrorShark = value
	end,
})
TabSea:AddToggle({
	Name = "Kill Shark",
	Default = false,
	Callback = function(value)
		_G.KillShark = value
	end,
})
TabSea:AddToggle({
	Name = "Kill Piranha",
	Default = false,
	Callback = function(value)
		_G.KillPiranha = value
	end,
})
TabSea:AddToggle({
	Name = "Kill Fish Crew",
	Default = false,
	Callback = function(value)
		_G.KillFishCrew = value
	end,
})
TabSea:AddToggle({
	Name = "Auto Azure Ember",
	Default = false,
	Callback = function(value)
		_G.AutoAzureEmber = value
	end,
})
TabSea:AddToggle({
	Name = "Look Moon + Auto V3",
	Default = false,
	Callback = function(value)
		_G.LookMoon = value
	end,
})
TabSea:AddToggle({
	Name = "Tween To Gear",
	Default = false,
	Callback = function(value)
		_G.TweenGear = value
	end,
})
TabSea:AddToggle({
	Name = "Collect Bone",
	Default = false,
	Callback = function(value)
		_G.CollectBone = value
	end,
})
TabSea:AddToggle({
	Name = "Collect Egg",
	Default = false,
	Callback = function(value)
		_G.CollectEgg = value
	end,
})
TabSea:AddToggle({
	Name = "Kill Golem",
	Default = false,
	Callback = function(value)
		_G.KillGolem = value
	end,
})
TabSea:AddButton({
	Name = "Craft Volcanic Magnet",
	Callback = function()
		pcall(function()
			InvokeComm("CraftItem", "Volcanic Magnet")
		end)
	end,
})

TabRaid:AddToggle({
	Name = "Auto Buy Chip",
	Default = false,
	Callback = function(value)
		_G.AutoBuyChip = value
	end,
})
TabRaid:AddToggle({
	Name = "Auto Start Raid",
	Default = false,
	Callback = function(value)
		_G.AutoStartRaid = value
	end,
})
TabRaid:AddToggle({
	Name = "Auto Farm Raid",
	Default = false,
	Callback = function(value)
		_G.AutoFarmRaid = value
	end,
})
TabRaid:AddToggle({
	Name = "Auto Buy Law Chip",
	Default = false,
	Callback = function(value)
		_G.AutoBuyLawChip = value
	end,
})
TabRaid:AddToggle({
	Name = "Auto Start Law Raid",
	Default = false,
	Callback = function(value)
		_G.AutoStartLawRaid = value
	end,
})
TabRaid:AddToggle({
	Name = "Auto Farm Law Raid",
	Default = false,
	Callback = function(value)
		_G.AutoFarmLawRaid = value
	end,
})
TabRaid:AddToggle({
	Name = "Auto Skill Z",
	Default = false,
	Callback = function(value)
		_G.AutoSkillZ = value
	end,
})
TabRaid:AddToggle({
	Name = "Auto Skill X",
	Default = false,
	Callback = function(value)
		_G.AutoSkillX = value
	end,
})
TabRaid:AddToggle({
	Name = "Auto Skill C",
	Default = false,
	Callback = function(value)
		_G.AutoSkillC = value
	end,
})

TabFruit:AddToggle({
	Name = "Auto Store Fruits",
	Default = false,
	Callback = function(value)
		_G.AutoStoreFruits = value
	end,
})
TabFruit:AddToggle({
	Name = "Auto Random Fruits",
	Default = false,
	Callback = function(value)
		_G.AutoRandomFruits = value
	end,
})
TabFruit:AddButton({
	Name = "Teleport To Fruit Spawn",
	Callback = function()
		pcall(function()
			for _, item in ipairs(Workspace:GetChildren()) do
				if item:IsA("Tool") or string.find(string.lower(item.Name), "fruit") then
					local handle = item:FindFirstChild("Handle") or item:FindFirstChildWhichIsA("BasePart")
					if handle then
						topos(handle.CFrame + Vector3.new(0, 5, 0))
						break
					end
				end
			end
		end)
	end,
})
TabFruit:AddButton({
	Name = "Store Fruit Now",
	Callback = function()
		StoreFruit()
	end,
})

local function BuyItem(itemName)
	InvokeComm("BuyItem", itemName)
end

TabShop:AddButton({
	Name = "Buy Black Leg",
	Callback = function()
		BuyItem("Black Leg")
	end,
})
TabShop:AddButton({
	Name = "Buy Electro",
	Callback = function()
		BuyItem("Electro")
	end,
})
TabShop:AddButton({
	Name = "Buy Fishman Karate",
	Callback = function()
		BuyItem("Fishman Karate")
	end,
})
TabShop:AddButton({
	Name = "Buy Dragon Claw",
	Callback = function()
		InvokeComm("BlackbeardReward", "DragonClaw", "1")
		InvokeComm("BlackbeardReward", "DragonClaw", "2")
	end,
})
TabShop:AddButton({
	Name = "Buy Superhuman",
	Callback = function()
		BuyItem("Superhuman")
	end,
})
TabShop:AddButton({
	Name = "Buy Death Step",
	Callback = function()
		BuyItem("Death Step")
	end,
})
TabShop:AddButton({
	Name = "Buy Sharkman Karate",
	Callback = function()
		BuyItem("Sharkman Karate")
	end,
})
TabShop:AddButton({
	Name = "Buy Electric Claw",
	Callback = function()
		BuyItem("Electric Claw")
	end,
})
TabShop:AddButton({
	Name = "Buy Dragon Talon",
	Callback = function()
		BuyItem("Dragon Talon")
	end,
})
TabShop:AddButton({
	Name = "Buy Godhuman",
	Callback = function()
		BuyItem("Godhuman")
	end,
})
TabShop:AddButton({
	Name = "Buy Sanguine Art",
	Callback = function()
		BuyItem("Sanguine Art")
	end,
})
TabShop:AddButton({
	Name = "Buy Geppo",
	Callback = function()
		BuyItem("Geppo")
	end,
})
TabShop:AddButton({
	Name = "Buy Buso",
	Callback = function()
		BuyItem("Buso")
	end,
})
TabShop:AddButton({
	Name = "Buy Soru",
	Callback = function()
		BuyItem("Soru")
	end,
})
TabShop:AddButton({
	Name = "Buy Observation",
	Callback = function()
		BuyItem("Observation")
	end,
})
TabShop:AddButton({
	Name = "Buy Cutlass",
	Callback = function()
		BuyItem("Cutlass")
	end,
})
TabShop:AddButton({
	Name = "Buy Katana",
	Callback = function()
		BuyItem("Katana")
	end,
})
TabShop:AddButton({
	Name = "Buy Iron Mace",
	Callback = function()
		BuyItem("Iron Mace")
	end,
})
TabShop:AddButton({
	Name = "Buy Dual Katana",
	Callback = function()
		BuyItem("Dual Katana")
	end,
})
TabShop:AddButton({
	Name = "Buy Triple Katana",
	Callback = function()
		BuyItem("Triple Katana")
	end,
})
TabShop:AddButton({
	Name = "Buy Pipe",
	Callback = function()
		BuyItem("Pipe")
	end,
})
TabShop:AddButton({
	Name = "Buy Dual-Headed Blade",
	Callback = function()
		BuyItem("Dual-Headed Blade")
	end,
})
TabShop:AddButton({
	Name = "Buy Bisento",
	Callback = function()
		BuyItem("Bisento")
	end,
})
TabShop:AddButton({
	Name = "Buy Soul Cane",
	Callback = function()
		BuyItem("Soul Cane")
	end,
})
TabShop:AddButton({
	Name = "Buy Pole V2",
	Callback = function()
		InvokeComm("ThunderGodTalk")
	end,
})
TabShop:AddButton({
	Name = "Buy Slingshot",
	Callback = function()
		BuyItem("Slingshot")
	end,
})
TabShop:AddButton({
	Name = "Buy Musket",
	Callback = function()
		BuyItem("Musket")
	end,
})
TabShop:AddButton({
	Name = "Buy Flintlock",
	Callback = function()
		BuyItem("Flintlock")
	end,
})
TabShop:AddButton({
	Name = "Buy Refined Slingshot",
	Callback = function()
		BuyItem("Refined Slingshot")
	end,
})
TabShop:AddButton({
	Name = "Buy Refined Flintlock",
	Callback = function()
		BuyItem("Refined Flintlock")
	end,
})
TabShop:AddButton({
	Name = "Buy Cannon",
	Callback = function()
		BuyItem("Cannon")
	end,
})
TabShop:AddButton({
	Name = "Buy Kabucha",
	Callback = function()
		InvokeComm("BlackbeardReward", "Slingshot", "1")
		InvokeComm("BlackbeardReward", "Slingshot", "2")
	end,
})
TabShop:AddButton({
	Name = "Buy Bizarre Rifle",
	Callback = function()
		InvokeComm("Ectoplasm", "Buy", 1)
	end,
})
TabShop:AddButton({
	Name = "Buy Black Cape",
	Callback = function()
		BuyItem("Black Cape")
	end,
})
TabShop:AddButton({
	Name = "Buy Swordsman Hat",
	Callback = function()
		BuyItem("Swordsman Hat")
	end,
})
TabShop:AddButton({
	Name = "Buy Tomoe Ring",
	Callback = function()
		BuyItem("Tomoe Ring")
	end,
})
TabShop:AddButton({
	Name = "Reset Stats",
	Callback = function()
		InvokeComm("BlackbeardReward", "Refund", "1")
		InvokeComm("BlackbeardReward", "Refund", "2")
	end,
})
TabShop:AddButton({
	Name = "Random Race",
	Callback = function()
		InvokeComm("BlackbeardReward", "Reroll", "1")
		InvokeComm("BlackbeardReward", "Reroll", "2")
	end,
})
TabShop:AddButton({
	Name = "Change Race Ghoul",
	Callback = function()
		InvokeComm("EvolvementProgress")
	end,
})
TabShop:AddButton({
	Name = "Change Race Cyborg",
	Callback = function()
		InvokeComm("CyborgTrainer")
	end,
})

TabTeleport:AddButton({
	Name = "Sea 1",
	Callback = function()
		InvokeComm("TravelMain")
	end,
})
TabTeleport:AddButton({
	Name = "Sea 2",
	Callback = function()
		InvokeComm("TravelDressrosa")
	end,
})
TabTeleport:AddButton({
	Name = "Sea 3",
	Callback = function()
		InvokeComm("TravelZou")
	end,
})
TabTeleport:AddButton({
	Name = "Temple Of Time",
	Callback = function()
		topos(CFrame.new(28286.35546875, 14895.3017578125, 102.50769424438477))
	end,
})
TabTeleport:AddButton({
	Name = "Top Great Tree",
	Callback = function()
		topos(CFrame.new(2948.0, 2288.0, -7215.0))
	end,
})
TabTeleport:AddButton({
	Name = "Race Door",
	Callback = function()
		_G.AutoRaceDoor = true
	end,
})
TabTeleport:AddButton({
	Name = "Lever Pull",
	Callback = function()
		_G.TeleportLever = true
	end,
})
TabTeleport:AddButton({
	Name = "Clock",
	Callback = function()
		_G.TeleportClock = true
	end,
})
TabTeleport:AddButton({
	Name = "Dragon Dojo",
	Callback = function()
		_G.TweenDragonDojo = true
	end,
})

TabESP:AddToggle({
	Name = "ESP Players",
	Default = false,
	Callback = function(value)
		_G.EspPlayers = value
	end,
})
TabESP:AddToggle({
	Name = "ESP Chest",
	Default = false,
	Callback = function(value)
		_G.EspChest = value
	end,
})
TabESP:AddToggle({
	Name = "ESP Fruits",
	Default = false,
	Callback = function(value)
		_G.EspFruits = value
	end,
})
TabESP:AddToggle({
	Name = "ESP Berry",
	Default = false,
	Callback = function(value)
		_G.EspBerry = value
	end,
})
TabESP:AddToggle({
	Name = "ESP Island",
	Default = false,
	Callback = function(value)
		_G.EspIsland = value
	end,
})

TabLocal:AddToggle({
	Name = "Walk On Water",
	Default = true,
	Callback = function(value)
		_G.WalkWater = value
	end,
})
TabLocal:AddToggle({
	Name = "Infinite Soru",
	Default = false,
	Callback = function(value)
		_G.InfiniteSoru = value
	end,
})
TabLocal:AddToggle({
	Name = "Infinite Geppo",
	Default = false,
	Callback = function(value)
		_G.InfiniteGeppo = value
	end,
})
TabLocal:AddToggle({
	Name = "Dodge No CD",
	Default = false,
	Callback = function(value)
		_G.DodgeNoCD = value
	end,
})
TabLocal:AddToggle({
	Name = "Auto Race V3",
	Default = false,
	Callback = function(value)
		_G.AutoRaceV3 = value
	end,
})
TabLocal:AddToggle({
	Name = "Auto Race V4",
	Default = false,
	Callback = function(value)
		_G.AutoRaceV4 = value
	end,
})
TabLocal:AddToggle({
	Name = "Buso Haki",
	Default = false,
	Callback = function(value)
		_G.AutoHaki = value
	end,
})
TabLocal:AddToggle({
	Name = "Delete Lava",
	Default = false,
	Callback = function(value)
		_G.DeleteLava = value
	end,
})
TabLocal:AddButton({
	Name = "FPS Boost",
	Callback = function()
		pcall(function()
			settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
			for _, obj in ipairs(game:GetDescendants()) do
				if obj:IsA("BasePart") then
					obj.Material = Enum.Material.Plastic
					obj.Reflectance = 0
				elseif obj:IsA("Decal") or obj:IsA("Texture") then
					obj.Transparency = 1
				elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
					obj.Enabled = false
				end
			end
		end)
	end,
})

TabSettings:AddToggle({
	Name = "Set Home Point",
	Default = false,
	Callback = function(value)
		_G.CheckPoint = value
	end,
})
TabSettings:AddButton({
	Name = "Join Pirates",
	Callback = function()
		InvokeComm("SetTeam", "Pirates")
	end,
})
TabSettings:AddButton({
	Name = "Join Marines",
	Callback = function()
		InvokeComm("SetTeam", "Marines")
	end,
})
TabSettings:AddButton({
	Name = "Open Titles",
	Callback = function()
		pcall(function()
			LocalPlayer.PlayerGui.Main.Titles.Visible = true
		end)
	end,
})
TabSettings:AddButton({
	Name = "Redeem Codes",
	Callback = function()
		local codes = {
			"SUB2GAMERROBOT_RESET1",
			"SUB2GAMERROBOT_EXP1",
			"LIGHTNINGABUSE",
			"1LOSTADMIN",
			"EASTEREXP",
			"KITT_RESET",
			"SUB2UNCLEKIZARU",
			"SUB2CAPTAINMAUI",
			"SUB2OFFICIALNOOBIE",
			"SUB2NOOBMASTER123",
			"SUB2DAIGROCK",
			"STRAWHATMAINE",
			"TANTAIGAMING",
			"THEGREATACE",
			"KITTGAMING",
			"Sub2Fer999",
			"Enyu_is_Pro",
			"Magicbus",
			"JCWK",
			"Starcodeheo",
			"Bluxxy",
			"Axiore",
			"Bignews",
			"CHANDLER",
			"FUDD10_V2",
			"FUDD10",
		}
		for _, code in ipairs(codes) do
			pcall(function()
				ReplicatedStorage.Remotes.Redeem:InvokeServer(code)
			end)
			task.wait(0.35)
		end
	end,
})
TabSettings:AddButton({
	Name = "Rejoin",
	Callback = function()
		TeleportService:Teleport(game.PlaceId, LocalPlayer)
	end,7676
})
TabSettings:AddButton({
	Name = "Server Hop",
	Callback = function()
		Hop()
	end,
})
TabSettings:AddParagraph({
	Title = "Info",
	Content = "Clean rebuild from dump. Farm loops incomplete. Fix logic yourself.",
})

pcall(function()
	if RedzLib.Init then
		RedzLib:Init()
	end
end)
