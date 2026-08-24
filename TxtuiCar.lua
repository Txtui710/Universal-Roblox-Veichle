local VenyxLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/Documantation12/Universal-Vehicle-Script/main/Library.lua"))()
local Venyx = VenyxLibrary.new("TXTUI TURBO", 5013109572)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

--------------------------------------------------
-- THEME
--------------------------------------------------

local Theme = {
    Background = Color3.fromRGB(18, 18, 18),
    Glow = Color3.fromRGB(255, 255, 255),
    Accent = Color3.fromRGB(42, 42, 42),
    LightContrast = Color3.fromRGB(70, 70, 70),
    DarkContrast = Color3.fromRGB(10, 10, 10),
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
-- GET CURRENT VEHICLE
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
-- TELEPORT VEHICLE
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

            if Humanoid and typeof(Humanoid) == "Instance" then

                local SeatPart = Humanoid.SeatPart

                if SeatPart
                    and typeof(SeatPart) == "Instance"
                    and SeatPart:IsA("VehicleSeat") then

                    local Vehicle =
                        GetVehicleFromDescendant(SeatPart)

                    if Vehicle and Vehicle:IsA("Model") then

                        Character.Parent = Vehicle

                        if not Vehicle.PrimaryPart then

                            if SeatPart.Parent == Vehicle then

                                Vehicle.PrimaryPart =
                                    SeatPart

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

        if Character and typeof(Character) == "Instance" then

            if defaultCharacterParent then
                Character.Parent =
                    defaultCharacterParent
            end

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
-- SAVED POSITIONS
--------------------------------------------------

local savedPositionSection =
    vehiclePage:addSection(
        "Saved Positions"
    )

--------------------------------------------------
-- TWO INDEPENDENT SAVED POINTS
--------------------------------------------------

local savedVehicleCFrameK = nil
local savedVehicleCFrameU = nil

--------------------------------------------------
-- SAVE POINT K
--------------------------------------------------

savedPositionSection:addButton(
    "Save Point K",

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

            savedVehicleCFrameK =
                result

        end

    end
)

--------------------------------------------------
-- TELEPORT TO POINT K
--------------------------------------------------

savedPositionSection:addButton(
    "Teleport to Point K",

    function()

        if not savedVehicleCFrameK then
            return
        end

        TeleportVehicle(
            savedVehicleCFrameK
        )

    end
)

--------------------------------------------------
-- CLEAR POINT K
--------------------------------------------------

savedPositionSection:addButton(
    "Clear Point K",

    function()

        savedVehicleCFrameK =
            nil

    end
)

--------------------------------------------------
-- SAVE POINT U
--------------------------------------------------

savedPositionSection:addButton(
    "Save Point U",

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

            savedVehicleCFrameU =
                result

        end

    end
)

--------------------------------------------------
-- TELEPORT TO POINT U
--------------------------------------------------

savedPositionSection:addButton(
    "Teleport to Point U",

    function()

        if not savedVehicleCFrameU then
            return
        end

        TeleportVehicle(
            savedVehicleCFrameU
        )

    end
)

--------------------------------------------------
-- CLEAR POINT U
--------------------------------------------------

savedPositionSection:addButton(
    "Clear Point U",

    function()

        savedVehicleCFrameU =
            nil

    end
)

--------------------------------------------------
-- K HOTKEY
--------------------------------------------------

UserInputService.InputBegan:Connect(
    function(input, gameProcessedEvent)

        if gameProcessedEvent then
            return
        end

        if input.KeyCode == Enum.KeyCode.K then

            if savedVehicleCFrameK then

                TeleportVehicle(
                    savedVehicleCFrameK
                )

            end

        end

    end
)

--------------------------------------------------
-- U HOTKEY
--------------------------------------------------

UserInputService.InputBegan:Connect(
    function(input, gameProcessedEvent)

        if gameProcessedEvent then
            return
        end

        if input.KeyCode == Enum.KeyCode.U then

            if savedVehicleCFrameU then

                TeleportVehicle(
                    savedVehicleCFrameU
                )

            end

        end

    end
)


--------------------------------------------------
-- MACRO RECORDER
--------------------------------------------------

local macroSection =
    vehiclePage:addSection("Macro Recorder")

local macroRecording = false
local macroPlaying = false
local macroEvents = {}
local macroStartTime = 0

local macroRecordKey = Enum.KeyCode.F6
local macroOnceKey = Enum.KeyCode.F7
local macroLoopKey = Enum.KeyCode.F8

local function MacroPress(keyCode)
    if type(keypress) ~= "function" then
        return false
    end

    pcall(keypress, keyCode.Name)
    return true
end

local function MacroRelease(keyCode)
    if type(keyrelease) ~= "function" then
        return false
    end

    pcall(keyrelease, keyCode.Name)
    return true
end

local function StartMacroRecording()
    if macroPlaying then
        return
    end

    macroEvents = {}
    macroRecording = true
    macroStartTime = os.clock()
end

local function StopMacroRecording()
    macroRecording = false
end

local function PlayMacroOnce()
    if macroRecording or macroPlaying or #macroEvents == 0 then
        return
    end

    if type(keypress) ~= "function"
        or type(keyrelease) ~= "function" then
        warn("TXTUI TURBO: executor does not expose keypress/keyrelease.")
        return
    end

    macroPlaying = true

    task.spawn(function()
        local previousTime = 0

        for _, event in ipairs(macroEvents) do
            if not macroPlaying then
                break
            end

            local waitTime = event.time - previousTime

            if waitTime > 0 then
                task.wait(waitTime)
            end

            if not macroPlaying then
                break
            end

            if event.state == "Began" then
                MacroPress(event.keyCode)
            elseif event.state == "Ended" then
                MacroRelease(event.keyCode)
            end

            previousTime = event.time
        end

        macroPlaying = false
    end)
end

local function PlayMacroLoop()
    if macroRecording or macroPlaying or #macroEvents == 0 then
        return
    end

    if type(keypress) ~= "function"
        or type(keyrelease) ~= "function" then
        warn("TXTUI TURBO: executor does not expose keypress/keyrelease.")
        return
    end

    macroPlaying = true

    task.spawn(function()
        while macroPlaying do
            local previousTime = 0

            for _, event in ipairs(macroEvents) do
                if not macroPlaying then
                    break
                end

                local waitTime = event.time - previousTime

                if waitTime > 0 then
                    task.wait(waitTime)
                end

                if not macroPlaying then
                    break
                end

                if event.state == "Began" then
                    MacroPress(event.keyCode)
                elseif event.state == "Ended" then
                    MacroRelease(event.keyCode)
                end

                previousTime = event.time
            end

            if macroPlaying then
                task.wait()
            end
        end

        macroPlaying = false
    end)
end

local function StopMacroPlayback()
    macroPlaying = false
end

-- GUI buttons
macroSection:addButton(
    "F6 - Record ON/OFF",
    function()
        if macroRecording then
            StopMacroRecording()
        else
            StartMacroRecording()
        end
    end
)

macroSection:addButton(
    "F7 - Play Once",
    function()
        PlayMacroOnce()
    end
)

macroSection:addButton(
    "F8 - Play Loop",
    function()
        if macroPlaying then
            StopMacroPlayback()
        else
            PlayMacroLoop()
        end
    end
)

macroSection:addButton(
    "Stop Macro",
    function()
        StopMacroPlayback()
    end
)

macroSection:addButton(
    "Clear Macro",
    function()
        if not macroPlaying and not macroRecording then
            macroEvents = {}
        end
    end
)

-- F6 = toggle recording
-- F7 = play once
-- F8 = play continuously in loop
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then
        return
    end

    if input.KeyCode == macroRecordKey then
        if macroRecording then
            StopMacroRecording()
        else
            StartMacroRecording()
        end
        return
    end

    if input.KeyCode == macroOnceKey then
        PlayMacroOnce()
        return
    end

    if input.KeyCode == macroLoopKey then
        if macroPlaying then
            StopMacroPlayback()
        else
            PlayMacroLoop()
        end
        return
    end

    if macroRecording
        and input.UserInputType == Enum.UserInputType.Keyboard
        and input.KeyCode ~= macroRecordKey
        and input.KeyCode ~= macroOnceKey
        and input.KeyCode ~= macroLoopKey then

        table.insert(macroEvents, {
            time = os.clock() - macroStartTime,
            state = "Began",
            keyCode = input.KeyCode
        })
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then
        return
    end

    if macroRecording
        and input.UserInputType == Enum.UserInputType.Keyboard
        and input.KeyCode ~= macroRecordKey
        and input.KeyCode ~= macroOnceKey
        and input.KeyCode ~= macroLoopKey then

        table.insert(macroEvents, {
            time = os.clock() - macroStartTime,
            state = "Ended",
            keyCode = input.KeyCode
        })
    end
end)

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
