local VenyxLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/Documantation12/Universal-Vehicle-Script/main/Library.lua"))()
local Venyx = VenyxLibrary.new("Universal Vehicle Script", 5013109572)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

--------------------------------------------------
-- THEME
--------------------------------------------------

local Theme = {
    Background = Color3.fromRGB(61, 60, 124),
    Glow = Color3.fromRGB(60, 63, 221),
    Accent = Color3.fromRGB(55, 52, 90),
    LightContrast = Color3.fromRGB(64, 65, 128),
    DarkContrast = Color3.fromRGB(32, 33, 64),
    TextColor = Color3.fromRGB(255, 255, 255)
}

for index, value in pairs(Theme) do
    pcall(Venyx.setTheme, Venyx, index, value)
end

--------------------------------------------------
-- VEHICLE DETECTION
--------------------------------------------------

local function GetVehicleFromDescendant(Descendant)

    if not Descendant then
        return nil
    end

    return
        Descendant:FindFirstAncestor(LocalPlayer.Name .. "'s Car")
        or
        (Descendant:FindFirstAncestor("Body")
        and Descendant:FindFirstAncestor("Body").Parent)
        or
        (Descendant:FindFirstAncestor("Misc")
        and Descendant:FindFirstAncestor("Misc").Parent)
        or
        Descendant:FindFirstAncestorWhichIsA("Model")
end

--------------------------------------------------
-- CURRENT VEHICLE
--------------------------------------------------

local function GetCurrentVehicle()

    local Character = LocalPlayer.Character

    if not Character then
        return nil
    end

    local Humanoid =
        Character:FindFirstChildWhichIsA("Humanoid")

    if not Humanoid then
        return nil
    end

    local SeatPart = Humanoid.SeatPart

    if not SeatPart then
        return nil
    end

    if not SeatPart:IsA("VehicleSeat") then
        return nil
    end

    return GetVehicleFromDescendant(SeatPart)
end

--------------------------------------------------
-- TELEPORT
--------------------------------------------------

local function TeleportVehicle(CoordinateFrame)

    if not CoordinateFrame then
        return false
    end

    local Vehicle = GetCurrentVehicle()

    if not Vehicle then
        return false
    end

    if not Vehicle:IsA("Model") then
        return false
    end

    local Character = LocalPlayer.Character

    local success = pcall(function()
        Vehicle:PivotTo(CoordinateFrame)
    end)

    if not success then

        success = pcall(function()

            if not Vehicle.PrimaryPart then
                Vehicle.PrimaryPart =
                    Vehicle:FindFirstChildWhichIsA("BasePart")
            end

            if Vehicle.PrimaryPart then
                Vehicle:SetPrimaryPartCFrame(CoordinateFrame)
            end

        end)

    end

    if success then

        local Humanoid =
            Character
            and Character:FindFirstChildWhichIsA("Humanoid")

        local SeatPart =
            Humanoid
            and Humanoid.SeatPart

        if SeatPart and SeatPart:IsA("VehicleSeat") then

            SeatPart.AssemblyLinearVelocity =
                Vector3.zero

            SeatPart.AssemblyAngularVelocity =
                Vector3.zero

        end

    end

    return success
end

--------------------------------------------------
-- GUI
--------------------------------------------------

local vehiclePage =
    Venyx:addPage("Vehicle", 8356815386)

--------------------------------------------------
-- USAGE
--------------------------------------------------

local usageSection =
    vehiclePage:addSection("Usage")

local velocityEnabled = true

usageSection:addToggle(
    "Keybinds Active",
    velocityEnabled,
    function(v)
        velocityEnabled = v
    end
)

--------------------------------------------------
-- FLIGHT
--------------------------------------------------

local flightSection =
    vehiclePage:addSection("Flight")

local flightEnabled = false
local flightSpeed = 1

flightSection:addToggle(
    "Enabled",
    false,
    function(v)
        flightEnabled = v
    end
)

flightSection:addSlider(
    "Speed",
    100,
    0,
    800,
    function(v)
        flightSpeed = v / 100
    end
)

local defaultCharacterParent = nil

