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


local LANG_FILE = "ZorcexHub_Lang.txt"
local function LoadLang()
	local ok, data = pcall(function()
		if isfile and isfile(LANG_FILE) then
			return readfile(LANG_FILE)
		end
	end)
	if ok and (data == "vi" or data == "en") then
		return data
	end
	return "en"
end

local CurrentLang = LoadLang()
local PendingLang = CurrentLang

local L = {
	en = {
		SelectWeapon = "Select weapon",
		AutoFarmLevel = "Auto farm by quest level",
		FarmLevelNew = "New farm level mode",
		AutoKillNear = "Attack nearby enemies",
		AutoSelectBoss = "Auto pick boss",
		AutoFarmBoss = "Auto farm boss",
		FarmPirate = "Farm pirate area",
		FarmBoss = "Farm selected boss",
		UpdateBoss = "Refresh boss list",
		BossStatus = "Boss spawn status",
		CheckEyes = "Check Eyes status",
		AutoFarmTyrant = "Auto farm Tyrant",
		SummonTyrant = "Summon Tyrant",
		CheckBone = "Check Bone count",
		FarmBone = "Farm Bone",
		HallowScythe = "Hallow Scythe helper",
		TradeBone = "Trade Bone",
		AutoPray = "Auto Pray",
		AutoTryLuck = "Auto Try Luck",
		CheckCake = "Check Cake Prince",
		FarmKatakuri = "Farm Katakuri",
		FarmKatakuriV2 = "Farm Katakuri V2",
		CollectBerry = "Collect Berry",
		FarmChest = "Farm chests (tween)",
		SelectMaterial = "Select material",
		StartFarm = "Start material farm",
		BringMod = "Bring enemies closer",
		AutoFishing = "Auto fishing",
		SelectLure = "Select lure",
		SelectRod = "Select rod",
		AutoSecondSea = "Auto Second Sea",
		AutoThirdSea = "Auto Third Sea quest",
		AutoBartilo = "Auto Bartilo quest",
		KillGreybeard = "Kill Greybeard",
		GetSaber = "Get Saber",
		GetPole = "Get Pole",
		GetSaw = "Get Saw",
		GetWardens = "Get Wardens",
		GetTrident = "Get Trident",
		AutoFactory = "Auto Factory",
		KillDarkbeard = "Kill Dark Beard",
		KillCursedCaptain = "Kill Cursed Captain",
		BuyHakiColors = "Buy Haki colors",
		BuyLegendarySword = "Buy Legendary Sword",
		GetLongsword = "Get Longsword",
		GetGravityBlade = "Get Gravity Blade",
		GetFlail = "Get Flail",
		GetRengoku = "Get Rengoku",
		GetDragonTrident = "Get Dragon Trident",
		KillRipIndra = "Kill Rip Indra",
		AutoHakiColors = "Auto Haki colors",
		SkullGuitar = "Skull Guitar",
		KillElite = "Kill Elite Hunter",
		AutoCDK = "Auto CDK (Beta)",
		GetYama = "Get Yama",
		HolyTorch = "Holy Torch Tushita",
		GetTushita = "Get Tushita",
		GetTwinHooks = "Get Twin Hooks",
		GetCanvander = "Get Canvander",
		GetBuddy = "Get Buddy Sword",
		SoulGuitarBuy = "Buy Skull Guitar",
		CDKProgress = "CDK quest progress",
		EliteHunterBtn = "Elite Hunter remote",
		BartiloProgress = "Bartilo progress",
		AbandonQuest = "Abandon current quest",
		TweenDojo = "Tween to Dragon Dojo",
		DragonHunter = "Auto Dragon Hunter",
		CraftMagnet = "Craft Volcanic Magnet",
		CheckPrehistoric = "Check Prehistoric Island",
		FindPrehistoric = "Find Prehistoric",
		TweenPrehistoric = "Tween Prehistoric",
		DefendPrehistoric = "Defend Prehistoric",
		UseMelee = "Use Melee",
		UseSword = "Use Sword",
		UseGun = "Use Gun",
		KillGolem = "Kill Golem",
		KillAuraGolem = "Kill Aura Golem",
		CollectBone = "Collect Bone",
		CollectEgg = "Collect Egg",
		CheckKitsune = "Check Kitsune Island",
		TweenKitsune = "Tween Kitsune",
		EspKitsune = "ESP Kitsune Island",
		AzureEmber = "Auto Azure Ember",
		DriveBoats = "Auto drive boats",
		KillTerrorShark = "Kill Terror Shark",
		KillShark = "Kill Shark",
		KillPiranha = "Kill Piranha",
		KillFishCrew = "Kill Fish Crew",
		CheckMirage = "Check Mirage Island",
		TweenMirage = "Tween Mirage",
		EspMirage = "ESP Mirage Island",
		LookMoon = "Look Moon + Race V3",
		TweenGear = "Tween to Gear",
		BuyBoat = "Buy boat",
		Gravestone = "Gravestone event",
		CakeSpawner = "Spawn Cake Prince",
		TPGreatTree = "Top of Great Tree",
		TPTemple = "Temple Of Time",
		TPLever = "Teleport to lever",
		TPClock = "Teleport to clock",
		RaceDoor = "Open Race door",
		AncientOne = "Ancient One quest",
		TrialHG = "Trial Human/Ghost",
		TrialAll = "Trial all races",
		KillTrialPlayer = "Kill Trial V4 player",
		RaceV3 = "Activate Race V3",
		RaceV4 = "Activate Race V4",
		UpgradeRace = "Upgrade Race",
		SelectChip = "Select raid chip",
		BuyChip = "Buy raid chip",
		StartRaid = "Start raid",
		FarmRaid = "Farm next raid island",
		FruitLowBeli = "Get low-beli fruit",
		BuyLawChip = "Buy Law chip",
		StartLaw = "Start Law raid",
		FarmLaw = "Farm Law raid",
		SkillZ = "Auto skill Z",
		SkillX = "Auto skill X",
		SkillC = "Auto skill C",
		RandomFruit = "Random fruit",
		StoreFruit = "Store fruits",
		TPFruit = "Teleport to fruit",
		StoreNow = "Store fruit now",
		FruitStock = "Show fruit stock",
		EspFruit = "ESP fruits",
		EspBerry = "ESP Berry",
		Sea1 = "Travel Sea 1",
		Sea2 = "Travel Sea 2",
		Sea3 = "Travel Sea 3",
		Entrance = "Request entrance",
		EspPlayers = "ESP players",
		EspChest = "ESP chests",
		SpeedBoost = "Increase walk speed",
		JumpBoost = "Increase jump height",
		EliteQuest = "Elite player quest",
		KillPlayerQuest = "Kill quest player",
		PlayerHunter = "Player Hunter",
		BuyItem = "Buy item",
		CraftItem = "Craft item",
		ChangeGhoul = "Change race to Ghoul",
		ChangeCyborg = "Change race to Cyborg",
		ResetStats = "Reset stats",
		RandomRace = "Random race",
		HomePoint = "Save spawn point",
		InfSoru = "Unlimited Soru",
		InfGeppo = "Unlimited Geppo",
		DodgeNoCD = "Dodge without cooldown",
		WalkWater = "Walk on water",
		StatMelee = "Auto add Melee",
		StatDef = "Auto add Defense",
		StatSword = "Auto add Sword",
		StatGun = "Auto add Gun",
		StatFruit = "Auto add Fruit",
		Buso = "Auto Buso Haki",
		DeleteLava = "Remove lava parts",
		BodyClip = "Clip through parts",
		Pirates = "Join Pirates",
		Marines = "Join Marines",
		OpenTitle = "Open Titles menu",
		FPSBoost = "Boost FPS",
		Codes = "Redeem all codes",
		Rejoin = "Rejoin this server",
		ServerHop = "Hop to another server",
		LangLabel = "Language",
		LangSelect = "Select this language",
		LangHint = "Save language and reload UI",
		World = "World",
		Info = "UI language applied after reload",
		FastAttack = "External load if needed",
	},
	vi = {
		SelectWeapon = "Chọn vũ khí",
		AutoFarmLevel = "Tự farm theo level",
		FarmLevelNew = "Chế độ farm level mới",
		AutoKillNear = "Đánh quái gần",
		AutoSelectBoss = "Tự chọn boss",
		AutoFarmBoss = "Tự farm boss",
		FarmPirate = "Farm khu Pirate",
		FarmBoss = "Farm boss đã chọn",
		UpdateBoss = "Cập nhật boss",
		BossStatus = "Trạng thái boss",
		CheckEyes = "Kiểm tra Eyes",
		AutoFarmTyrant = "Tự farm Tyrant",
		SummonTyrant = "Triệu hồi Tyrant",
		CheckBone = "Kiểm tra Bone",
		FarmBone = "Farm Bone",
		HallowScythe = "Hỗ trợ Hallow Scythe",
		TradeBone = "Đổi Bone",
		AutoPray = "Tự Pray",
		AutoTryLuck = "Tự Try Luck",
		CheckCake = "Kiểm tra Cake Prince",
		FarmKatakuri = "Farm Katakuri",
		FarmKatakuriV2 = "Farm Katakuri V2",
		CollectBerry = "Nhặt Berry",
		FarmChest = "Farm rương (tween)",
		SelectMaterial = "Chọn material",
		StartFarm = "Bắt đầu farm",
		BringMod = "Gom quái",
		AutoFishing = "Tự câu cá",
		SelectLure = "Chọn mồi",
		SelectRod = "Chọn cần",
		AutoSecondSea = "Tự mở Sea 2",
		AutoThirdSea = "Quest Sea 3",
		AutoBartilo = "Quest Bartilo",
		KillGreybeard = "Giết Greybeard",
		GetSaber = "Nhận Saber",
		GetPole = "Nhận Pole",
		GetSaw = "Nhận Saw",
		GetWardens = "Nhận Wardens",
		GetTrident = "Nhận Trident",
		AutoFactory = "Tự Factory",
		KillDarkbeard = "Giết Dark Beard",
		KillCursedCaptain = "Giết Cursed Captain",
		BuyHakiColors = "Mua màu Haki",
		BuyLegendarySword = "Mua Legendary Sword",
		GetLongsword = "Nhận Longsword",
		GetGravityBlade = "Nhận Gravity Blade",
		GetFlail = "Nhận Flail",
		GetRengoku = "Nhận Rengoku",
		GetDragonTrident = "Nhận Dragon Trident",
		KillRipIndra = "Giết Rip Indra",
		AutoHakiColors = "Tự Haki Colors",
		SkullGuitar = "Skull Guitar",
		KillElite = "Giết Elite Hunter",
		AutoCDK = "Tự CDK (Beta)",
		GetYama = "Nhận Yama",
		HolyTorch = "Holy Torch Tushita",
		GetTushita = "Nhận Tushita",
		GetTwinHooks = "Nhận Twin Hooks",
		GetCanvander = "Nhận Canvander",
		GetBuddy = "Nhận Buddy",
		SoulGuitarBuy = "Mua Skull Guitar",
		CDKProgress = "Tiến trình CDK",
		EliteHunterBtn = "Remote Elite Hunter",
		BartiloProgress = "Tiến trình Bartilo",
		AbandonQuest = "Hủy quest",
		TweenDojo = "Tới Dragon Dojo",
		DragonHunter = "Tự Dragon Hunter",
		CraftMagnet = "Chế Volcanic Magnet",
		CheckPrehistoric = "Check Prehistoric",
		FindPrehistoric = "Tìm Prehistoric",
		TweenPrehistoric = "Tween Prehistoric",
		DefendPrehistoric = "Phòng thủ Prehistoric",
		UseMelee = "Dùng Melee",
		UseSword = "Dùng Sword",
		UseGun = "Dùng Gun",
		KillGolem = "Giết Golem",
		KillAuraGolem = "Giết Aura Golem",
		CollectBone = "Nhặt Bone",
		CollectEgg = "Nhặt Egg",
		CheckKitsune = "Check Kitsune",
		TweenKitsune = "Tween Kitsune",
		EspKitsune = "ESP Kitsune",
		AzureEmber = "Tự Azure Ember",
		DriveBoats = "Tự lái thuyền",
		KillTerrorShark = "Giết Terror Shark",
		KillShark = "Giết Shark",
		KillPiranha = "Giết Piranha",
		KillFishCrew = "Giết Fish Crew",
		CheckMirage = "Check Mirage",
		TweenMirage = "Tween Mirage",
		EspMirage = "ESP Mirage",
		LookMoon = "Moon + Race V3",
		TweenGear = "Tween Gear",
		BuyBoat = "Mua thuyền",
		Gravestone = "Sự kiện Gravestone",
		CakeSpawner = "Spawn Cake Prince",
		TPGreatTree = "Lên Great Tree",
		TPTemple = "Tới Temple Of Time",
		TPLever = "Tới lever",
		TPClock = "Tới đồng hồ",
		RaceDoor = "Mở cửa Race",
		AncientOne = "Quest Ancient One",
		TrialHG = "Trial Human/Ghost",
		TrialAll = "Trial mọi Race",
		KillTrialPlayer = "Giết player Trial V4",
		RaceV3 = "Bật Race V3",
		RaceV4 = "Bật Race V4",
		UpgradeRace = "Nâng Race",
		SelectChip = "Chọn chip",
		BuyChip = "Mua chip",
		StartRaid = "Bắt đầu Raid",
		FarmRaid = "Farm đảo Raid",
		FruitLowBeli = "Fruit giá thấp",
		BuyLawChip = "Mua chip Law",
		StartLaw = "Bắt đầu Law Raid",
		FarmLaw = "Farm Law Raid",
		SkillZ = "Skill Z",
		SkillX = "Skill X",
		SkillC = "Skill C",
		RandomFruit = "Random fruit",
		StoreFruit = "Cất fruit",
		TPFruit = "Tới fruit spawn",
		StoreNow = "Cất fruit ngay",
		FruitStock = "Kho fruit",
		EspFruit = "ESP fruit",
		EspBerry = "ESP Berry",
		Sea1 = "Tới Sea 1",
		Sea2 = "Tới Sea 2",
		Sea3 = "Tới Sea 3",
		Entrance = "Vào entrance",
		EspPlayers = "ESP player",
		EspChest = "ESP rương",
		SpeedBoost = "Tăng tốc",
		JumpBoost = "Nhảy cao",
		EliteQuest = "Quest Elite Player",
		KillPlayerQuest = "Giết player quest",
		PlayerHunter = "Player Hunter",
		BuyItem = "Mua vật phẩm",
		CraftItem = "Chế tạo",
		ChangeGhoul = "Đổi tộc Ghoul",
		ChangeCyborg = "Đổi tộc Cyborg",
		ResetStats = "Reset chỉ số",
		RandomRace = "Random tộc",
		HomePoint = "Lưu spawn",
		InfSoru = "Soru vô hạn",
		InfGeppo = "Geppo vô hạn",
		DodgeNoCD = "Né không cooldown",
		WalkWater = "Đi trên nước",
		StatMelee = "Cộng Melee",
		StatDef = "Cộng Defense",
		StatSword = "Cộng Sword",
		StatGun = "Cộng Gun",
		StatFruit = "Cộng Fruit",
		Buso = "Bật Buso Haki",
		DeleteLava = "Xóa lava",
		BodyClip = "Xuyên tường",
		Pirates = "Phe Pirates",
		Marines = "Phe Marines",
		OpenTitle = "Mở Title",
		FPSBoost = "Tăng FPS",
		Codes = "Nhập code",
		Rejoin = "Vào lại server",
		ServerHop = "Đổi server",
		LangLabel = "Ngôn ngữ",
		LangSelect = "Chọn ngôn ngữ này",
		LangHint = "Lưu ngôn ngữ và tải lại UI",
		World = "Thế giới",
		Info = "Ngôn ngữ áp dụng sau khi tải lại",
		FastAttack = "Cần load thêm nếu muốn",
	},
}

