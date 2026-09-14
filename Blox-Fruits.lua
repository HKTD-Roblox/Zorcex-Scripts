local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local CommF = Remotes:WaitForChild("CommF_")
local CommE = Remotes:WaitForChild("CommE")

pcall(function()
	hookfunction(require(ReplicatedStorage.Effect.Container.Death), function() end)
end)
pcall(function()
	hookfunction(require(ReplicatedStorage.Effect.Container.Respawn), function() end)
end)

local SEA1 = {[2753915549]=true,[85211729168715]=true}
local SEA2 = {[4442272183]=true,[79091703265657]=true}
local SEA3 = {[7449423635]=true,[100117331123089]=true}
local World1 = SEA1[game.PlaceId] == true
local World2 = SEA2[game.PlaceId] == true
local World3 = SEA3[game.PlaceId] == true

_G.SelectWeapon = _G.SelectWeapon or "Melee"
_G.SelectMaterial = _G.SelectMaterial or "Angel Wings"
_G.SelectChip = _G.SelectChip or "Flame"
_G.BringMonster = _G.BringMonster ~= false
_G.WalkWater = _G.WalkWater ~= false

local Mon, NameMon, NameQuest, LevelQuest, CFrameQuest, CFrameMon
local PosMon, MonFarm, StartBring, MMon, MPos, SP

local function Invoke(...)
	return CommF:InvokeServer(...)
end

local function GetHRP(char)
	return char and char:FindFirstChild("HumanoidRootPart")
end

local function GetLevel()
	local d = LocalPlayer:FindFirstChild("Data")
	local l = d and d:FindFirstChild("Level")
	return l and l.Value or 1
end

local function topos(cf)
	local hrp = GetHRP(LocalPlayer.Character)
	if hrp then pcall(function() hrp.CFrame = cf end) end
end

local function Click()
	pcall(function()
		VirtualUser:CaptureController()
		VirtualUser:Button1Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
	end)
end

local function AutoHaki()
	local char = LocalPlayer.Character
	if char and not char:FindFirstChild("HasBuso") then
		pcall(function() Invoke("Buso") end)
	end
end

local function BuyItem(name)
	pcall(function() Invoke("BuyItem", name) end)
end

local function CraftItem(name)
	pcall(function() Invoke("CraftItem", name) end)
end

local function Hop()
	pcall(function()
		local ok, servers = pcall(function()
			return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
		end)
		if ok and servers and servers.data then
			for _, s in ipairs(servers.data) do
				if s.playing < s.maxPlayers and s.id ~= game.JobId then
					TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
					return
				end
			end
		end
		TeleportService:Teleport(game.PlaceId, LocalPlayer)
	end)
end

local function MaterialMon()
	local mat = _G.SelectMaterial
	if mat == "Angel Wings" then MMon,MPos,SP = "Royal Soldier", CFrame.new(-7759.45898,5606.93652,-1862.70276), "SkyArea2"
	elseif mat == "Mystic Droplet" then MMon,MPos,SP = "Water Fighter", CFrame.new(-3331.70459,239.138336,-10553.3564), "ForgottenIsland"
	elseif mat == "Vampire Fang" then MMon,MPos,SP = "Vampire", CFrame.new(-6132.39453,9.00769424,-1466.16919), "Graveyard"
	elseif mat == "Gunpowder" then MMon,MPos,SP = "Pistol Billionaire", CFrame.new(-185.693283,84.7088699,6103.62744), "Mansion"
	elseif mat == "Conjured Cocoa" then MMon,MPos,SP = "Chocolate Bar Battler", CFrame.new(582.828674,25.5824986,-12550.7041), "Chocolate"
	elseif mat == "Mini Tusk" then MMon,MPos,SP = "Mythological Pirate", CFrame.new(-13456.0498,469.433228,-7039.96436), "BigMansion"
	elseif mat == "Fish Tail" then
		if World1 then MMon,MPos,SP = "Fishman Warrior", CFrame.new(60943.9023,17.9492188,1744.11133), "Underwater City"
		elseif World3 then MMon,MPos,SP = "Fishman Captain", CFrame.new(-10828.1064,331.825989,-9049.14648), "PineappleTown" end
	elseif mat == "Magma Ore" then
		if World1 then MMon,MPos,SP = "Military Soldier", CFrame.new(-5565.60156,9.10001755,8327.56934), "Magma"
		elseif World2 then MMon,MPos,SP = "Lava Pirate", CFrame.new(-5158.77051,14.4791956,-4654.2627), "CircleIslandFire" end
	elseif mat == "Leather + Scrap Metal" then
		if World1 then MMon,MPos,SP = "Brute", CFrame.new(-1191.41235,15.5999985,4235.50928), "Pirate"
		elseif World2 then MMon,MPos,SP = "Factory Staff", CFrame.new(-105.889565,72.8076935,-670.247986), "Bar"
		elseif World3 then MMon,MPos,SP = "Pirate Millionaire", CFrame.new(-118.809372,55.4874573,5649.17041), "Default" end
	elseif mat == "Radiactive Material" then MMon,MPos,SP = "Factory Staff", CFrame.new(-105.889565,72.8076935,-670.247986), "Bar"
	end
