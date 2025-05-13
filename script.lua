-- Blox Fruits Advanced Script - Retro Hub Style
-- Licenciado - Versão 2.0

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")

-- Configurações globais
local Settings = {
    AutoFarm = false,
    LevelFarm = false,
    AutoQuest = false,
    BringMob = false,
    AutoLegendarySword = false,
    AutoBuyHakiColor = false,
    AutoHaki = false,
    ObservationHaki = false,
    SelectedWeapon = "",
    SelectedPlace = "",
    SelectedPlayer = "",
    MasteryFarm = false,
    HealthPercent = 100,
    Skills = {Z = true, X = true, C = true, V = true},
    NoClip = false,
    SuperSpeed = false,
    SpeedValue = 50,
    Aimbot = false,
    IncreasedDamage = false,
    InfiniteDefense = false,
    PlayerESP = false,
    ItemESP = false,
    BossESP = false,
    FruitESP = false,
    SelectedSea = "First Sea"
}

-- Dados do jogo
local Weapons = {"Melee", "Sword", "Gun", "Blox Fruit"}
local Places = {
    ["First Sea"] = {
        "Middle Island", "Jungle Island", "Pirate Village", "Desert Island", 
        "Snow Island", "Marine Fortress", "Sky Island 1", "Sky Island 2", 
        "Prison", "Colosseum", "Magma Village", "Underwater City", 
        "Fountain City", "Fishman Island", "Sky Island 3"
    },
    ["Second Sea"] = {
        "Kingdom of Rose", "Cafe", "Mansion", "Snow Mountain", 
        "Hot and Cold", "Glacier", "Usoap's Island", "Green Zone", 
        "Graveyard Island", "Dark Arena"
    },
    ["Third Sea"] = {
        "Port Town", "Hydra Island", "Great Tree", "Castle on the Sea", 
        "Haunted Castle", "Floating Turtle", "Ice Castle", "Cursed Ship"
    }
}

local Bosses = {
    ["First Sea"] = {"The Gorilla King", "Bobby", "Yeti", "Mob Leader", "Vice Admiral", "Warden", "Chief Warden", "Swan"},
    ["Second Sea"] = {"Diamond", "Jeremy", "Fajita", "Don Swan", "Smoke Admiral", "Cursed Captain"},
    ["Third Sea"] = {"Order", "Soul Reaper", "Dough King", "Cake Queen"}
}

-- Criação da interface
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Retro Hub", "DarkTheme")

-- Adicionar créditos
local HomeTab = Window:NewTab("Home")
local HomeSection = HomeTab:NewSection("Provided By:")
HomeSection:NewLabel("Retro Software")
HomeSection:NewLabel("Credits:")
HomeSection:NewLabel("Alan.#9235")
HomeSection:NewLabel("Spectrum#9959")
HomeSection:NewLabel("JR1.#847")

-- Aba Principal
local MainTab = Window:NewTab("Main")
local FarmingSection = MainTab:NewSection("Farming")
local HakiSection = MainTab:NewSection("Haki")
local WeaponSection = MainTab:NewSection("Weapon")

-- Aba Teleports
local TeleportTab = Window:NewTab("Teleports")
local PlacesSection = TeleportTab:NewSection("Places")
local PlayersSection = TeleportTab:NewSection("Players")

-- Aba Misc
local MiscTab = Window:NewTab("Misc")
local StatsSection = MiscTab:NewSection("Stats")
local ESPSection = MiscTab:NewSection("ESP")
local CombatSection = MiscTab:NewSection("Combat")

-- Aba Settings
local SettingsTab = Window:NewTab("Settings")
local FarmSettingsSection = SettingsTab:NewSection("Mastery Farm")
local SkillSettingsSection = SettingsTab:NewSection("Skills")
local OtherSettingsSection = SettingsTab:NewSection("Other")

-- Funções utilitárias
function GetClosestEnemy()
    local closest = nil
    local dist = math.huge
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local enemyRoot = player.Character.HumanoidRootPart
            local mag = (root.Position - enemyRoot.Position).Magnitude
            if mag < dist then
                closest = player.Character
                dist = mag
            end
        end
    end
    
    return closest
end

function TeleportTo(target)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = target.CFrame + Vector3.new(0, 3, 0)
    end
end

function AttackEnemy()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        local humanoid = char.Humanoid
        humanoid:EquipTool(char:FindFirstChildOfClass("Tool"))
        mouse1click()
    end
end

-- Configuração da interface
FarmingSection:NewToggle("Farming", "Auto farm de inimigos", function(state)
    Settings.AutoFarm = state
    if state then
        spawn(function()
            while Settings.AutoFarm do
                local enemy = GetClosestEnemy()
                if enemy then
                    TeleportTo(enemy.HumanoidRootPart)
                    AttackEnemy()
                end
                wait(0.1)
            end
        end)
    end
end)

FarmingSection:NewToggle("Level Farm", "Farm automático de níveis", function(state)
    Settings.LevelFarm = state
end)

FarmingSection:NewToggle("Auto Quest", "Pega missões automaticamente", function(state)
    Settings.AutoQuest = state
end)

FarmingSection:NewToggle("Bring Mob", "Atrai os mobs para você", function(state)
    Settings.BringMob = state
end)

FarmingSection:NewToggle("Auto Legendary Sword", "Farma espadas lendárias", function(state)
    Settings.AutoLegendarySword = state
end)

HakiSection:NewToggle("Auto Buy Haki Color", "Compra cores de Haki automaticamente", function(state)
    Settings.AutoBuyHakiColor = state
end)