RunService.Stepped:Connect(function()

    local Character = LocalPlayer.Character

    if flightEnabled then

        if Character and typeof(Character) == "Instance" then

            local Humanoid =
                Character:FindFirstChildWhichIsA("Humanoid")

            if Humanoid then

                local SeatPart = Humanoid.SeatPart

                if SeatPart
                    and SeatPart:IsA("VehicleSeat") then

                    local Vehicle =
                        GetVehicleFromDescendant(SeatPart)

                    if Vehicle and Vehicle:IsA("Model") then

                        if not defaultCharacterParent then
                            defaultCharacterParent =
                                Character.Parent
                        end

                        Character.Parent = Vehicle

                        if not Vehicle.PrimaryPart then

                            if SeatPart.Parent == Vehicle then
                                Vehicle.PrimaryPart = SeatPart
                            else
                                Vehicle.PrimaryPart =
                                    Vehicle:FindFirstChildWhichIsA("BasePart")
                            end

                        end

                        if Vehicle.PrimaryPart then

                            local PrimaryPartCFrame =
                                Vehicle:GetPrimaryPartCFrame()

                            local Camera =
                                workspace.CurrentCamera

                            if Camera then

                                local moveX = 0
                                local moveY = 0
                                local moveZ = 0

                                if not UserInputService:GetFocusedTextBox() then

                                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                                        moveX = flightSpeed
                                    elseif UserInputService:IsKeyDown(Enum.KeyCode.A) then
                                        moveX = -flightSpeed
                                    end

                                    if UserInputService:IsKeyDown(Enum.KeyCode.E) then
                                        moveY = flightSpeed / 2
                                    elseif UserInputService:IsKeyDown(Enum.KeyCode.Q) then
                                        moveY = -flightSpeed / 2
                                    end

                                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                                        moveZ = flightSpeed
                                    elseif UserInputService:IsKeyDown(Enum.KeyCode.W) then
                                        moveZ = -flightSpeed
                                    end

                                end

                                local newCFrame =
                                    CFrame.new(
                                        PrimaryPartCFrame.Position,
                                        PrimaryPartCFrame.Position
                                            + Camera.CFrame.LookVector
                                    )
                                    *
                                    CFrame.new(
                                        moveX,
                                        moveY,
                                        moveZ
                                    )

                                pcall(function()
                                    Vehicle:SetPrimaryPartCFrame(
                                        newCFrame
                                    )
                                end)

                            end

                            SeatPart.AssemblyLinearVelocity =
                                Vector3.zero

                            SeatPart.AssemblyAngularVelocity =
                                Vector3.zero

                        end

                    end

                end

            end

        end

    else

        if Character and defaultCharacterParent then
            Character.Parent = defaultCharacterParent
            defaultCharacterParent = nil
        end

    end

end)

--------------------------------------------------
-- ACCELERATION
--------------------------------------------------

local speedSection =
    vehiclePage:addSection("Acceleration")

local velocityMult = 0.025

speedSection:addSlider(
    "Multiplier (Thousandths)",
    25,
    0,
    50,
    function(v)
        velocityMult = v / 1000
    end
)

local velocityEnabledKeyCode =
    Enum.KeyCode.W

speedSection:addKeybind(
    "Velocity Enabled",
    velocityEnabledKeyCode,

    function()

        if not velocityEnabled then
            return
        end

        while UserInputService:IsKeyDown(
            velocityEnabledKeyCode
        ) do

            task.wait()

            local Character =
                LocalPlayer.Character

            if Character then

                local Humanoid =
                    Character:FindFirstChildWhichIsA(
                        "Humanoid"
                    )

                if Humanoid then

                    local SeatPart =
                        Humanoid.SeatPart

                    if SeatPart
                        and SeatPart:IsA("VehicleSeat") then

                        SeatPart.AssemblyLinearVelocity *=
                            Vector3.new(
                                1 + velocityMult,
                                1,
                                1 + velocityMult
                            )

                    end

                end

            end

            if not velocityEnabled then
                break
            end

        end

    end,

    function(v)
        velocityEnabledKeyCode =
            v.KeyCode
    end
)

--------------------------------------------------
-- DECELERATION
--------------------------------------------------

local decelerateSelection =
    vehiclePage:addSection("Deceleration")

local qbEnabledKeyCode =
    Enum.KeyCode.S

local velocityMult2 =
    150e-3

decelerateSelection:addSlider(
    "Brake Force (Thousandths)",
    velocityMult2 * 1e3,
    0,
    300,

    function(v)
        velocityMult2 =
            v / 1000
    end
)

decelerateSelection:addKeybind(
    "Quick Brake Enabled",
    qbEnabledKeyCode,

    function()

        if not velocityEnabled then
            return
        end

        while UserInputService:IsKeyDown(
            qbEnabledKeyCode
        ) do

            task.wait()

            local Character =
                LocalPlayer.Character

            if Character then

                local Humanoid =
                    Character:FindFirstChildWhichIsA(
                        "Humanoid"
                    )

                if Humanoid then

                    local SeatPart =
                        Humanoid.SeatPart

                    if SeatPart
                        and SeatPart:IsA("VehicleSeat") then

                        SeatPart.AssemblyLinearVelocity *=
                            Vector3.new(
                                1 - velocityMult2,
                                1,
                                1 - velocityMult2
                            )

                    end

                end

            end

            if not velocityEnabled then
                break
            end

        end

    end,

    function(v)
        qbEnabledKeyCode =
            v.KeyCode
    end
)

--------------------------------------------------
-- STOP VEHICLE
--------------------------------------------------

