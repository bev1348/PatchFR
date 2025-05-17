return {
    ---------------
    --valves.cfg
    ["item-name"] = {
        ["valves-overflow"]="Vanne de trop-plein",
        ["valves-top_up"]="Vanne de stockage",
        ["valves-one_way"]="Vanne à sens unique",
    },
    ["entity-name"] = {
        ["valves-overflow"]="Vanne de trop-plein",
        ["valves-top_up"]="Vanne de stockage",
        ["valves-one_way"]="Vanne à sens unique",
    },
    ["entity-description"] = {
        ["valves-overflow"]="Une vanne qui ne permet au fluide de circuler que lorsque le niveau du fluide en entrée est supérieur à un certain seuil.",
        ["valves-top_up"]="Une vanne qui ne permet au fluide de circuler que lorsque le niveau du fluide en sortie est inférieur à un certain seuil.",
        ["valves-one_way"]="Une vanne qui ne permet le débit dans une direction que lorsque le niveau du fluide en entrée est plus élevé que le niveau du fluide en sortie.",
    },
    ["controls"] = {
        ["valves-threshold-plus"]="Augmenter le niveau de seuil de la vanne",
        ["valves-threshold-minus"]="Diminuer le niveau de seuil de la vanne",
    },
    ["controls-description"] = {
        ["valves-threshold-plus"]="Règle le seuil utilisé pour les vannes de trop-plein ou de stockage.",
        ["valves-threshold-minus"]="Règle le seuil utilisé pour les vannes de trop-plein ou de stockage.",
    }
    -------------------------
}