local function S(key)
	local pack = L[CurrentLang] or L.en
	return pack[key] or (L.en[key] or key)
end

local function T(name, flag, default, descKey)
	return {
		Name = name,
		Description = S(descKey),
		Default = default or false,
		Callback = function(v)
			_G[flag] = v
		end,
	}
end

local function B(name, descKey, callback)
	return {
		Name = name,
		Description = S(descKey),
		Callback = callback,
	}
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
local TabFish = Window:MakeTab({ "Auto Fishing", "rbxassetid://127664059821666" })
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

TabFarm:AddParagraph({ Title = S("World"), Content = World1 and "Sea 1" or World2 and "Sea 2" or World3 and "Sea 3" or tostring(game.PlaceId) })
TabFarm:AddDropdown({
	Name = "Select Weapon",
	Description = S("SelectWeapon"),
	Options = {"Melee","Sword","Gun","Blox Fruit"},
	Default = _G.SelectWeapon,
	Callback = function(v) _G.SelectWeapon = v end,
})
TabFarm:AddToggle(T("Auto Farm Level", "AutoFarm", false, "AutoFarmLevel"))
TabFarm:AddToggle(T("Farm Level New", "FarmLevelNew", false, "FarmLevelNew"))
TabFarm:AddToggle(T("Auto Kill Near | Mob Aura", "AutoKillNear", false, "AutoKillNear"))
TabFarm:AddToggle(T("Auto Select Boss", "AutoSelectBoss", false, "AutoSelectBoss"))
TabFarm:AddToggle(T("Auto Farm Boss", "AutoFarmBoss", false, "AutoFarmBoss"))
TabFarm:AddToggle(T("Farm Pirate", "FarmPirate", false, "FarmPirate"))
TabFarm:AddToggle(T("Farm Boss", "FarmBoss", false, "FarmBoss"))
TabFarm:AddButton(B("Update Boss", "UpdateBoss", function() _G.UpdateBossList = true end))
TabFarm:AddParagraph({ Title = "Boss Spawn Status", Content = S("BossStatus") })
TabFarm:AddToggle(T("Check Eyes Status", "CheckEyes", false, "CheckEyes"))
TabFarm:AddToggle(T("Auto Farm Tyrant", "AutoFarmTyrant", false, "AutoFarmTyrant"))
TabFarm:AddButton(B("Summon Tyrant Of The Skies", "SummonTyrant", function() _G.SummonTyrant = true end))
TabFarm:AddToggle(T("Check Bone", "CheckBone", false, "CheckBone"))
TabFarm:AddToggle(T("Farm Bone", "FarmBone", false, "FarmBone"))
TabFarm:AddToggle(T("Separator Hallow Scythe", "HallowScythe", false, "HallowScythe"))
TabFarm:AddToggle(T("Trade Bone", "TradeBone", false, "TradeBone"))
TabFarm:AddToggle(T("Auto Pray", "AutoPray", false, "AutoPray"))
TabFarm:AddToggle(T("Auto Try Luck", "AutoTryLuck", false, "AutoTryLuck"))
TabFarm:AddToggle(T("Check Cake Prince", "CheckCakePrince", false, "CheckCake"))
TabFarm:AddToggle(T("Farm Katakuri", "FarmKatakuri", false, "FarmKatakuri"))
TabFarm:AddToggle(T("Farm Katakuri V2", "FarmKatakuriV2", false, "FarmKatakuriV2"))
TabFarm:AddToggle(T("Auto Collect Berry", "AutoCollectBerry", false, "CollectBerry"))
TabFarm:AddToggle(T("Auto Farm Chest [ Tween ]", "AutoFarmChest", false, "FarmChest"))
TabFarm:AddDropdown({
	Name = "Select Material",
	Description = S("SelectMaterial"),
	Options = {"Angel Wings","Mystic Droplet","Vampire Fang","Gunpowder","Conjured Cocoa","Mini Tusk","Fish Tail","Magma Ore","Leather + Scrap Metal","Radiactive Material"},
	Default = _G.SelectMaterial,
	Callback = function(v) _G.SelectMaterial = v MaterialMon() end,
})
TabFarm:AddToggle({
	Name = "Start Farm",
	Description = S("StartFarm"),
	Default = false,
	Callback = function(v) _G.StartMaterialFarm = v if v then MaterialMon() end end,
})
TabFarm:AddToggle(T("Bring Mod", "BringMonster", true, "BringMod"))