end

local function CheckQuest()
	if not World1 then return end
	local level = GetLevel()
	if level <= 9 then Mon,LevelQuest,NameQuest,NameMon = "Bandit",1,"BanditQuest1","Bandit"
		CFrameQuest = CFrame.new(1059.37195,15.4495068,1550.4231)
		CFrameMon = CFrame.new(1045.962646484375,27.002508163452148,1560.8203125)
	elseif level <= 14 then Mon,LevelQuest,NameQuest,NameMon = "Monkey",1,"JungleQuest","Monkey"
	elseif level <= 29 then Mon,LevelQuest,NameQuest,NameMon = "Gorilla",2,"JungleQuest","Gorilla"
	elseif level <= 39 then Mon,LevelQuest,NameQuest,NameMon = "Pirate",1,"BuggyQuest1","Pirate"
	elseif level <= 59 then Mon,LevelQuest,NameQuest,NameMon = "Brute",2,"BuggyQuest1","Brute"
	elseif level <= 74 then Mon,LevelQuest,NameQuest,NameMon = "Desert Bandit",1,"DesertQuest","Desert Bandit"
		CFrameQuest = CFrame.new(894.488647,5.14000702,4392.43359)
		CFrameMon = CFrame.new(924.7998046875,6.4486746788024902,4481.5859375)
	elseif level <= 89 then Mon,LevelQuest,NameQuest,NameMon = "Desert Officer",2,"DesertQuest","Desert Officer"
	elseif level <= 99 then Mon,LevelQuest,NameQuest,NameMon = "Snow Bandit",1,"SnowQuest","Snow Bandit"
	elseif level <= 119 then Mon,LevelQuest,NameQuest,NameMon = "Snowman",2,"SnowQuest","Snowman"
		CFrameQuest = CFrame.new(1389.74451,88.1519318,-1298.90796)
		CFrameMon = CFrame.new(1201.6412353515625,144.57958984375,-1550.0670166015625)
	elseif level <= 149 then Mon,LevelQuest,NameQuest,NameMon = "Chief Petty Officer",1,"MarineQuest2","Chief Petty Officer"
	elseif level <= 174 then Mon,LevelQuest,NameQuest,NameMon = "Sky Bandit",1,"SkyQuest","Sky Bandit"
	elseif level <= 189 then Mon,LevelQuest,NameQuest,NameMon = "Dark Master",2,"SkyQuest","Dark Master"
	elseif level <= 209 then Mon,LevelQuest,NameQuest,NameMon = "Prisoner",1,"PrisonerQuest","Prisoner"
		CFrameQuest = CFrame.new(5308.93115,1.65517521,475.120514)
		CFrameMon = CFrame.new(5098.9736328125,-0.32040581107139587,474.23733520507812)
	elseif level <= 249 then Mon,LevelQuest,NameQuest,NameMon = "Dangerous Prisoner",2,"PrisonerQuest","Dangerous Prisoner"
	elseif level <= 274 then Mon,LevelQuest,NameQuest,NameMon = "Toga Warrior",1,"ColosseumQuest","Toga Warrior"
		CFrameQuest = CFrame.new(-1580.04663,6.35000277,-2986.47534)
		CFrameMon = CFrame.new(-1820.21484375,51.683856964111328,-2740.6650390625)
	elseif level <= 299 then Mon,LevelQuest,NameQuest,NameMon = "Gladiator",2,"ColosseumQuest","Gladiator"
	elseif level <= 324 then Mon,LevelQuest,NameQuest,NameMon = "Military Soldier",1,"MagmaQuest","Military Soldier"
	elseif level <= 374 then Mon,LevelQuest,NameQuest,NameMon = "Military Spy",2,"MagmaQuest","Military Spy"
	elseif level <= 399 then Mon,LevelQuest,NameQuest,NameMon = "Fishman Warrior",1,"FishmanQuest","Fishman Warrior"
	elseif level <= 449 then Mon,LevelQuest,NameQuest,NameMon = "Fishman Commando",2,"FishmanQuest","Fishman Commando"
	elseif level <= 474 then Mon,LevelQuest,NameQuest,NameMon = "God's Guard",1,"SkyExp1Quest","God's Guard"
		CFrameQuest = CFrame.new(-4721.88867,843.874695,-1949.96643)
		CFrameMon = CFrame.new(-4710.04296875,845.2769775390625,-1927.3079833984375)
	elseif level <= 524 then Mon,LevelQuest,NameQuest,NameMon = "Shanda",2,"SkyExp1Quest","Shanda"
		CFrameQuest = CFrame.new(-7859.09814,5544.19043,-381.476196)
		CFrameMon = CFrame.new(-7678.48974609375,5566.40380859375,-497.21560668945312)
	elseif level <= 549 then Mon,LevelQuest,NameQuest,NameMon = "Royal Squad",1,"SkyExp2Quest","Royal Squad"
		CFrameQuest = CFrame.new(-7906.81592,5634.6626,-1411.99194)
		CFrameMon = CFrame.new(-7624.25244140625,5658.13330078125,-1467.354248046875)
	elseif level <= 624 then Mon,LevelQuest,NameQuest,NameMon = "Royal Soldier",2,"SkyExp2Quest","Royal Soldier"
		CFrameQuest = CFrame.new(-7906.81592,5634.6626,-1411.99194)
		CFrameMon = CFrame.new(-7836.75341796875,5645.6640625,-1790.6236572265625)
	elseif level <= 649 then Mon,LevelQuest,NameQuest,NameMon = "Galley Pirate",1,"FountainQuest","Galley Pirate"
		CFrameQuest = CFrame.new(5259.81982,37.3500175,4050.0293)
		CFrameMon = CFrame.new(5551.02197265625,78.901351928710938,3930.412841796875)
	else Mon,LevelQuest,NameQuest,NameMon = "Galley Captain",2,"FountainQuest","Galley Captain"
		CFrameQuest = CFrame.new(5259.81982,37.3500175,4050.0293)
		CFrameMon = CFrame.new(5441.95166015625,42.502059936523438,4950.09375)
	end
