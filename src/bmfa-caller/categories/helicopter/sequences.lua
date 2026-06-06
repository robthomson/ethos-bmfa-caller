return {
    key   = "helicopter",
    name  = "Helicopter",
    certs = {
        {
            key  = "heli-a",
            name = "A Certificate",
            seq  = {
                {file="mnvr1", label="Maneuver 1"},
                {file="mnvr2", label="Maneuver 2"},
                {file="mnvr3", label="Maneuver 3"},
            },
        },
        {
            key  = "heli-b",
            name = "B Certificate",
            seq  = {
                {file="mnvr1", label="Hovering M"},
                {file="mnvr2", label="Top Hat"},
                {file="mnvr3", label="Takeoff & Climb"},
                {file="mnvr4", label="Left Hand Circuit"},
                {file="mnvr5", label="Right Hand Circuit"},
                {file="mnvr6", label="Stall Turn"},
                {file="mnvr7", label="Nose-In Hover"},
                {file="mnvr8", label="Double Stall Turn"},
                {file="mnvr9", label="45° Approach & Land"},
            },
        },
    },
}