TabFish:AddToggle(T("Auto Fishing", "AutoFishing", false, "AutoFishing"))
TabFish:AddDropdown({
	Name = "Select Fishing Lure",
	Description = S("SelectLure"),
	Options = {"Default","Lure1","Lure2","Lure3"},
	Default = "Default",
	Callback = function(v) _G.SelectLure = v pcall(function() Invoke("SelectBait", v) end) end,
})
TabFish:AddDropdown({
	Name = "Select Fishing Rod",
	Description = S("SelectRod"),
	Options = {"Default","Rod1","Rod2","Rod3"},
	Default = "Default",
	Callback = function(v) _G.SelectRod = v end,
})

local questItems = {
	{"AutoSecondSea","AutoSecondSea","AutoSecondSea"},
	{"Auto Quest Sea 3","AutoThirdSea","AutoThirdSea"},
	{"Auto Quest Sea Bartilo","AutoBartilo","AutoBartilo"},
	{"Kill Greybeard","KillGreybeard","KillGreybeard"},
	{"Auto Get Saber","AutoGetSaber","GetSaber"},
	{"Auto Get Sword Pole","AutoGetPole","GetPole"},
	{"Auto Get Sword Saw","AutoGetSaw","GetSaw"},
	{"Auto Get Sword Wardens","AutoGetWardens","GetWardens"},
	{"Auto Get Sword Trident","AutoGetTrident","GetTrident"},
	{"Auto Factory","AutoFactory","AutoFactory"},
	{"Auto Kill Dark Beard","KillDarkbeard","KillDarkbeard"},
	{"Auto Kill Cursed Captain","KillCursedCaptain","KillCursedCaptain"},
	{"Auto Buy Haki Colors","AutoBuyHakiColors","BuyHakiColors"},
	{"Auto Buy Legendary Sword","AutoBuyLegendarySword","BuyLegendarySword"},
	{"Auto Get Longsword","AutoGetLongsword","GetLongsword"},
	{"Auto Get Sword Gravity Blade","AutoGetGravityBlade","GetGravityBlade"},
	{"Auto Get Sword Flail","AutoGetFlail","GetFlail"},
	{"Auto Get Sword Rengoku","AutoGetRengoku","GetRengoku"},
	{"Auto Get Sword Dragon Trident","AutoGetDragonTrident","GetDragonTrident"},
	{"Auto Kill Rip Indra","KillRipIndra","KillRipIndra"},
	{"Auto Haki Colors","AutoHakiColors","AutoHakiColors"},
	{"Auto Skull Guitar","AutoSkullGuitar","SkullGuitar"},
	{"Kill Elite Hunter","KillEliteHunter","KillElite"},
	{"Auto Cdk [Beta]","AutoCDK","AutoCDK"},
	{"Auto Get Yama","AutoGetYama","GetYama"},
	{"Auto Holy Torch Tushita","AutoHolyTorch","HolyTorch"},
	{"Auto Get Tushita","AutoGetTushita","GetTushita"},
	{"Auto Get Sword Twin Hooks","AutoGetTwinHooks","GetTwinHooks"},
	{"Auto Get Sword Canvander","AutoGetCanvander","GetCanvander"},
	{"Auto Get Sword Buddy","AutoGetBuddy","GetBuddy"},
}
for _, x in ipairs(questItems) do
	TabQuest:AddToggle(T(x[1], x[2], false, x[3]))