end

local function BringMob()
	if not _G.BringMonster or not StartBring or not PosMon then return end
	pcall(function()
		for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
			if (enemy.Name == MonFarm or enemy.Name == Mon) and enemy:FindFirstChild("Humanoid") and enemy:FindFirstChild("HumanoidRootPart") then
				if enemy.Humanoid.Health > 0 and (enemy.HumanoidRootPart.Position - PosMon.Position).Magnitude <= 320 then
					enemy.HumanoidRootPart.CFrame = PosMon
					enemy.HumanoidRootPart.CanCollide = false
					if enemy:FindFirstChild("Head") then enemy.Head.CanCollide = false end
					enemy.HumanoidRootPart.Size = Vector3.new(60,60,60)
					pcall(function() sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge) end)
				end
			end
		end
	end)
end

task.spawn(function() while task.wait() do if _G.BringMonster then BringMob() end end end)
task.spawn(function() while task.wait(0.15) do if _G.AutoHaki then AutoHaki() end end end)
task.spawn(function() while task.wait() do if _G.AutoRaceV3 then pcall(function() CommE:FireServer("ActivateAbility") end) end end end)
task.spawn(function() while task.wait(0.5) do if _G.AutoRaceV4 then pcall(function()
	VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Y, false, game)
	task.wait()
	VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Y, false, game)
end) end end end)
task.spawn(function() while task.wait() do pcall(function()
	local water = Workspace.Map:FindFirstChild("WaterBase-Plane")
	if water then water.Size = _G.WalkWater and Vector3.new(1000,80,1000) or Vector3.new(1000,112,1000) end
end) end end)
task.spawn(function() while task.wait(0.3) do pcall(function()
	local pts = LocalPlayer.Data.Points.Value
	if pts > 0 then
		if _G.AutoStatsMelee then Invoke("AddPoint","Melee",1) end
		if _G.AutoStatsDefense then Invoke("AddPoint","Defense",1) end
		if _G.AutoStatsSword then Invoke("AddPoint","Sword",1) end
		if _G.AutoStatsGun then Invoke("AddPoint","Gun",1) end
		if _G.AutoStatsFruit then Invoke("AddPoint","Demon Fruit",1) end
	end
end) end end)
task.spawn(function() while task.wait(1) do if _G.AutoStoreFruits then pcall(function() Invoke("StoreFruit") end) end end end)
task.spawn(function() while task.wait(1) do if _G.CheckPoint then pcall(function() Invoke("SetSpawnPoint") end) end end end)

