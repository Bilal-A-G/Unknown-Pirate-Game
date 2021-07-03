local waveSettings = require(game.ReplicatedStorage:WaitForChild("Common").WaveSettings)
local clock = require(game.ReplicatedStorage:WaitForChild("Common").Clock)
local runService = game:GetService("RunService")
local wave = {}

wave.connections = {}
wave.physicsConnections = {}

clock:Initialize()

function wave.New(waveName, wavePlane)
    local newWave = {}
    newWave.name = waveName

    local newConnection = {}
    newConnection.name = waveName
    newConnection.connection = nil

    newWave.bones = {}

    for i,v in pairs(wavePlane:GetChildren()) do
        if v:IsA("Bone") then
            table.insert(newWave.bones, v)
        end
    end

    table.insert(wave, newWave)
    table.insert(wave.connections, newConnection)
end

function wave.GerstnerWave(point, waveIndex)
    local wavelength = waveSettings.Calm_Wave.Waves[waveIndex].Wavelength
    local amplitude = waveSettings.Calm_Wave.Waves[waveIndex].Amplitude
    local speed = waveSettings.Calm_Wave.Waves[waveIndex].Speed
    local windDirection = waveSettings.Calm_Wave.Waves[waveIndex].WindDirection
    local steepness = waveSettings.Calm_Wave.Waves[waveIndex].Steepness

    local W = 2/wavelength
    local phaseConstant = speed * W
    local Q = steepness/W * amplitude

    local xTranslation = point.X + (Q * amplitude * windDirection.X * math.cos(windDirection:Dot(point) * W + clock:GetTime() * phaseConstant))
    local yTranslation = amplitude * math.sin(windDirection:Dot(point) * W + clock:GetTime() * phaseConstant)
    local zTranslation = point.Y + (Q * amplitude * windDirection.Y * math.cos(windDirection:Dot(point) * W + clock:GetTime() * phaseConstant))

    return Vector3.new(xTranslation, yTranslation, zTranslation)
end

function wave:Update(waveName)
    local currentWave
    local currentConnection

    for i = 1, #wave do
        if wave[i].name == waveName then
            currentWave = wave[i]
            break
        end
    end

    for i = 1, #wave.connections do
        if wave.connections[i].name == waveName then
            currentConnection = wave.connections[i]
            break
        end
    end

    local intantiatedConnection = runService.Stepped:Connect(function()
        for i,v in pairs(currentWave.bones) do
            if v:IsA("Bone") then
                local boneHeightTransform
                for z,k in pairs(waveSettings.Calm_Wave.Waves)  do
                    if boneHeightTransform then
                        boneHeightTransform = boneHeightTransform + wave.GerstnerWave(Vector2.new(v.WorldPosition.X, v.WorldPosition.Z), z).Y
                    else
                        boneHeightTransform = wave.GerstnerWave(Vector2.new(v.WorldPosition.X, v.WorldPosition.Z), z).Y
                    end
                end
                v.WorldPosition = Vector3.new(v.WorldPosition.X, boneHeightTransform, v.WorldPosition.Z)
            end
        end
    end)

     currentConnection.connection = intantiatedConnection
end

function wave.SimulatePhysics(waveName, part)
    local attachments = {}
    local viscosity = waveSettings.viscosity
    local depthBeforeSubmerged = 0.001
    local displacementAmount = 1.3
    local cornerTransforms = {
        Vector3.new(1, -1, 1),
        Vector3.new(1, -1, -1),
        Vector3.new(-1, -1, 1),
        Vector3.new(-1, -1, -1),
    }
    for i,v in pairs(cornerTransforms)  do
        local attachment = Instance.new("Attachment")
        attachment.Position = v * Vector3.new(part.Size.X/2, part.Size.Y/2, part.Size.Z/2)
		attachment.Visible = true
		attachment.Name = "Attachment " .. tostring(i)
		attachment.Parent = part

        local vectorForce = Instance.new("VectorForce")
        vectorForce.RelativeTo = Enum.ActuatorRelativeTo.World
        vectorForce.Attachment0 = attachment
        vectorForce.RelativeTo = Enum.ActuatorRelativeTo.Attachment0
        vectorForce.Force = Vector3.new(0, 0, 0)
        vectorForce.Visible = false
        vectorForce.Enabled = true
        vectorForce.ApplyAtCenterOfMass = false
        vectorForce.Parent = part
        attachments[i] = vectorForce
    end

    local waterDragTorque = Instance.new("BodyAngularVelocity")
	waterDragTorque.AngularVelocity = Vector3.new(0, 0, 0)
	waterDragTorque.P = math.huge
	waterDragTorque.Parent = part

    local newPhysicsConnection = runService.Heartbeat:Connect(function()
        if runService:IsServer() then
            for i = 1, #attachments  do
                local currentAttachment = attachments[i].Attachment0
                local finalWaveHeight
                for x,z in pairs(waveSettings.Calm_Wave.Waves)  do
                    if finalWaveHeight then
                        finalWaveHeight = finalWaveHeight + wave.GerstnerWave(Vector2.new(currentAttachment.WorldPosition.X, currentAttachment.WorldPosition.Z), x)
                    else
                        finalWaveHeight = wave.GerstnerWave(Vector2.new(currentAttachment.WorldPosition.X, currentAttachment.WorldPosition.Z), x)
                    end
                end
                if currentAttachment.WorldPosition.Y < finalWaveHeight.Y then
                    local displacementMultiplier = math.clamp((finalWaveHeight.Y - currentAttachment.WorldPosition.Y)/depthBeforeSubmerged, 0, 1) * displacementAmount
                    local dragForce = Vector3.new(part:GetVelocityAtPosition(currentAttachment.WorldPosition).X * -1 * viscosity, part:GetVelocityAtPosition(currentAttachment.WorldPosition).Y * -1 * viscosity, part:GetVelocityAtPosition(currentAttachment.WorldPosition).Z * -1 * viscosity)
                    local boyancyForce = Vector3.new(0, game.Workspace.Gravity/4 * part.AssemblyMass * displacementMultiplier, 0)
                    attachments[i].Force = boyancyForce + dragForce
                else
                    attachments[i].Force = Vector3.new(0,0,0)
                end
            end
        end
    end)

    local newPhysicsConnectionObject = {}
    newPhysicsConnectionObject.connection = newPhysicsConnection
    newPhysicsConnectionObject.name = waveName

    table.insert(wave.physicsConnections, newPhysicsConnectionObject)
end

function wave.StopPhysics(waveName)
    for i = 1, #wave.physicsConnections  do
        if wave.physicsConnections[i].name == waveName then
            wave.physicsConnections[i].connection:Disconnect()
        end
    end
end

function wave:Terminate(waveName)
    if waveName then
        for i = 1, #wave.connections  do
            if wave.connections[i] and wave.connections[i].name == waveName then
                wave.connections[i].connection:Disconnect()
                table.remove(wave.connections, i)
                table.remove(wave, i)              
            end
        end
    else
        for i = 1, #wave.connections  do
            wave.connections[i].connection:Disconnect()
            table.remove(wave.connections, i)
            table.remove(wave, i)
        end
    end
end

return wave