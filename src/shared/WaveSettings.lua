local waveSettings = {
    Calm_Wave = {

        Waves = {

            PrimaryWave = {

                Wavelength = 5,
                Amplitude = 30,
                Speed = 0.5,
                WindDirection = Vector2.new(0.5, 0.5),
                Steepness = 0.5,
            },

            SecondaryWave = {

                Wavelength = 4,
                Amplitude = 20,
                Speed = 0.7,
                WindDirection = Vector2.new(0.9, -0.5),
                Steepness = 0,
            },

            TertiaryWave = {

                Wavelength = 5,
                Amplitude = 25,
                Speed = 1,
                WindDirection = Vector2.new(0.95, 0),
                Steepness = 0,
            },

        },
    },
}

return waveSettings