local function T(name, flag, default)
	return { Name = name, Default = default or false, Callback = function(v) _G[flag] = v end }
end

local RedzLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/farehamhz/RedzLib/main/RedzLib"))()
local Window = RedzLib:MakeWindow({ Title = "Zorcex Hub", SubTitle = "Blox Fruits", SaveFolder = "Zorcex Hub" })

pcall(function()
	local gui = Instance.new("ScreenGui")
	gui.Name = "ControlGUI"
	gui.ResetOnSpawn = false
	gui.Parent = CoreGui
	local btn = Instance.new("ImageButton")
	btn.Size = UDim2.new(0, 40, 0, 40)
	btn.Position = UDim2.new(0.12, 0, 0.12, 0)
	btn.Image = "rbxassetid://80424431930361"
	btn.BackgroundTransparency = 1
	btn.Parent = gui
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0.25, 0)
	corner.Parent = btn
	local dragging, dragStart, startPos
	btn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = btn.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	btn.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local d = input.Position - dragStart
			btn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
		end
	end)
	btn.MouseButton1Click:Connect(function()
		pcall(function()
			if Window.Open then Window:Open() elseif Window.Toggle then Window:Toggle() end
		end)
	end)
end)

local TabFarm = Window:MakeTab({ "Farming", "home" })
local TabFish = Window:MakeTab({ "Auto Fishing", "droplet" })
local TabQuest = Window:MakeTab({ "Quest | Items", "swords" })
local TabDojo = Window:MakeTab({ "Volcano Dojo", "cake" })
local TabSea = Window:MakeTab({ "Sea Event", "waves" })
local TabRace = Window:MakeTab({ "Race V4", "crown" })
local TabRaid = Window:MakeTab({ "Raid Fruits", "cherry" })
local TabFruit = Window:MakeTab({ "Fruits | Check Stock", "apple" })
local TabTP = Window:MakeTab({ "Teleport", "locate" })
local TabPvP = Window:MakeTab({ "Player", "user" })
local TabShop = Window:MakeTab({ "Shop", "shoppingcart" })
local TabSettings = Window:MakeTab({ "Settings", "settings" })

TabFarm:AddParagraph({ Title = "World", Content = World1 and "Sea 1" or World2 and "Sea 2" or World3 and "Sea 3" or tostring(game.PlaceId) })
TabFarm:AddDropdown({ Name = "Chon Cong Cu", Options = {"Melee","Sword","Gun","Blox Fruit"}, Default = _G.SelectWeapon, Callback = function(v) _G.SelectWeapon = v end })
TabFarm:AddToggle(T("Auto Farm Level","AutoFarm"))
TabFarm:AddToggle(T("Farm Level New","FarmLevelNew"))
TabFarm:AddToggle(T("Auto Kill Near | Mob Aura","AutoKillNear"))
TabFarm:AddToggle(T("Auto Select Boss","AutoSelectBoss"))
TabFarm:AddToggle(T("Auto Farm Boss","AutoFarmBoss"))
TabFarm:AddToggle(T("Farm Pirate","FarmPirate"))
TabFarm:AddToggle(T("Farm Boss","FarmBoss"))
TabFarm:AddButton({ Name = "Cap Nhat Boss", Callback = function() _G.UpdateBossList = true end })
TabFarm:AddParagraph({ Title = "Boss Spawn Status", Content = "Check in-game" })
TabFarm:AddToggle(T("Check Eyes Status","CheckEyes"))
TabFarm:AddToggle(T("Auto Farm Tyrant","AutoFarmTyrant"))
TabFarm:AddButton({ Name = "Summon Tyrant Of The Skies", Callback = function() _G.SummonTyrant = true end })
TabFarm:AddToggle(T("Check Bone","CheckBone"))
TabFarm:AddToggle(T("Fram Bone","FarmBone"))
TabFarm:AddToggle(T("Seperator Hallow Scythe","HallowScythe"))
TabFarm:AddToggle(T("Trade Bone","TradeBone"))
TabFarm:AddToggle(T("Auto Pray","AutoPray"))
TabFarm:AddToggle(T("Auto Try Luck","AutoTryLuck"))
TabFarm:AddToggle(T("Check Cake Prince","CheckCakePrince"))
TabFarm:AddToggle(T("Farm Katakuri","FarmKatakuri"))
TabFarm:AddToggle(T("Farm Katakuri V2","FarmKatakuriV2"))
TabFarm:AddToggle(T("Auto Collect Berry","AutoCollectBerry"))
TabFarm:AddToggle(T("Auto Farm Chest [ Tween ]","AutoFarmChest"))
TabFarm:AddDropdown({ Name = "Select Material", Options = {"Angel Wings","Mystic Droplet","Vampire Fang","Gunpowder","Conjured Cocoa","Mini Tusk","Fish Tail","Magma Ore","Leather + Scrap Metal","Radiactive Material"}, Default = _G.SelectMaterial, Callback = function(v) _G.SelectMaterial = v MaterialMon() end })
TabFarm:AddToggle({ Name = "Start Farm", Default = false, Callback = function(v) _G.StartMaterialFarm = v if v then MaterialMon() end end })
TabFarm:AddToggle(T("Bring Mod","BringMonster", true))

