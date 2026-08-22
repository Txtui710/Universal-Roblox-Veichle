--------------------------------------------------
-- TELEPORT HOTKEY - K
--------------------------------------------------

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)

    if gameProcessedEvent then
        return
    end

    if input.KeyCode == Enum.KeyCode.K then

        if not savedVehicleCFrame then
            return
        end

        local Vehicle = GetCurrentVehicle()

        if not Vehicle or not Vehicle:IsA("Model") then
            return
        end

        local Character = LocalPlayer.Character

        local Humanoid =
            Character
            and Character:FindFirstChildWhichIsA("Humanoid")

        local SeatPart =
            Humanoid
            and Humanoid.SeatPart

        pcall(function()

            Vehicle:PivotTo(savedVehicleCFrame)

            if SeatPart and SeatPart:IsA("VehicleSeat") then

                SeatPart.AssemblyLinearVelocity =
                    Vector3.zero

                SeatPart.AssemblyAngularVelocity =
                    Vector3.zero

            end

        end)

    end

end)
