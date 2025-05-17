return {
    ---------------
    --LogisticTrainNetwork.cfg
    ["entity-name"] = {
        ["logistic-train-stop"]="Arrêt de train logistique",
        ["logistic-train-stop-input"]="Entrée de l'arrêt de train logistique",
        ["logistic-train-stop-output"]="Sortie de l'arrêt du train logistique",
        ["ltn-port"]="Port logistique",
    },
    ["entity-description"] = {
        ["logistic-train-stop"]="Les arrêts logistiques demandent et fournissent des objets et des fluides.",
        ["ltn-port"]="Les ports logistiques demandent et fournissent des objets et des fluides.",
    },
    ["item-name"] = {
    },
    ["recipe-name"] = {
    },
    ["technology-name"] = {
        ["logistic-train-network"]="Réseau de trains logistique",
        ["logistic-ship-network"]="Réseau de navires logistiques",
    },
    ["technology-description"] = {
        ["logistic-train-network"]="Les arrêts de train logistiques demandent et fournissent des objets et des fluides avec des itinéraires de train générés automatiquement.",
    },
    ["virtual-signal-name"] = {
        ["ltn-position-any-locomotive"]="Positions encodées de chaque locomotive",
        ["ltn-position-any-cargo-wagon"]="Positions encodées de chaque wagon de marchandises",
        ["ltn-position-any-fluid-wagon"]="Positions encodées de chaque wagon de fluide",
        ["ltn-position-any-artillery-wagon"]="Positions encodées de chaque canon d'artillerie",
        ["ltn-depot"]="L'arrêt est un dépôt.",
        ["ltn-depot-priority"]="Priorité du dépôt",
        ["ltn-network-id"]="Identifiant du réseau encodé",
        ["ltn-min-train-length"]="Longueur minimale des trains",
        ["ltn-max-train-length"]="Longueur maximale des trains",
        ["ltn-max-trains"]="Limite du nombre de trains",
        ["ltn-fuel-station"]="L'arrêt est une station-service",
        ["ltn-requester-threshold"]="Seuil de demande",
        ["ltn-requester-stack-threshold"]="Seuil de demande par pile",
        ["ltn-requester-priority"]="Priorité de la demande",
        ["ltn-provider-threshold"]="Seuil de fourniture",
        ["ltn-provider-stack-threshold"]="Seuil de fourniture par pile",
        ["ltn-provider-priority"]="Priorité de fourniture",
        ["ltn-locked-slots"]="Emplacements verrouillés par wagon",
        ["ltn-disable-warnings"]="Désactiver les messages d'avertissement",
    },
    ["controls"] = {
        ["ltn-toggle-dispatcher"]="Activer le dispatcheur LTN.",
    }
    -------------------------
}