TabFish:AddToggle(T("Auto Fishing","AutoFishing"))
TabFish:AddDropdown({ Name = "Select Fishing Lure", Options = {"Default","Lure1","Lure2","Lure3"}, Default = "Default", Callback = function(v) _G.SelectLure = v pcall(function() Invoke("SelectBait", v) end) end })
TabFish:AddDropdown({ Name = "Select Fishing Rod", Options = {"Default","Rod1","Rod2","Rod3"}, Default = "Default", Callback = function(v) _G.SelectRod = v end })

for _, x in ipairs({
	{"AutoSecondSea","AutoSecondSea"},{"Auto Quest Sea 3","AutoThirdSea"},{"Auto Quest Sea Bartilo","AutoBartilo"},
	{"Kill Greybeard","KillGreybeard"},{"Auto Get Saber","AutoGetSaber"},{"Auto Get Sword Pole","AutoGetPole"},
	{"Auto Get Sword Saw","AutoGetSaw"},{"Auto Get Sword Wardens","AutoGetWardens"},{"Auto Get Sword Trident","AutoGetTrident"},
	{"Auto Factory","AutoFactory"},{"Auto Kill Dark Beard","KillDarkbeard"},{"Auto Kill Cursed Captain","KillCursedCaptain"},
	{"Auto Buy Haki Colors","AutoBuyHakiColors"},{"Auto Buy Legendary Sword","AutoBuyLegendarySword"},
	{"Auto Get Longsword","AutoGetLongsword"},{"Auto Get Sword Gravity Blade","AutoGetGravityBlade"},
	{"Auto Get Sword Flail","AutoGetFlail"},{"Auto Get Sword Rengoku","AutoGetRengoku"},
	{"Auto Get Sword Dragon Trident","AutoGetDragonTrident"},{"Auto kill Rip Indra","KillRipIndra"},
	{"Auto Haki Colors","AutoHakiColors"},{"Auto Skull Guitar","AutoSkullGuitar"},{"Kill Elite Hunter","KillEliteHunter"},
	{"Auto Cdk [Beta]","AutoCDK"},{"Auto Get Yama","AutoGetYama"},{"Auto Holy Torch Tushita","AutoHolyTorch"},
	{"Auto Get Tushita","AutoGetTushita"},{"Auto Get Sword Twin Hooks","AutoGetTwinHooks"},
	{"Auto Get Sword Canvander","AutoGetCanvander"},{"Auto Get Sword Buddy","AutoGetBuddy"},
}) do TabQuest:AddToggle(T(x[1], x[2])) end

TabQuest:AddButton({ Name = "soulGuitarBuy", Callback = function() pcall(function() Invoke("soulGuitarBuy") end) end })
TabQuest:AddButton({ Name = "CDK Quest Progress", Callback = function() pcall(function() Invoke("CDKQuest") end) end })
TabQuest:AddButton({ Name = "Elite Hunter", Callback = function() pcall(function() Invoke("EliteHunter") end) end })
TabQuest:AddButton({ Name = "Bartilo Quest Progress", Callback = function() pcall(function() Invoke("BartiloQuestProgress") end) end })
TabQuest:AddButton({ Name = "Abandon Quest", Callback = function() pcall(function() Invoke("AbandonQuest") end) end })

TabDojo:AddButton({ Name = "Tween Dragon Dojo", Callback = function() _G.TweenDragonDojo = true end })
TabDojo:AddToggle(T("Auto Dragon Huntery","AutoDragonHunter"))
TabDojo:AddButton({ Name = "Craft Volcanic Magnet", Callback = function() CraftItem("Volcanic Magnet") end })

