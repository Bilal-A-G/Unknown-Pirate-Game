--Gets 2 modules, runservice and creates a table names wave
local waveSettings = require(game.ReplicatedStorage:WaitForChild("Common").WaveSettings)
local clock = require(game.ReplicatedStorage:WaitForChild("Common").Clock)
local runService = game:GetService("RunService")
local wave = {}

--Creates 2 sub-tables within wave called connections and physicsConnections
wave.connections = {}
wave.physicsConnections = {}

--Initializes the clock module
clock:Initialize()

--New wave function, creates a new sub-table within wave and wave.connections and populates it with basic details like name, bones, connections (bones and connections are sub-tables themselves with some properties)
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

--This part can pretty much be ignored, it just gets a wave height from a vector2 coordinate
function wave.GerstnerWave(point)
    local finalTranslation = Vector3.new()

    for i,v in pairs(waveSettings.Calm_Wave.Waves)  do
        local wavelength = waveSettings.Calm_Wave.Waves[i].Wavelength
        local amplitude = waveSettings.Calm_Wave.Waves[i].Amplitude
        local speed = waveSettings.Calm_Wave.Waves[i].Speed
        local windDirection = waveSettings.Calm_Wave.Waves[i].WindDirection
        local steepness = waveSettings.Calm_Wave.Waves[i].Steepness

        local W = 2/wavelength
        local phaseConstant = speed * W
        local Q = steepness/W * amplitude

        local xTranslation = point.X + (Q * amplitude * windDirection.X * math.cos(windDirection:Dot(point) * W + clock:GetTime() * phaseConstant))
        local yTranslation = amplitude * math.sin(windDirection:Dot(point) * W + clock:GetTime() * phaseConstant)
        local zTranslation = point.Y + (Q * amplitude * windDirection.Y * math.cos(windDirection:Dot(point) * W + clock:GetTime() * phaseConstant))

        finalTranslation += Vector3.new(xTranslation, yTranslation, zTranslation)
    end
    
    return finalTranslation
end

--Waves update function, determines the current wave and it's connection. Then it runs a runservice loop that manipulates the bones within the wave according to the gerstner wave function, returns the runservice loop for later use
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
                local boneTransform = wave.GerstnerWave(Vector2.new(v.WorldPosition.X, v.WorldPosition.Z))
                v.WorldPosition = Vector3.new(v.WorldPosition.X, boneTransform.Y, v.WorldPosition.Z)
            end
        end
    end)

     currentConnection.connection = intantiatedConnection
end

--Removes the wave from the wave and the wave's connection from the wave.connection table if waveName is supplied, if not it removes all waves and connections
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