decelerateSelection:addKeybind(
    "Stop the Vehicle",
    Enum.KeyCode.P,

    function()

        if not velocityEnabled then
            return
        end

        local Character =
            LocalPlayer.Character

        if not Character then
            return
        end

        local Humanoid =
            Character:FindFirstChildWhichIsA(
                "Humanoid"
            )

        if not Humanoid then
            return
        end

        local SeatPart =
            Humanoid.SeatPart

        if SeatPart
            and SeatPart:IsA("VehicleSeat") then

            SeatPart.AssemblyLinearVelocity =
                Vector3.zero

            SeatPart.AssemblyAngularVelocity =
                Vector3.zero

        end

    end
)

--------------------------------------------------
-- SPRINGS
--------------------------------------------------

local springSection =
    vehiclePage:addSection("Springs")

springSection:addToggle(
    "Visible",
    false,

    function(v)

        local Vehicle =
            GetCurrentVehicle()

        if not Vehicle then
            return
        end

        for _, SpringConstraint in
            pairs(Vehicle:GetDescendants()) do

            if SpringConstraint:IsA(
                "SpringConstraint"
            ) then

                SpringConstraint.Visible =
                    v

            end

        end

    end
)

--------------------------------------------------
-- SAVED POSITION
--------------------------------------------------

local savedPositionSection =
    vehiclePage:addSection(
        "Saved Position"
    )

local savedVehicleCFrame = nil

--------------------------------------------------
-- SAVE
--------------------------------------------------

savedPositionSection:addButton(
    "Save Vehicle Position",

    function()

        local Vehicle =
            GetCurrentVehicle()

        if not Vehicle then
            return
        end

        local success, result =
            pcall(function()
                return Vehicle:GetPivot()
            end)

        if success and result then
            savedVehicleCFrame = result
        end

    end
)

--------------------------------------------------
-- TELEPORT
--------------------------------------------------

savedPositionSection:addButton(
    "Teleport to Saved Position",

    function()

        if not savedVehicleCFrame then
            return
        end

        TeleportVehicle(
            savedVehicleCFrame
        )

    end
)

--------------------------------------------------
-- CLEAR
--------------------------------------------------

savedPositionSection:addButton(
    "Clear Saved Position",

    function()
        savedVehicleCFrame = nil
    end
)

--------------------------------------------------
-- K = TELEPORT
--------------------------------------------------

UserInputService.InputBegan:Connect(
    function(input, gameProcessedEvent)

        if gameProcessedEvent then
            return
        end

        if input.KeyCode == Enum.KeyCode.K then

            if savedVehicleCFrame then

                TeleportVehicle(
                    savedVehicleCFrame
                )

            end

        end

    end
)

--------------------------------------------------
-- ROUTE AUTOMATION
--------------------------------------------------

local routeSection =
    vehiclePage:addSection(
        "Route Automation"
    )

local routeEnabled = false
local routeRunning = false

--------------------------------------------------
-- KEYBOARD FUNCTIONS
--------------------------------------------------

local function PressKey(key)

    if typeof(keypress) == "function" then
        pcall(function()
            keypress(key)
        end)
    end

end

local function ReleaseKey(key)

    if typeof(keyrelease) == "function" then
        pcall(function()
            keyrelease(key)
        end)
    end

end

--------------------------------------------------
-- STOP ROUTE
--------------------------------------------------

local function StopRoute()

    routeEnabled = false

    ReleaseKey(0x57)
    ReleaseKey(0x44)

end

--------------------------------------------------
-- ROUTE
--------------------------------------------------

local function RunRoute()

    if routeRunning then
        return
    end

    if not routeEnabled then
        return
    end

    routeRunning = true

    task.spawn(function()

        while routeEnabled do

            --------------------------------------------------
            -- STEP 1
            -- W FOR 0.5 SECONDS
            --------------------------------------------------

            if not routeEnabled then
                break
            end

            PressKey(0x57)

            task.wait(0.5)

            ReleaseKey(0x57)

            --------------------------------------------------
            -- STEP 3
            -- WAIT 15 SECONDS
            --------------------------------------------------

            if not routeEnabled then
                break
            end

            task.wait(15)

            --------------------------------------------------
            -- STEP 4
            -- W FOR 15 SECONDS
            --------------------------------------------------

            if not routeEnabled then
                break
            end

            PressKey(0x57)

            task.wait(15)

            ReleaseKey(0x57)

            --------------------------------------------------
            -- STEP 5
            -- D FOR 2 SECONDS
            --------------------------------------------------

            if not routeEnabled then
                break
            end

            PressKey(0x44)

            task.wait(2)

            ReleaseKey(0x44)

            --------------------------------------------------
            -- STEP 7
            -- WAIT 15 SECONDS
            --------------------------------------------------

            if not routeEnabled then
                break
            end

            task.wait(15)

            --------------------------------------------------
            -- STEP 8
            -- TELEPORT TO SAVED POSITION
            --------------------------------------------------

            if not routeEnabled then
                break
            end

            if savedVehicleCFrame then

                TeleportVehicle(
                    savedVehicleCFrame
                )

            end

            --------------------------------------------------
            -- STEP 9
            -- WAIT 3 SECONDS
            --------------------------------------------------

            if not routeEnabled then
                break
            end

            task.wait(3)

            --------------------------------------------------
            -- STEP 10
            -- LOOP
            --------------------------------------------------

        end

        ReleaseKey(0x57)
        ReleaseKey(0x44)

        routeRunning = false

    end)