for _, x in ipairs({
	{"Check Prehistoric Island","CheckPrehistoric"},{"Auto Find Prehistoric","FindPrehistoric"},
	{"Auto Tween Prehistoric Island","TweenPrehistoric"},{"Auto Defend Prehistoric","DefendPrehistoric"},
	{"Auto Use Melee","AutoUseMelee"},{"Auto Use Sword","AutoUseSword"},{"Auto Use Gun","AutoUseGun"},
	{"Auto Kill Golem","KillGolem"},{"Auto Kill Aura Golem","KillAuraGolem"},{"Auto Collect Bone","CollectBone"},
	{"Auto Collect Egg","CollectEgg"},{"Check Kitsune Island","CheckKitsune"},{"Auto Tween Kitsune island","TweenKitsune"},
	{"Esp Kitsune Island","EspKitsune"},{"Auto Azuer Ember","AutoAzureEmber"},{"Auto Drive Boats","AutoDriveBoats"},
	{"Auto Kill Terror Shank","KillTerrorShark"},{"Auto Kill Shark","KillShark"},{"Auto Kill Piranha","KillPiranha"},
	{"Auto Kill Fish Crew Member","KillFishCrew"},{"Check Mirage Island","CheckMirage"},{"Tween Mirage Island","TweenMirage"},
	{"Esp Mirage Island","EspMirage"},{"Look Moon + Auto V3","LookMoon"},{"Auto Tween To Gear","TweenGear"},
}) do TabSea:AddToggle(T(x[1], x[2])) end
TabSea:AddButton({ Name = "Buy Boat", Callback = function() pcall(function() Invoke("BuyBoat") end) end })
TabSea:AddButton({ Name = "Gravestone Event", Callback = function() pcall(function() Invoke("gravestoneEvent") end) end })
TabSea:AddButton({ Name = "Cake Prince Spawner", Callback = function() pcall(function() Invoke("CakePrinceSpawner") end) end })

TabRace:AddButton({ Name = "Teleport To Top GreatTree", Callback = function() topos(CFrame.new(2948,2288,-7215)) end })
TabRace:AddButton({ Name = "Teleport Temple Of Time", Callback = function() topos(CFrame.new(28286.35546875,14895.3017578125,102.50769424438477)) end })
TabRace:AddButton({ Name = "Teleport Lever Pull", Callback = function() _G.TeleportLever = true end })
TabRace:AddButton({ Name = "Teleport To The Clock", Callback = function() _G.TeleportClock = true end })
TabRace:AddToggle(T("Auto Race Door","AutoRaceDoor"))
TabRace:AddButton({ Name = "Buy Acient One Quest", Callback = function() pcall(function() Invoke("ProQuestProgress","AncientOne") end) end })
TabRace:AddToggle(T("Auto Trial Human Ghost","AutoTrial"))
TabRace:AddToggle(T("Auto Trailer All Race","AutoTrialAllRace"))
TabRace:AddToggle(T("Auto Kill Player Trailer V4","AutoKillTrialPlayer"))
TabRace:AddToggle(T("Auto Active Race V3","AutoRaceV3"))
TabRace:AddToggle(T("Auto Active Race V4","AutoRaceV4"))
TabRace:AddButton({ Name = "Upgrade Race", Callback = function() pcall(function() Invoke("UpgradeRace") end) end })

TabRaid:AddDropdown({ Name = "Select Chip", Options = {"Flame","Ice","Quake","Light","Dark","Spider","Rumble","Magma","Buddha","Sand","Phoenix","Dough"}, Default = _G.SelectChip, Callback = function(v) _G.SelectChip = v end })
for _, x in ipairs({
	{"Auto Buy Chip","AutoBuyChip"},{"Auto Start Raid","AutoStartRaid"},{"Auto Farm Raid Next Island","AutoFarmRaid"},
	{"Auto Get Fruit Low Beli","AutoGetFruitLowBeli"},{"Auto Buy Chip Law","AutoBuyLawChip"},{"Auto Start Raid Law","AutoStartLawRaid"},
	{"Auto Farm Law Raid","AutoFarmLawRaid"},{"Auto Skill Z","AutoSkillZ"},{"Auto Skill X","AutoSkillX"},{"Auto Skill C","AutoSkillC"},
}) do TabRaid:AddToggle(T(x[1], x[2])) end