end
TabQuest:AddButton(B("soulGuitarBuy", "SoulGuitarBuy", function() pcall(function() Invoke("soulGuitarBuy") end) end))
TabQuest:AddButton(B("CDK Quest Progress", "CDKProgress", function() pcall(function() Invoke("CDKQuest") end) end))
TabQuest:AddButton(B("Elite Hunter", "EliteHunterBtn", function() pcall(function() Invoke("EliteHunter") end) end))
TabQuest:AddButton(B("Bartilo Quest Progress", "BartiloProgress", function() pcall(function() Invoke("BartiloQuestProgress") end) end))
TabQuest:AddButton(B("Abandon Quest", "AbandonQuest", function() pcall(function() Invoke("AbandonQuest") end) end))

TabDojo:AddButton(B("Tween Dragon Dojo", "TweenDojo", function() _G.TweenDragonDojo = true end))
TabDojo:AddToggle(T("Auto Dragon Hunter", "AutoDragonHunter", false, "DragonHunter"))
TabDojo:AddButton(B("Craft Volcanic Magnet", "CraftMagnet", function() CraftItem("Volcanic Magnet") end))

local seaItems = {
	{"Check Prehistoric Island","CheckPrehistoric","CheckPrehistoric"},
	{"Auto Find Prehistoric","FindPrehistoric","FindPrehistoric"},
	{"Auto Tween Prehistoric Island","TweenPrehistoric","TweenPrehistoric"},
	{"Auto Defend Prehistoric","DefendPrehistoric","DefendPrehistoric"},
	{"Auto Use Melee","AutoUseMelee","UseMelee"},
	{"Auto Use Sword","AutoUseSword","UseSword"},
	{"Auto Use Gun","AutoUseGun","UseGun"},
	{"Auto Kill Golem","KillGolem","KillGolem"},
	{"Auto Kill Aura Golem","KillAuraGolem","KillAuraGolem"},
	{"Auto Collect Bone","CollectBone","CollectBone"},
	{"Auto Collect Egg","CollectEgg","CollectEgg"},
	{"Check Kitsune Island","CheckKitsune","CheckKitsune"},
	{"Auto Tween Kitsune Island","TweenKitsune","TweenKitsune"},
	{"Esp Kitsune Island","EspKitsune","EspKitsune"},
	{"Auto Azure Ember","AutoAzureEmber","AzureEmber"},
	{"Auto Drive Boats","AutoDriveBoats","DriveBoats"},
	{"Auto Kill Terror Shark","KillTerrorShark","KillTerrorShark"},
	{"Auto Kill Shark","KillShark","KillShark"},
	{"Auto Kill Piranha","KillPiranha","KillPiranha"},
	{"Auto Kill Fish Crew Member","KillFishCrew","KillFishCrew"},
	{"Check Mirage Island","CheckMirage","CheckMirage"},
	{"Tween Mirage Island","TweenMirage","TweenMirage"},
	{"Esp Mirage Island","EspMirage","EspMirage"},
	{"Look Moon + Auto V3","LookMoon","LookMoon"},
	{"Auto Tween To Gear","TweenGear","TweenGear"},
}
for _, x in ipairs(seaItems) do
	TabSea:AddToggle(T(x[1], x[2], false, x[3]))
