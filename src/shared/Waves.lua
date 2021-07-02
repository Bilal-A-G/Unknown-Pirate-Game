local waveSettings = require(game.ReplicatedStorage:WaitForChild("Common").WaveSettings)
local clock = require(game.ReplicatedStorage:WaitForChild("Common").Clock)
local runService = game:GetService("RunService")
local wave = {}

wave.connections = {}

clock:Initialize()

function wave.New(waveName, wavePlane)
    local newWave = {}
    newWave.Name = waveName

    local newConnection = {}
    newConnection.Name = waveName
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

function wave.SinesApproximation(point)
    local wavelength = waveSettings.Calm_Wave.Wavelength
    local amplitude = waveSettings.Calm_Wave.Amplitude
    local speed = waveSettings.Calm_Wave.Speed
    local windDirection = waveSettings.Calm_Wave.WindDirection

    local w = 2/wavelength
    local phaseConstant = speed * w

    return amplitude * math.sin(windDirection:Dot(point) * w + clock:GetTime() * phaseConstant)
end

function wave:Update(waveName)
    local currentWave
    local currentConnection

    for i = 1, #wave do
        if wave[i].Name == waveName then
            currentWave = wave[i]
            break
        end
    end

    for i = 1, #wave.connections do
        if wave.connections[i].Name == waveName then
            currentConnection = wave.connections[i]
            break
        end
    end

    local intantiatedConnection =  runService.Stepped:Connect(function()
        for i,v in pairs(currentWave.bones) do
            if v:IsA("Bone") then
                local boneHeight = wave.SinesApproximation(Vector2.new(v.WorldPosition.X, v.WorldPosition.Z))
                v.WorldPosition = Vector3.new(v.WorldPosition.X, boneHeight, v.WorldPosition.Z)
            end
        end
    end)

     currentConnection.connection = intantiatedConnection
end

function wave:Terminate(waveName)
    if waveName then
        for i = 1, #wave.connections  do
            if wave.connections[i] and wave.connections[i].Name == waveName then
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