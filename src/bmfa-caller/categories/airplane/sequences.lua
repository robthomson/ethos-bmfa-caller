return {
    key   = "airplane",
    name  = "Airplane",
    certs = {
        {
            key  = "airplane-a",
            name = "A Certificate",
            seq  = {
                {file="mnvr1", label="Takeoff & Circuit"},
                {file="mnvr2", label="Figure of Eight"},
                {file="mnvr3", label="Circuit & Landing"},
                {file="mnvr4", label="Takeoff & Circuit"},
                {file="mnvr5", label="Opposite Circuit"},
                {file="mnvr6", label="Dead Stick Landing"},
            },
        },
        {
            key  = "airplane-b",
            name = "B Certificate",
            seq  = {
                {file="mnvr1", label="Figure Eight"},
                {file="mnvr2", label="Inside Loop"},
                {file="mnvr3", label="Outside Loop"},
                {file="mnvr4", label="2x Rolls (into wind)"},
                {file="mnvr5", label="2x Rolls (downwind)"},
                {file="mnvr6", label="Stall Turn"},
                {file="mnvr7", label="3-Turn Spin"},
                {file="mnvr8", label="Approach & Overshoot"},
                {file="mnvr9", label="Rectangular Circuit"},
            },
        },
    },
}