end
TabSea:AddButton(B("Buy Boat", "BuyBoat", function() pcall(function() Invoke("BuyBoat") end) end))
TabSea:AddButton(B("Gravestone Event", "Gravestone", function() pcall(function() Invoke("gravestoneEvent") end) end))
TabSea:AddButton(B("Cake Prince Spawner", "CakeSpawner", function() pcall(function() Invoke("CakePrinceSpawner") end) end))

TabRace:AddButton(B("Teleport To Top Great Tree", "TPGreatTree", function() topos(CFrame.new(2948,2288,-7215)) end))
TabRace:AddButton(B("Teleport Temple Of Time", "TPTemple", function() topos(CFrame.new(28286.35546875,14895.3017578125,102.50769424438477)) end))
TabRace:AddButton(B("Teleport Lever Pull", "TPLever", function() _G.TeleportLever = true end))
TabRace:AddButton(B("Teleport To The Clock", "TPClock", function() _G.TeleportClock = true end))
TabRace:AddToggle(T("Auto Race Door", "AutoRaceDoor", false, "RaceDoor"))
TabRace:AddButton(B("Buy Ancient One Quest", "AncientOne", function() pcall(function() Invoke("ProQuestProgress","AncientOne") end) end))
TabRace:AddToggle(T("Auto Trial Human Ghost", "AutoTrial", false, "TrialHG"))
TabRace:AddToggle(T("Auto Trial All Race", "AutoTrialAllRace", false, "TrialAll"))
TabRace:AddToggle(T("Auto Kill Player Trial V4", "AutoKillTrialPlayer", false, "KillTrialPlayer"))
TabRace:AddToggle(T("Auto Active Race V3", "AutoRaceV3", false, "RaceV3"))
TabRace:AddToggle(T("Auto Active Race V4", "AutoRaceV4", false, "RaceV4"))
TabRace:AddButton(B("Upgrade Race", "UpgradeRace", function() pcall(function() Invoke("UpgradeRace") end) end))