HakiSection:NewToggle("Auto Haki", "Ativa Haki automaticamente", function(state)
    Settings.AutoHaki = state
end)

HakiSection:NewToggle("Observation Haki", "Ativa Ken Haki automaticamente", function(state)
    Settings.ObservationHaki = state
end)

WeaponSection:NewDropdown("Select Weapon", "Selecione sua arma", Weapons, function(selected)
    Settings.SelectedWeapon = selected
end)

WeaponSection:NewButton("Refresh Weapons", "Atualiza lista de armas", function()
    -- Implementação para atualizar armas
end)

PlacesSection:NewDropdown("Sea", "Selecione o mar", {"First Sea", "Second Sea", "Third Sea"}, function(selected)
    Settings.SelectedSea = selected
end)

PlacesSection:NewDropdown("Places", "Selecione o lugar", Places[Settings.SelectedSea], function(selected)
    Settings.SelectedPlace = selected
end)

PlacesSection:NewButton("Teleport", "Teleporta para o lugar selecionado", function()
    -- Implementação do teleporte
end)

PlayersSection:NewDropdown("Players", "Selecione um jogador", Players:GetPlayers(), function(selected)
    Settings.SelectedPlayer = selected
end)

PlayersSection:NewButton("Teleport to Player", "Teleporta para o jogador", function()
    -- Implementação do teleporte para jogador
end)

StatsSection:NewToggle("Defense", "Defesa infinita", function(state)
    Settings.InfiniteDefense = state
    if state then
        LocalPlayer.Character.Humanoid.MaxHealth = math.huge
        LocalPlayer.Character.Humanoid.Health = math.huge
    end
end)

StatsSection:NewToggle("Sword", "Melhora espadas", function(state)
    -- Implementação de melhoria de espadas
end)

StatsSection:NewToggle("Gun", "Melhora armas", function(state)
    -- Implementação de melhoria de armas
end)

StatsSection:NewToggle("Blox Fruit", "Melhora frutas", function(state)
    -- Implementação de melhoria de frutas
end)

ESPSection:NewToggle("Player ESP", "Mostra jogadores", function(state)
    Settings.PlayerESP = state
end)

ESPSection:NewToggle("Boss ESP", "Mostra bosses", function(state)
    Settings.BossESP = state
end)

ESPSection:NewToggle("Fruit ESP", "Mostra frutas", function(state)
    Settings.FruitESP = state
end)

CombatSection:NewToggle("Aimbot", "Mira automática", function(state)
    Settings.Aimbot = state
end)

CombatSection:NewToggle("Increased Damage", "Dano aumentado", function(state)
    Settings.IncreasedDamage = state
end)

FarmSettingsSection:NewToggle("Mastery Farm", "Farm de maestria", function(state)
    Settings.MasteryFarm = state
end)

FarmSettingsSection:NewSlider("Health %", "Porcentagem de vida", 100, 1, function(value)
    Settings.HealthPercent = value
end)

SkillSettingsSection:NewToggle("Z Skill", "Usa habilidade Z", function(state)
    Settings.Skills.Z = state
end)

SkillSettingsSection:NewToggle("X Skill", "Usa habilidade X", function(state)
    Settings.Skills.X = state
end)

SkillSettingsSection:NewToggle("C Skill", "Usa habilidade C", function(state)
    Settings.Skills.C = state
end)

SkillSettingsSection:NewToggle("V Skill", "Usa habilidade V", function(state)
    Settings.Skills.V = state
end)

OtherSettingsSection:NewToggle("NoClip", "Atravessar paredes", function(state)
    Settings.NoClip = state
    if state then
        spawn(function()
            while Settings.NoClip do
                if LocalPlayer.Character then
                    for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
                wait()
            end
        end)
    end
end)

OtherSettingsSection:NewToggle("Super Speed", "Velocidade aumentada", function(state)
    Settings.SuperSpeed = state
    if state then
        LocalPlayer.Character.Humanoid.WalkSpeed = Settings.SpeedValue
    else
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)

OtherSettingsSection:NewSlider("Speed Value", "Valor da velocidade", 100, 16, function(value)
    Settings.SpeedValue = value
    if Settings.SuperSpeed then
        LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
end)

-- Loop principal
RunService.Stepped:Connect(function()
    -- Aimbot
    if Settings.Aimbot and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local enemy = GetClosestEnemy()
        if enemy then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(
                LocalPlayer.Character.HumanoidRootPart.Position,
                Vector3.new(enemy.HumanoidRootPart.Position.X, LocalPlayer.Character.HumanoidRootPart.Position.Y, enemy.HumanoidRootPart.Position.Z))
        end
    end
    
    -- Defesa infinita
    if Settings.InfiniteDefense and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.MaxHealth = math.huge
        LocalPlayer.Character.Humanoid.Health = math.huge
    end
    
    -- Auto Haki
    if Settings.AutoHaki then
        -- Implementação do Auto Haki
    end
    
    -- Observation Haki
    if Settings.ObservationHaki then
        -- Implementação do Ken Haki
    end
end)

-- Atualizar lista de jogadores
Players.PlayerAdded:Connect(function(player)
    PlayersSection:NewDropdown("Players", "Selecione um jogador", Players:GetPlayers(), function(selected)
        Settings.SelectedPlayer = selected
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    PlayersSection:NewDropdown("Players", "Selecione um jogador", Players:GetPlayers(), function(selected)
        Settings.SelectedPlayer = selected
    end)
end)

print("Retro Hub carregado com sucesso!")