end

--------------------------------------------------
-- ROUTE GUI TOGGLE
--------------------------------------------------

routeSection:addToggle(
    "Route Automation",
    false,

    function(v)

        routeEnabled = v

        if routeEnabled then

            if not savedVehicleCFrame then

                routeEnabled = false

                return
            end

            RunRoute()

        else

            StopRoute()

        end

    end
)

--------------------------------------------------
-- STOP ROUTE BUTTON
--------------------------------------------------

routeSection:addButton(
    "Stop Route",

    function()

        StopRoute()

    end
)

--------------------------------------------------
-- L = ROUTE ON/OFF
--------------------------------------------------

UserInputService.InputBegan:Connect(
    function(input, gameProcessedEvent)

        if gameProcessedEvent then
            return
        end

        if input.KeyCode == Enum.KeyCode.L then

            if routeEnabled then

                StopRoute()

            else

                if savedVehicleCFrame then

                    routeEnabled = true
                    RunRoute()

                end

            end

        end

    end
)

--------------------------------------------------
-- GAME SPECIFIC PAGES
--------------------------------------------------

repeat
    task.wait()
until game:IsLoaded()
    and game.PlaceId > 0

--------------------------------------------------
-- DRIVING EMPIRE
--------------------------------------------------

if game.PlaceId == 3351674303 then

    local drivingEmpirePage =
        Venyx:addPage(
            "Wayfort",
            8357222903
        )

    local dealershipSection =
        drivingEmpirePage:addSection(
            "Vehicle Dealership"
        )

    local dealershipList = {}

    for _, value in pairs(
        workspace
            :WaitForChild("Game")
            :WaitForChild("Dealerships")
            :WaitForChild("Dealerships")
            :GetChildren()
    ) do

        table.insert(
            dealershipList,
            value.Name
        )

    end

    dealershipSection:addDropdown(
        "Dealership",
        dealershipList,

        function(v)

            game:GetService(
                "ReplicatedStorage"
            )
            .Remotes.Location
            :FireServer(
                "Enter",
                v
            )

        end
    )

--------------------------------------------------
-- GREENVILLE
--------------------------------------------------

elseif game.PlaceId == 891852901 then

    Venyx:addPage(
        "Greenville",
        8360925727
    )

--------------------------------------------------
-- ULTIMATE DRIVING
--------------------------------------------------

elseif game.PlaceId == 54865335 then

    Venyx:addPage(
        "Westover",
        8360954483
    )

--------------------------------------------------
-- PACIFICO
--------------------------------------------------

elseif game.PlaceId == 5232896677 then

    Venyx:addPage(
        "Pacifico",
        3028235557
    )

end

--------------------------------------------------
-- INFORMATION
--------------------------------------------------

local infoPage =
    Venyx:addPage(
        "Information",
        8356778308
    )

local discordSection =
    infoPage:addSection(
        "Discord"
    )

discordSection:addButton(
    syn
        and "Join the Discord server"
        or "Copy Discord Link",

    function()

        if syn then

            syn.request({

                Url =
                    "http://127.0.0.1:6463/rpc?v=1",

                Method =
                    "POST",

                Headers = {

                    ["Content-Type"] =
                        "application/json",

                    ["Origin"] =
                        "https://discord.com"

                },

                Body =
                    game:GetService(
                        "HttpService"
                    ):JSONEncode({

                        cmd =
                            "INVITE_BROWSER",

                        args = {

                            code =
                                "ENHYznSPmM"

                        },

                        nonce =
                            game:GetService(
                                "HttpService"
                            ):GenerateGUID(false)

                    })

            })

            return

        end

        if setclipboard then

            setclipboard(
                "https://www.discord.com/invite/ENHYznSPmM"
            )

        end

    end
)

--------------------------------------------------
-- CLOSE GUI
--------------------------------------------------

local function CloseGUI()
    Venyx:toggle()
end

UserInputService.InputBegan:Connect(
    function(
        input,
        gameProcessedEvent
    )

        if not gameProcessedEvent
            and input.KeyCode ==
                Enum.KeyCode.RightBracket then

            CloseGUI()

        end

    end
)
