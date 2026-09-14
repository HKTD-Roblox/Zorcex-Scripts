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


local function T(name, flag, default, desc)
	return {
		Name = name,
		Description = desc or "",
		Default = default or false,
		Callback = function(v)
			_G[flag] = v
		end,
	}
end

local function B(name, desc, callback)
	return {
		Name = name,
		Description = desc or "",
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
TabFarm:AddDropdown({
	Name = "Select Weapon",
	Description = "Chọn vũ khí để farm",
	Options = {"Melee","Sword","Gun","Blox Fruit"},
	Default = _G.SelectWeapon,
	Callback = function(v) _G.SelectWeapon = v end,
})
TabFarm:AddToggle(T("Auto Farm Level", "AutoFarm", false, "Tự động farm level theo quest"))
TabFarm:AddToggle(T("Farm Level New", "FarmLevelNew", false, "Chế độ farm level mới"))
TabFarm:AddToggle(T("Auto Kill Near | Mob Aura", "AutoKillNear", false, "Tự động đánh quái ở gần"))
TabFarm:AddToggle(T("Auto Select Boss", "AutoSelectBoss", false, "Tự động chọn boss"))
TabFarm:AddToggle(T("Auto Farm Boss", "AutoFarmBoss", false, "Tự động farm boss"))
TabFarm:AddToggle(T("Farm Pirate", "FarmPirate", false, "Farm khu vực Pirate"))
TabFarm:AddToggle(T("Farm Boss", "FarmBoss", false, "Farm boss đã chọn"))
TabFarm:AddButton(B("Update Boss", "Cập nhật danh sách boss", function() _G.UpdateBossList = true end))
TabFarm:AddParagraph({ Title = "Boss Spawn Status", Content = "Trạng thái boss xuất hiện in-game" })
TabFarm:AddToggle(T("Check Eyes Status", "CheckEyes", false, "Kiểm tra trạng thái Eyes"))
TabFarm:AddToggle(T("Auto Farm Tyrant", "AutoFarmTyrant", false, "Tự động farm Tyrant"))
TabFarm:AddButton(B("Summon Tyrant Of The Skies", "Triệu hồi Tyrant Of The Skies", function() _G.SummonTyrant = true end))
TabFarm:AddToggle(T("Check Bone", "CheckBone", false, "Kiểm tra số Bone"))
TabFarm:AddToggle(T("Farm Bone", "FarmBone", false, "Tự động farm Bone"))
TabFarm:AddToggle(T("Separator Hallow Scythe", "HallowScythe", false, "Xử lý Hallow Scythe"))
TabFarm:AddToggle(T("Trade Bone", "TradeBone", false, "Đổi Bone"))
TabFarm:AddToggle(T("Auto Pray", "AutoPray", false, "Tự động Pray"))
TabFarm:AddToggle(T("Auto Try Luck", "AutoTryLuck", false, "Tự động Try Luck"))
TabFarm:AddToggle(T("Check Cake Prince", "CheckCakePrince", false, "Kiểm tra Cake Prince"))
TabFarm:AddToggle(T("Farm Katakuri", "FarmKatakuri", false, "Farm Katakuri / Cake Prince"))
TabFarm:AddToggle(T("Farm Katakuri V2", "FarmKatakuriV2", false, "Farm Katakuri phiên bản 2"))
TabFarm:AddToggle(T("Auto Collect Berry", "AutoCollectBerry", false, "Tự động nhặt Berry"))
TabFarm:AddToggle(T("Auto Farm Chest [ Tween ]", "AutoFarmChest", false, "Tự động farm rương (tween)"))
TabFarm:AddDropdown({
	Name = "Select Material",
	Description = "Chọn vật liệu để farm",
	Options = {"Angel Wings","Mystic Droplet","Vampire Fang","Gunpowder","Conjured Cocoa","Mini Tusk","Fish Tail","Magma Ore","Leather + Scrap Metal","Radiactive Material"},
	Default = _G.SelectMaterial,
	Callback = function(v) _G.SelectMaterial = v MaterialMon() end,
})
TabFarm:AddToggle({
	Name = "Start Farm",
	Description = "Bật farm material đã chọn",
	Default = false,
	Callback = function(v) _G.StartMaterialFarm = v if v then MaterialMon() end end,
})
TabFarm:AddToggle(T("Bring Mod", "BringMonster", true, "Tự động gom quái về gần bạn"))

TabFish:AddToggle(T("Auto Fishing", "AutoFishing", false, "Tự động câu cá"))
TabFish:AddDropdown({
	Name = "Select Fishing Lure",
	Description = "Chọn mồi câu",
	Options = {"Default","Lure1","Lure2","Lure3"},
	Default = "Default",
	Callback = function(v) _G.SelectLure = v pcall(function() Invoke("SelectBait", v) end) end,
})
TabFish:AddDropdown({
	Name = "Select Fishing Rod",
	Description = "Chọn cần câu",
	Options = {"Default","Rod1","Rod2","Rod3"},
	Default = "Default",
	Callback = function(v) _G.SelectRod = v end,
})

local questItems = {
	{"AutoSecondSea","AutoSecondSea","Tự động mở Sea 2"},
	{"Auto Quest Sea 3","AutoThirdSea","Tự động quest Sea 3"},
	{"Auto Quest Sea Bartilo","AutoBartilo","Tự động quest Bartilo"},
	{"Kill Greybeard","KillGreybeard","Tiêu diệt Greybeard"},
	{"Auto Get Saber","AutoGetSaber","Tự động nhận Saber"},
	{"Auto Get Sword Pole","AutoGetPole","Tự động nhận Pole"},
	{"Auto Get Sword Saw","AutoGetSaw","Tự động nhận Saw"},
	{"Auto Get Sword Wardens","AutoGetWardens","Tự động nhận Wardens"},
	{"Auto Get Sword Trident","AutoGetTrident","Tự động nhận Trident"},
	{"Auto Factory","AutoFactory","Tự động Factory"},
	{"Auto Kill Dark Beard","KillDarkbeard","Tiêu diệt Dark Beard"},
	{"Auto Kill Cursed Captain","KillCursedCaptain","Tiêu diệt Cursed Captain"},
	{"Auto Buy Haki Colors","AutoBuyHakiColors","Tự động mua màu Haki"},
	{"Auto Buy Legendary Sword","AutoBuyLegendarySword","Tự động mua Legendary Sword"},
	{"Auto Get Longsword","AutoGetLongsword","Tự động nhận Longsword"},
	{"Auto Get Sword Gravity Blade","AutoGetGravityBlade","Tự động nhận Gravity Blade"},
	{"Auto Get Sword Flail","AutoGetFlail","Tự động nhận Flail"},
	{"Auto Get Sword Rengoku","AutoGetRengoku","Tự động nhận Rengoku"},
	{"Auto Get Sword Dragon Trident","AutoGetDragonTrident","Tự động nhận Dragon Trident"},
	{"Auto Kill Rip Indra","KillRipIndra","Tiêu diệt Rip Indra"},
	{"Auto Haki Colors","AutoHakiColors","Tự động Haki Colors"},
	{"Auto Skull Guitar","AutoSkullGuitar","Tự động Skull Guitar"},
	{"Kill Elite Hunter","KillEliteHunter","Tiêu diệt Elite Hunter"},
	{"Auto Cdk [Beta]","AutoCDK","Tự động CDK (Beta)"},
	{"Auto Get Yama","AutoGetYama","Tự động nhận Yama"},
	{"Auto Holy Torch Tushita","AutoHolyTorch","Tự động Holy Torch Tushita"},
	{"Auto Get Tushita","AutoGetTushita","Tự động nhận Tushita"},
	{"Auto Get Sword Twin Hooks","AutoGetTwinHooks","Tự động nhận Twin Hooks"},
	{"Auto Get Sword Canvander","AutoGetCanvander","Tự động nhận Canvander"},
	{"Auto Get Sword Buddy","AutoGetBuddy","Tự động nhận Buddy Sword"},
}
for _, x in ipairs(questItems) do
	TabQuest:AddToggle(T(x[1], x[2], false, x[3]))
end
TabQuest:AddButton(B("soulGuitarBuy", "Mua Skull Guitar", function() pcall(function() Invoke("soulGuitarBuy") end) end))
TabQuest:AddButton(B("CDK Quest Progress", "Tiến trình quest CDK", function() pcall(function() Invoke("CDKQuest") end) end))
TabQuest:AddButton(B("Elite Hunter", "Nhận / tiến trình Elite Hunter", function() pcall(function() Invoke("EliteHunter") end) end))
TabQuest:AddButton(B("Bartilo Quest Progress", "Tiến trình quest Bartilo", function() pcall(function() Invoke("BartiloQuestProgress") end) end))
TabQuest:AddButton(B("Abandon Quest", "Hủy quest hiện tại", function() pcall(function() Invoke("AbandonQuest") end) end))

TabDojo:AddButton(B("Tween Dragon Dojo", "Dịch chuyển tới Dragon Dojo", function() _G.TweenDragonDojo = true end))
TabDojo:AddToggle(T("Auto Dragon Hunter", "AutoDragonHunter", false, "Tự động Dragon Hunter"))
TabDojo:AddButton(B("Craft Volcanic Magnet", "Chế tạo Volcanic Magnet", function() CraftItem("Volcanic Magnet") end))

local seaItems = {
	{"Check Prehistoric Island","CheckPrehistoric","Kiểm tra Prehistoric Island"},
	{"Auto Find Prehistoric","FindPrehistoric","Tự động tìm Prehistoric"},
	{"Auto Tween Prehistoric Island","TweenPrehistoric","Tween tới Prehistoric Island"},
	{"Auto Defend Prehistoric","DefendPrehistoric","Tự động phòng thủ Prehistoric"},
	{"Auto Use Melee","AutoUseMelee","Tự động dùng Melee"},
	{"Auto Use Sword","AutoUseSword","Tự động dùng Sword"},
	{"Auto Use Gun","AutoUseGun","Tự động dùng Gun"},
	{"Auto Kill Golem","KillGolem","Tiêu diệt Golem"},
	{"Auto Kill Aura Golem","KillAuraGolem","Tiêu diệt Aura Golem"},
	{"Auto Collect Bone","CollectBone","Tự động nhặt Bone"},
	{"Auto Collect Egg","CollectEgg","Tự động nhặt Egg"},
	{"Check Kitsune Island","CheckKitsune","Kiểm tra Kitsune Island"},
	{"Auto Tween Kitsune Island","TweenKitsune","Tween tới Kitsune Island"},
	{"Esp Kitsune Island","EspKitsune","Hiện ESP Kitsune Island"},
	{"Auto Azure Ember","AutoAzureEmber","Tự động Azure Ember"},
	{"Auto Drive Boats","AutoDriveBoats","Tự động lái thuyền"},
	{"Auto Kill Terror Shark","KillTerrorShark","Tiêu diệt Terror Shark"},
	{"Auto Kill Shark","KillShark","Tiêu diệt Shark"},
	{"Auto Kill Piranha","KillPiranha","Tiêu diệt Piranha"},
	{"Auto Kill Fish Crew Member","KillFishCrew","Tiêu diệt Fish Crew Member"},
	{"Check Mirage Island","CheckMirage","Kiểm tra Mirage Island"},
	{"Tween Mirage Island","TweenMirage","Tween tới Mirage Island"},
	{"Esp Mirage Island","EspMirage","Hiện ESP Mirage Island"},
	{"Look Moon + Auto V3","LookMoon","Nhìn Moon và bật Race V3"},
	{"Auto Tween To Gear","TweenGear","Tween tới Gear"},
}
for _, x in ipairs(seaItems) do
	TabSea:AddToggle(T(x[1], x[2], false, x[3]))
end
TabSea:AddButton(B("Buy Boat", "Mua thuyền", function() pcall(function() Invoke("BuyBoat") end) end))
TabSea:AddButton(B("Gravestone Event", "Sự kiện Gravestone", function() pcall(function() Invoke("gravestoneEvent") end) end))
TabSea:AddButton(B("Cake Prince Spawner", "Spawn Cake Prince", function() pcall(function() Invoke("CakePrinceSpawner") end) end))

TabRace:AddButton(B("Teleport To Top Great Tree", "Dịch chuyển lên đỉnh Great Tree", function() topos(CFrame.new(2948,2288,-7215)) end))
TabRace:AddButton(B("Teleport Temple Of Time", "Dịch chuyển tới Temple Of Time", function() topos(CFrame.new(28286.35546875,14895.3017578125,102.50769424438477)) end))
TabRace:AddButton(B("Teleport Lever Pull", "Dịch chuyển tới lever", function() _G.TeleportLever = true end))
TabRace:AddButton(B("Teleport To The Clock", "Dịch chuyển tới đồng hồ", function() _G.TeleportClock = true end))
TabRace:AddToggle(T("Auto Race Door", "AutoRaceDoor", false, "Tự động mở cửa Race"))
TabRace:AddButton(B("Buy Ancient One Quest", "Mua quest Ancient One", function() pcall(function() Invoke("ProQuestProgress","AncientOne") end) end))
TabRace:AddToggle(T("Auto Trial Human Ghost", "AutoTrial", false, "Tự động trial Human / Ghost"))
TabRace:AddToggle(T("Auto Trial All Race", "AutoTrialAllRace", false, "Tự động trial tất cả Race"))
TabRace:AddToggle(T("Auto Kill Player Trial V4", "AutoKillTrialPlayer", false, "Tự động hạ player trong Trial V4"))
TabRace:AddToggle(T("Auto Active Race V3", "AutoRaceV3", false, "Tự động bật Race V3"))
TabRace:AddToggle(T("Auto Active Race V4", "AutoRaceV4", false, "Tự động bật Race V4"))
TabRace:AddButton(B("Upgrade Race", "Nâng Race", function() pcall(function() Invoke("UpgradeRace") end) end))

TabRaid:AddDropdown({
	Name = "Select Chip",
	Description = "Chọn chip Raid",
	Options = {"Flame","Ice","Quake","Light","Dark","Spider","Rumble","Magma","Buddha","Sand","Phoenix","Dough"},
	Default = _G.SelectChip,
	Callback = function(v) _G.SelectChip = v end,
})
local raidItems = {
	{"Auto Buy Chip","AutoBuyChip","Tự động mua chip"},
	{"Auto Start Raid","AutoStartRaid","Tự động bắt đầu Raid"},
	{"Auto Farm Raid Next Island","AutoFarmRaid","Tự động farm đảo tiếp theo trong Raid"},
	{"Auto Get Fruit Low Beli","AutoGetFruitLowBeli","Tự động lấy fruit giá thấp"},
	{"Auto Buy Chip Law","AutoBuyLawChip","Tự động mua chip Law"},
	{"Auto Start Raid Law","AutoStartLawRaid","Tự động bắt đầu Law Raid"},
	{"Auto Farm Law Raid","AutoFarmLawRaid","Tự động farm Law Raid"},
	{"Auto Skill Z","AutoSkillZ","Tự động dùng skill Z"},
	{"Auto Skill X","AutoSkillX","Tự động dùng skill X"},
	{"Auto Skill C","AutoSkillC","Tự động dùng skill C"},
}
for _, x in ipairs(raidItems) do
	TabRaid:AddToggle(T(x[1], x[2], false, x[3]))
end

TabFruit:AddToggle(T("Auto Random Fruits", "AutoRandomFruits", false, "Tự động Random fruit"))
TabFruit:AddToggle(T("Auto Store Fruits", "AutoStoreFruits", false, "Tự động cất fruit vào kho"))
TabFruit:AddButton(B("Teleport To Fruit Spawn", "Dịch chuyển tới fruit đang spawn", function()
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
TabFruit:AddButton(B("Store Fruit Now", "Cất fruit ngay", function() pcall(function() Invoke("StoreFruit") end) end))
TabFruit:AddButton(B("Fruit Stock", "Xem kho fruit", function() pcall(function() print(Invoke("getInventory")) end) end))
TabFruit:AddToggle(T("Esp Fruits", "EspFruits", false, "Hiện ESP fruit"))
TabFruit:AddToggle(T("Esp Berry", "EspBerry", false, "Hiện ESP Berry"))

TabTP:AddButton(B("Join Sea 1", "Dịch chuyển Sea 1", function() Invoke("TravelMain") end))
TabTP:AddButton(B("Join Sea 2", "Dịch chuyển Sea 2", function() Invoke("TravelDressrosa") end))
TabTP:AddButton(B("Join Sea 3", "Dịch chuyển Sea 3", function() Invoke("TravelZou") end))
TabTP:AddButton(B("Request Entrance", "Yêu cầu vào khu vực (entrance)", function() pcall(function() Invoke("requestEntrance") end) end))

TabPvP:AddToggle(T("Esp Players", "EspPlayers", false, "Hiện ESP người chơi"))
TabPvP:AddToggle(T("Esp Chest", "EspChest", false, "Hiện ESP rương"))
TabPvP:AddToggle(T("Speed Boost", "SpeedHack", false, "Tăng tốc chạy"))
TabPvP:AddToggle(T("Jump Boost", "JumpHack", false, "Nhảy cao"))
TabPvP:AddToggle(T("Get Quest Elite Players", "ElitePlayerQuest", false, "Nhận quest Elite Player"))
TabPvP:AddToggle(T("Auto Kill Player Quest", "AutoKillPlayerQuest", false, "Tự động hạ player theo quest"))
TabPvP:AddButton(B("Player Hunter", "Bắt đầu Player Hunter", function() pcall(function() Invoke("PlayerHunter") end) end))

local shopBuys = {
	{"Buy Black Leg $150,000","Black Leg","Mua Black Leg"},
	{"Buy Electro $550,000","Electro","Mua Electro"},
	{"Buy Water Kung Fu $750,000","Fishman Karate","Mua Fishman Karate"},
	{"Buy Superhuman $3,000,000","Superhuman","Mua Superhuman"},
	{"Buy Death Step $5,000,000 5,000F","Death Step","Mua Death Step"},
	{"Buy Electric Claw $3,000,000 5,000F","Electric Claw","Mua Electric Claw"},
	{"Buy Dragon Talon $3,000,000 5,000F","Dragon Talon","Mua Dragon Talon"},
	{"Buy God Human $5,000,000 5,000F","Godhuman","Mua Godhuman"},
	{"Buy Sanguine Art $5,000,000 5,000F","Sanguine Art","Mua Sanguine Art"},
	{"Buy Geppo $10,000","Geppo","Mua Geppo"},
	{"Buy Buso Haki $25,000","Buso","Mua Buso Haki"},
	{"Buy Soru $25,000","Soru","Mua Soru"},
	{"Buy Observation Haki $750,000","Observation","Mua Observation Haki"},
	{"Buy Cutlass $1,000","Cutlass","Mua Cutlass"},
	{"Buy Katana $1,000","Katana","Mua Katana"},
	{"Buy Iron Mace $25,000","Iron Mace","Mua Iron Mace"},
	{"Buy Dual Katana $12,000","Dual Katana","Mua Dual Katana"},
	{"Buy Triple Katana $60,000","Triple Katana","Mua Triple Katana"},
	{"Buy Pipe $100,000","Pipe","Mua Pipe"},
	{"Buy Dual-Headed Blade $400,000","Dual-Headed Blade","Mua Dual-Headed Blade"},
	{"Buy Bisento $1,200,000","Bisento","Mua Bisento"},
	{"Buy Soul Cane $750,000","Soul Cane","Mua Soul Cane"},
	{"Buy Slingshot $5,000","Slingshot","Mua Slingshot"},
	{"Buy Musket $8,000","Musket","Mua Musket"},
	{"Buy Flintlock $10,500","Flintlock","Mua Flintlock"},
	{"Refined Slingshot $30,000","Refined Slingshot","Mua Refined Slingshot"},
	{"Buy Refined Flintlock $65,000","Refined Flintlock","Mua Refined Flintlock"},
	{"Buy Cannon $100,000","Cannon","Mua Cannon"},
	{"Buy Black Cape $50,000","Black Cape","Mua Black Cape"},
	{"Swordsman Hat $150,000","Swordsman Hat","Mua Swordsman Hat"},
	{"Buy Tomoe Ring $500,000","Tomoe Ring","Mua Tomoe Ring"},
}
for _, x in ipairs(shopBuys) do
	local title, item, desc = x[1], x[2], x[3]
	TabShop:AddButton(B(title, desc, function() BuyItem(item) end))
end
TabShop:AddButton(B("Buy Dragon Claw 1,500F", "Mua Dragon Claw (Fragment)", function() Invoke("BlackbeardReward","DragonClaw","1") Invoke("BlackbeardReward","DragonClaw","2") end))
TabShop:AddButton(B("Buy Sharkman Karate $2,500,000 5,000F", "Mua Sharkman Karate", function() pcall(function() Invoke("BuySharkmanKarate") end) BuyItem("Sharkman Karate") end))
TabShop:AddButton(B("Buy Pole V2 5,000F", "Mua Pole V2 (Fragment)", function() Invoke("ThunderGodTalk") end))
TabShop:AddButton(B("Buy Kabucha 1,500F", "Mua Kabucha (Fragment)", function() Invoke("BlackbeardReward","Slingshot","1") Invoke("BlackbeardReward","Slingshot","2") end))
TabShop:AddButton(B("Buy Bizarre Rifle 250 Ectoplasm", "Mua Bizarre Rifle bằng Ectoplasm", function() Invoke("Ectoplasm","Buy",1) end))
for _, c in ipairs({"Dragonheart","Dragonstorm","DinoHood","SharkTooth","TerrorJaw","SharkAnchor","LeviathanCrown","LeviathanShield","LeviathanBoat","LegendaryScroll","MythicalScroll"}) do
	TabShop:AddButton(B("Craft "..c, "Chế tạo "..c, function() CraftItem(c) end))
end
TabShop:AddButton(B("Buy Haki", "Mua Haki", function() pcall(function() Invoke("BuyHaki") end) end))
TabShop:AddButton(B("Change Race Ghoul", "Đổi tộc thành Ghoul", function() pcall(function() Invoke("EvolvementProgress") end) end))
TabShop:AddButton(B("Change Race Cyborg", "Đổi tộc thành Cyborg", function() pcall(function() Invoke("CyborgTrainer") end) end))
TabShop:AddButton(B("Reset Stats 2,500F", "Reset chỉ số (Fragment)", function() Invoke("BlackbeardReward","Refund","1") Invoke("BlackbeardReward","Refund","2") end))
TabShop:AddButton(B("Random Race 3,000F", "Random tộc (Fragment)", function() Invoke("BlackbeardReward","Reroll","1") Invoke("BlackbeardReward","Reroll","2") end))

TabSettings:AddParagraph({ Title = "Unban Fast Attack - M1 Fruit", Content = "Cần load thêm bên ngoài nếu cần" })
local settingsItems = {
	{"Set Home Point","CheckPoint",false,"Lưu điểm hồi sinh"},
	{"Infinite Soru","InfiniteSoru",false,"Soru không giới hạn"},
	{"Infinite Geppo","InfiniteGeppo",false,"Geppo không giới hạn"},
	{"Dodge No Cooldown","DodgeNoCD",false,"Né tránh không thời gian hồi chiêu"},
	{"Walk on Water","WalkWater",true,"Đi bộ trên mặt nước"},
	{"Melee","AutoStatsMelee",false,"Tự động cộng điểm Melee"},
	{"Defense","AutoStatsDefense",false,"Tự động cộng điểm Defense"},
	{"Sword","AutoStatsSword",false,"Tự động cộng điểm Sword"},
	{"Gun","AutoStatsGun",false,"Tự động cộng điểm Gun"},
	{"Fruit","AutoStatsFruit",false,"Tự động cộng điểm Fruit"},
	{"Buso Haki","AutoHaki",false,"Tự động bật Buso Haki"},
	{"Delete Lava","DeleteLava",false,"Xóa dung nham"},
	{"Body Clip","BodyClip",false,"Xuyên vật thể (body clip)"},
}
for _, x in ipairs(settingsItems) do
	TabSettings:AddToggle(T(x[1], x[2], x[3], x[4]))
end
TabSettings:AddButton(B("Join Pirates Team", "Vào phe Pirates", function() Invoke("SetTeam","Pirates") end))
TabSettings:AddButton(B("Join Marines Team", "Vào phe Marines", function() Invoke("SetTeam","Marines") end))
TabSettings:AddButton(B("Open Title Name", "Mở menu Title", function() pcall(function() LocalPlayer.PlayerGui.Main.Titles.Visible = true end) end))
TabSettings:AddButton(B("FPS Boost", "Tăng FPS, giảm đồ họa", function()
	pcall(function()
		settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
		for _, obj in ipairs(game:GetDescendants()) do
			if obj:IsA("BasePart") then obj.Material = Enum.Material.Plastic obj.Reflectance = 0
			elseif obj:IsA("Decal") or obj:IsA("Texture") then obj.Transparency = 1
			elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Fire") or obj:IsA("Smoke") then obj.Enabled = false end
		end
	end)
end))
TabSettings:AddButton(B("Codes", "Nhập toàn bộ code", function()
	for _, code in ipairs({"LIGHTNINGABUSE","SUB2GAMERROBOT_RESET1","SUB2GAMERROBOT_EXP1","EASTEREXP","1LOSTADMIN","KITT_RESET","SUB2CAPTAINMAUI","SUB2UNCLEKIZARU","SUB2OFFICIALNOOBIE","SUB2NOOBMASTER123","SUB2DAIGROCK","STRAWHATMAINE","TANTAIGAMING","THEGREATACE","KITTGAMING","Sub2Fer999","Enyu_is_Pro","Magicbus","JCWK","Starcodeheo","Bluxxy","Axiore","Bignews","CHANDLER","FUDD10_V2","FUDD10"}) do
		pcall(function() Remotes.Redeem:InvokeServer(code) end)
		task.wait(0.3)
	end
end))
TabSettings:AddButton(B("Rejoin Server", "Vào lại server hiện tại", function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end))
TabSettings:AddButton(B("Server Hop", "Chuyển sang server khác", function() Hop() end))
TabSettings:AddParagraph({ Title = "Info", Content = "UI restored from dump. Farm engines are flags only." })

pcall(function() if RedzLib.Init then RedzLib:Init() end end)