TabRaid:AddDropdown({
	Name = "Select Chip",
	Description = S("SelectChip"),
	Options = {"Flame","Ice","Quake","Light","Dark","Spider","Rumble","Magma","Buddha","Sand","Phoenix","Dough"},
	Default = _G.SelectChip,
	Callback = function(v) _G.SelectChip = v end,
})
local raidItems = {
	{"Auto Buy Chip","AutoBuyChip","BuyChip"},
	{"Auto Start Raid","AutoStartRaid","StartRaid"},
	{"Auto Farm Raid Next Island","AutoFarmRaid","FarmRaid"},
	{"Auto Get Fruit Low Beli","AutoGetFruitLowBeli","FruitLowBeli"},
	{"Auto Buy Chip Law","AutoBuyLawChip","BuyLawChip"},
	{"Auto Start Raid Law","AutoStartLawRaid","StartLaw"},
	{"Auto Farm Law Raid","AutoFarmLawRaid","FarmLaw"},
	{"Auto Skill Z","AutoSkillZ","SkillZ"},
	{"Auto Skill X","AutoSkillX","SkillX"},
	{"Auto Skill C","AutoSkillC","SkillC"},
}
for _, x in ipairs(raidItems) do
	TabRaid:AddToggle(T(x[1], x[2], false, x[3]))
end

TabFruit:AddToggle(T("Auto Random Fruits", "AutoRandomFruits", false, "RandomFruit"))
TabFruit:AddToggle(T("Auto Store Fruits", "AutoStoreFruits", false, "StoreFruit"))
TabFruit:AddButton(B("Teleport To Fruit Spawn", "TPFruit", function()
	pcall(function()
		for _, obj in ipairs(Workspace:GetChildren()) do
			local n = string.lower(obj.Name)
			if string.find(n,"fruit") or obj:IsA("Tool") then
				local part = obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart")
				if part then topos(part.CFrame + Vector3.new(0,6,0)) return end
			end
		end
	end)
end))
TabFruit:AddButton(B("Store Fruit Now", "StoreNow", function() pcall(function() Invoke("StoreFruit") end) end))
TabFruit:AddButton(B("Fruit Stock", "FruitStock", function() pcall(function() print(Invoke("getInventory")) end) end))
TabFruit:AddToggle(T("Esp Fruits", "EspFruits", false, "EspFruit"))
TabFruit:AddToggle(T("Esp Berry", "EspBerry", false, "EspBerry"))