TabFruit:AddToggle(T("Auto Random Fruits","AutoRandomFruits"))
TabFruit:AddToggle(T("Auto Store Fruits","AutoStoreFruits"))
TabFruit:AddButton({ Name = "Teleport To Fruit Spawn", Callback = function()
	pcall(function()
		for _, obj in ipairs(Workspace:GetChildren()) do
			local n = string.lower(obj.Name)
			if string.find(n,"fruit") or obj:IsA("Tool") then
				local part = obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart")
				if part then topos(part.CFrame + Vector3.new(0,6,0)) return end
			end
		end
	end)
end })
TabFruit:AddButton({ Name = "Store Fruit Now", Callback = function() pcall(function() Invoke("StoreFruit") end) end })
TabFruit:AddButton({ Name = "Stock Trai Cay", Callback = function() pcall(function() print(Invoke("getInventory")) end) end })
TabFruit:AddToggle(T("Esp Fruits","EspFruits"))
TabFruit:AddToggle(T("Esp Berry","EspBerry"))

TabTP:AddButton({ Name = "Join Sea 1", Callback = function() Invoke("TravelMain") end })
TabTP:AddButton({ Name = "Join Sea 2", Callback = function() Invoke("TravelDressrosa") end })
TabTP:AddButton({ Name = "Join Sea 3", Callback = function() Invoke("TravelZou") end })
TabTP:AddButton({ Name = "requestEntrance", Callback = function() pcall(function() Invoke("requestEntrance") end) end })

TabPvP:AddToggle(T("Esp Players","EspPlayers"))
TabPvP:AddToggle(T("Esp Chest","EspChest"))
TabPvP:AddToggle(T("Speed Chay by Dum hub","SpeedHack"))
TabPvP:AddToggle(T("Nhay Cao by Dum hub","JumpHack"))
TabPvP:AddToggle(T("Get Quest Elite Players","ElitePlayerQuest"))
TabPvP:AddToggle(T("Auto Kill Player Quest","AutoKillPlayerQuest"))
TabPvP:AddButton({ Name = "Player Hunter", Callback = function() pcall(function() Invoke("PlayerHunter") end) end })

local shopBuys = {
	{"Buy Black Leg $150,000","Black Leg"},{"Buy Electro $550,000","Electro"},{"Buy Water Kung Fu $750,000","Fishman Karate"},
	{"Buy Superhuman $3,000,000","Superhuman"},{"Buy Death Step $5,000,000 5,000F","Death Step"},
	{"Buy Electric Claw $3,000,000 5,000F","Electric Claw"},{"Buy Dragon Talon $3,000,000 5,000F","Dragon Talon"},
	{"Buy God Human $5,000,000 5,000F","Godhuman"},{"Buy Sanguine Art $5,000,000 5,000F","Sanguine Art"},
	{"Buy Geppo $10,000","Geppo"},{"Buy Buso Haki $25,000","Buso"},{"Buy Soru $25,000","Soru"},
	{"Buy Observation Haki $750,000","Observation"},{"Buy Cutlass $1,000","Cutlass"},{"Buy Katana $1,000","Katana"},
	{"Buy Iron Mace $25,000","Iron Mace"},{"Buy Dual Katana $12,000","Dual Katana"},{"Buy Triple Katana $60,000","Triple Katana"},
	{"Buy Pipe $100,000","Pipe"},{"Buy Dual-Headed Blade $400,000","Dual-Headed Blade"},{"Buy Bisento $1,200,000","Bisento"},
	{"Buy Soul Cane $750,000","Soul Cane"},{"Buy Slingshot $5,000","Slingshot"},{"Buy Musket $8,000","Musket"},
	{"Buy Flintlock $10,500","Flintlock"},{"Refined Slingshot $30,000","Refined Slingshot"},
	{"Buy Refined Flintlock $65,000","Refined Flintlock"},{"Buy Cannon $100,000","Cannon"},
	{"Buy Black Cape $50,000","Black Cape"},{"Swordsman Hat $150,000","Swordsman Hat"},{"Buy Tomoe Ring $500,000","Tomoe Ring"},
}
for _, x in ipairs(shopBuys) do
	local title, item = x[1], x[2]
	TabShop:AddButton({ Name = title, Callback = function() BuyItem(item) end })
