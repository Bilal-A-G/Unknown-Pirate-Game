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