TabTP:AddButton(B("Join Sea 1", "Sea1", function() Invoke("TravelMain") end))
TabTP:AddButton(B("Join Sea 2", "Sea2", function() Invoke("TravelDressrosa") end))
TabTP:AddButton(B("Join Sea 3", "Sea3", function() Invoke("TravelZou") end))
TabTP:AddButton(B("Request Entrance", "Entrance", function() pcall(function() Invoke("requestEntrance") end) end))

TabPvP:AddToggle(T("Esp Players", "EspPlayers", false, "EspPlayers"))
TabPvP:AddToggle(T("Esp Chest", "EspChest", false, "EspChest"))
TabPvP:AddToggle(T("Speed Boost", "SpeedHack", false, "SpeedBoost"))
TabPvP:AddToggle(T("Jump Boost", "JumpHack", false, "JumpBoost"))
TabPvP:AddToggle(T("Get Quest Elite Players", "ElitePlayerQuest", false, "EliteQuest"))
TabPvP:AddToggle(T("Auto Kill Player Quest", "AutoKillPlayerQuest", false, "KillPlayerQuest"))
TabPvP:AddButton(B("Player Hunter", "PlayerHunter", function() pcall(function() Invoke("PlayerHunter") end) end))

local shopBuys = {
	{"Buy Black Leg $150,000","Black Leg"},
	{"Buy Electro $550,000","Electro"},
	{"Buy Water Kung Fu $750,000","Fishman Karate"},
	{"Buy Superhuman $3,000,000","Superhuman"},
	{"Buy Death Step $5,000,000 5,000F","Death Step"},
	{"Buy Electric Claw $3,000,000 5,000F","Electric Claw"},
	{"Buy Dragon Talon $3,000,000 5,000F","Dragon Talon"},
	{"Buy God Human $5,000,000 5,000F","Godhuman"},
	{"Buy Sanguine Art $5,000,000 5,000F","Sanguine Art"},
	{"Buy Geppo $10,000","Geppo"},
	{"Buy Buso Haki $25,000","Buso"},
	{"Buy Soru $25,000","Soru"},
	{"Buy Observation Haki $750,000","Observation"},
	{"Buy Cutlass $1,000","Cutlass"},
	{"Buy Katana $1,000","Katana"},
	{"Buy Iron Mace $25,000","Iron Mace"},
	{"Buy Dual Katana $12,000","Dual Katana"},
	{"Buy Triple Katana $60,000","Triple Katana"},
	{"Buy Pipe $100,000","Pipe"},
	{"Buy Dual-Headed Blade $400,000","Dual-Headed Blade"},
	{"Buy Bisento $1,200,000","Bisento"},
	{"Buy Soul Cane $750,000","Soul Cane"},
	{"Buy Slingshot $5,000","Slingshot"},
	{"Buy Musket $8,000","Musket"},
	{"Buy Flintlock $10,500","Flintlock"},
	{"Refined Slingshot $30,000","Refined Slingshot"},
	{"Buy Refined Flintlock $65,000","Refined Flintlock"},
	{"Buy Cannon $100,000","Cannon"},
	{"Buy Black Cape $50,000","Black Cape"},
	{"Swordsman Hat $150,000","Swordsman Hat"},
	{"Buy Tomoe Ring $500,000","Tomoe Ring"},
}
for _, x in ipairs(shopBuys) do
	TabShop:AddButton(B(x[1], "BuyItem", function() BuyItem(x[2]) end))
end
TabShop:AddButton(B("Buy Dragon Claw 1,500F", "BuyItem", function() Invoke("BlackbeardReward","DragonClaw","1") Invoke("BlackbeardReward","DragonClaw","2") end))
TabShop:AddButton(B("Buy Sharkman Karate $2,500,000 5,000F", "BuyItem", function() pcall(function() Invoke("BuySharkmanKarate") end) BuyItem("Sharkman Karate") end))
TabShop:AddButton(B("Buy Pole V2 5,000F", "BuyItem", function() Invoke("ThunderGodTalk") end))
TabShop:AddButton(B("Buy Kabucha 1,500F", "BuyItem", function() Invoke("BlackbeardReward","Slingshot","1") Invoke("BlackbeardReward","Slingshot","2") end))
TabShop:AddButton(B("Buy Bizarre Rifle 250 Ectoplasm", "BuyItem", function() Invoke("Ectoplasm","Buy",1) end))
for _, c in ipairs({"Dragonheart","Dragonstorm","DinoHood","SharkTooth","TerrorJaw","SharkAnchor","LeviathanCrown","LeviathanShield","LeviathanBoat","LegendaryScroll","MythicalScroll"}) do
	TabShop:AddButton(B("Craft "..c, "CraftItem", function() CraftItem(c) end))
