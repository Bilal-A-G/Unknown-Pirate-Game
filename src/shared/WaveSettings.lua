local waveSettings = {

    swimmingRange = 2000,
    viscosity = 0.4,

    Calm_Wave = {

        Waves = {

            PrimaryWave = {

                Wavelength = 3,
                Amplitude = 30,
                Speed = 0.7,
                WindDirection = Vector2.new(1, 0),
                Steepness = 0.1,
            },

            SecondaryWave = {

                Wavelength = 3,
                Amplitude = 15,
                Speed = 1,
                WindDirection = Vector2.new(0.5, 0.5),
                Steepness = 0.5,
            },

            TertiaryWave = {

                Wavelength = 10,
                Amplitude = 25,
                Speed = 0.6,
                WindDirection = Vector2.new(0, 1),
                Steepness = 0.9,
            },

        },
    },
}

return waveSettings