end
TabShop:AddButton({ Name = "Buy Dragon Claw 1,500F", Callback = function() Invoke("BlackbeardReward","DragonClaw","1") Invoke("BlackbeardReward","DragonClaw","2") end })
TabShop:AddButton({ Name = "Buy Sharkman Karate $2,500,000 5,000F", Callback = function() pcall(function() Invoke("BuySharkmanKarate") end) BuyItem("Sharkman Karate") end })
TabShop:AddButton({ Name = "Buy Pole V2 5,000F", Callback = function() Invoke("ThunderGodTalk") end })
TabShop:AddButton({ Name = "Buy Kabucha 1,500F", Callback = function() Invoke("BlackbeardReward","Slingshot","1") Invoke("BlackbeardReward","Slingshot","2") end })
TabShop:AddButton({ Name = "Buy Bizarre Rifle 250 Ectoplasm", Callback = function() Invoke("Ectoplasm","Buy",1) end })
for _, c in ipairs({"Dragonheart","Dragonstorm","DinoHood","SharkTooth","TerrorJaw","SharkAnchor","LeviathanCrown","LeviathanShield","LeviathanBoat","LegendaryScroll","MythicalScroll"}) do
	TabShop:AddButton({ Name = "Craft "..c, Callback = function() CraftItem(c) end })
end
TabShop:AddButton({ Name = "BuyHaki", Callback = function() pcall(function() Invoke("BuyHaki") end) end })
TabShop:AddButton({ Name = "Doi Toc Ghoul", Callback = function() pcall(function() Invoke("EvolvementProgress") end) end })
TabShop:AddButton({ Name = "Doi Toc Cyborg", Callback = function() pcall(function() Invoke("CyborgTrainer") end) end })
TabShop:AddButton({ Name = "Reset Stats 2,500F", Callback = function() Invoke("BlackbeardReward","Refund","1") Invoke("BlackbeardReward","Refund","2") end })
TabShop:AddButton({ Name = "Random Race 3,000F", Callback = function() Invoke("BlackbeardReward","Reroll","1") Invoke("BlackbeardReward","Reroll","2") end })

TabSettings:AddParagraph({ Title = "Unban Fast Attack - M1 Fruit", Content = "External load if needed" })
for _, x in ipairs({
	{"Set Home Point","CheckPoint"},{"Infinite Soru","InfiniteSoru"},{"Infinite Geppo","InfiniteGeppo"},
	{"Dodge No CD","DodgeNoCD"},{"Walk on Water","WalkWater", true},{"Melee","AutoStatsMelee"},{"Defense","AutoStatsDefense"},
	{"Sword","AutoStatsSword"},{"Gun","AutoStatsGun"},{"Fruis","AutoStatsFruit"},{"Buso Haki","AutoHaki"},
	{"Delete Lava","DeleteLava"},{"BodyClip","BodyClip"},
}) do TabSettings:AddToggle(T(x[1], x[2], x[3])) end
TabSettings:AddButton({ Name = "Join Pirates Team", Callback = function() Invoke("SetTeam","Pirates") end })
TabSettings:AddButton({ Name = "Join Marines Team", Callback = function() Invoke("SetTeam","Marines") end })
TabSettings:AddButton({ Name = "Open Title Name", Callback = function() pcall(function() LocalPlayer.PlayerGui.Main.Titles.Visible = true end) end })
TabSettings:AddButton({ Name = "FPS Boost", Callback = function()
	pcall(function()
		settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
		for _, obj in ipairs(game:GetDescendants()) do
			if obj:IsA("BasePart") then obj.Material = Enum.Material.Plastic obj.Reflectance = 0
			elseif obj:IsA("Decal") or obj:IsA("Texture") then obj.Transparency = 1
			elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Fire") or obj:IsA("Smoke") then obj.Enabled = false end
		end
	end)
end })
TabSettings:AddButton({ Name = "Codes", Callback = function()
	for _, code in ipairs({"LIGHTNINGABUSE","SUB2GAMERROBOT_RESET1","SUB2GAMERROBOT_EXP1","EASTEREXP","1LOSTADMIN","KITT_RESET","SUB2CAPTAINMAUI","SUB2UNCLEKIZARU","SUB2OFFICIALNOOBIE","SUB2NOOBMASTER123","SUB2DAIGROCK","STRAWHATMAINE","TANTAIGAMING","THEGREATACE","KITTGAMING","Sub2Fer999","Enyu_is_Pro","Magicbus","JCWK","Starcodeheo","Bluxxy","Axiore","Bignews","CHANDLER","FUDD10_V2","FUDD10"}) do
		pcall(function() Remotes.Redeem:InvokeServer(code) end)
		task.wait(0.3)
	end
end })
TabSettings:AddButton({ Name = "Rejoin Server", Callback = function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end })
TabSettings:AddButton({ Name = "Server Hop", Callback = function() Hop() end })
TabSettings:AddParagraph({ Title = "Info", Content = "UI+tabs+icons+ControlGUI restored from dump. Farm engines = flags only." })

pcall(function() if RedzLib.Init then RedzLib:Init() end end)