end
TabShop:AddButton(B("Buy Haki", "BuyItem", function() pcall(function() Invoke("BuyHaki") end) end))
TabShop:AddButton(B("Change Race Ghoul", "ChangeGhoul", function() pcall(function() Invoke("EvolvementProgress") end) end))
TabShop:AddButton(B("Change Race Cyborg", "ChangeCyborg", function() pcall(function() Invoke("CyborgTrainer") end) end))
TabShop:AddButton(B("Reset Stats 2,500F", "ResetStats", function() Invoke("BlackbeardReward","Refund","1") Invoke("BlackbeardReward","Refund","2") end))
TabShop:AddButton(B("Random Race 3,000F", "RandomRace", function() Invoke("BlackbeardReward","Reroll","1") Invoke("BlackbeardReward","Reroll","2") end))

TabSettings:AddParagraph({ Title = "Unban Fast Attack - M1 Fruit", Content = S("FastAttack") })
TabSettings:AddDropdown({
	Name = S("LangLabel"),
	Description = S("LangHint"),
	Options = {"English", "Tiếng Việt"},
	Default = CurrentLang == "vi" and "Tiếng Việt" or "English",
	Callback = function(v)
		if v == "Tiếng Việt" then
			PendingLang = "vi"
		else
			PendingLang = "en"
		end
	end,
})
TabSettings:AddButton({
	Name = S("LangSelect"),
	Description = S("LangHint"),
	Callback = function()
		pcall(function()
			if writefile then
				writefile(LANG_FILE, PendingLang)
			end
		end)
		CurrentLang = PendingLang
		pcall(function()
			if Window.Close then Window:Close() elseif Window.Toggle then Window:Toggle() end
		end)
		pcall(function()
			local g = CoreGui:FindFirstChild("ControlGUI")
			if g then g:Destroy() end
		end)
		task.defer(function()
			local src = rawget(getgenv(), "ZorcexHubSource")
			if type(src) == "string" and #src > 100 then
				loadstring(src)()
			else
				warn("[Zorcex Hub] Language saved. Execute the script again to apply UI language.")
			end
		end)
	end,
})

local settingsItems = {
	{"Set Home Point","CheckPoint",false,"HomePoint"},
	{"Infinite Soru","InfiniteSoru",false,"InfSoru"},
	{"Infinite Geppo","InfiniteGeppo",false,"InfGeppo"},
	{"Dodge No Cooldown","DodgeNoCD",false,"DodgeNoCD"},
	{"Walk on Water","WalkWater",true,"WalkWater"},
	{"Melee","AutoStatsMelee",false,"StatMelee"},
	{"Defense","AutoStatsDefense",false,"StatDef"},
	{"Sword","AutoStatsSword",false,"StatSword"},
	{"Gun","AutoStatsGun",false,"StatGun"},
	{"Fruit","AutoStatsFruit",false,"StatFruit"},
	{"Buso Haki","AutoHaki",false,"Buso"},
	{"Delete Lava","DeleteLava",false,"DeleteLava"},
	{"Body Clip","BodyClip",false,"BodyClip"},
}
for _, x in ipairs(settingsItems) do
	TabSettings:AddToggle(T(x[1], x[2], x[3], x[4]))
end
TabSettings:AddButton(B("Join Pirates Team", "Pirates", function() Invoke("SetTeam","Pirates") end))
TabSettings:AddButton(B("Join Marines Team", "Marines", function() Invoke("SetTeam","Marines") end))
TabSettings:AddButton(B("Open Title Name", "OpenTitle", function() pcall(function() LocalPlayer.PlayerGui.Main.Titles.Visible = true end) end))
TabSettings:AddButton(B("FPS Boost", "FPSBoost", function()
	pcall(function()
		settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
		for _, obj in ipairs(game:GetDescendants()) do
			if obj:IsA("BasePart") then obj.Material = Enum.Material.Plastic obj.Reflectance = 0
			elseif obj:IsA("Decal") or obj:IsA("Texture") then obj.Transparency = 1
			elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Fire") or obj:IsA("Smoke") then obj.Enabled = false end
		end
	end)
end))
TabSettings:AddButton(B("Codes", "Codes", function()
	for _, code in ipairs({"LIGHTNINGABUSE","SUB2GAMERROBOT_RESET1","SUB2GAMERROBOT_EXP1","EASTEREXP","1LOSTADMIN","KITT_RESET","SUB2CAPTAINMAUI","SUB2UNCLEKIZARU","SUB2OFFICIALNOOBIE","SUB2NOOBMASTER123","SUB2DAIGROCK","STRAWHATMAINE","TANTAIGAMING","THEGREATACE","KITTGAMING","Sub2Fer999","Enyu_is_Pro","Magicbus","JCWK","Starcodeheo","Bluxxy","Axiore","Bignews","CHANDLER","FUDD10_V2","FUDD10"}) do
		pcall(function() Remotes.Redeem:InvokeServer(code) end)
		task.wait(0.3)
	end
end))
TabSettings:AddButton(B("Rejoin Server", "Rejoin", function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end))
TabSettings:AddButton(B("Server Hop", "ServerHop", function() Hop() end))
TabSettings:AddParagraph({ Title = "Info", Content = S("Info") })

pcall(function() if RedzLib.Init then RedzLib:Init() end end)
