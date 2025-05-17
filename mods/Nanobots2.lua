return {
    ---------------
    --Nanobots2.cfg
    ["item-name"] = {
        ["gun-nano-emitter"]="Nanoémetteur",
        ["ammo-nano-termites"]="Nanorobots termites",
        ["ammo-nano-scrappers"]="Nanorobots de démolition",
        ["ammo-nano-constructors"]="Nanorobots de construction",
        ["ammo-nano-deconstructors"]="Nanorobots de déconstruction",
        ["roboport-interface-main"]="Interface de réseau logistique",
        ["equipment-bot-chip-nanointerface"]="Interface logistique des nanorobots",
    },
    ["item-description"] = {
        ["ammo-nano-termites"]="Détruit des arbres à portée. Ne retourne pas les objets.",
        ["ammo-nano-scrappers"]="Détruit toute entité marquée pour la déconstruction dans la zone à portée. Ne retourne pas les objets.",
        ["ammo-nano-deconstructors"]="Déconstruit toute entité marquée pour la déconstruction dans la zone à portée. Vous rendra les objets.",
        ["ammo-nano-constructors"]="Ravive les fantômes des entités dans la zone à portée en utilisant les objets dans votre inventaire. Répare également les entités endommagées.",
        ["equipment-bot-chip-launcher"]="Configure les roboports personnels pour lancer automatiquement des unités de combat depuis l'inventaire lorsque les ennemis sont à portée. Nécessite un roboport personnel pour fonctionner.",
        ["equipment-bot-chip-nanointerface"]="Permet aux nanorobots de travailler à l'intérieur des cellules logistiques. Une seule puce est nécessaire.",
        ["roboport-interface-main"]="S'interface avec le réseau logistique le plus proche pour l'affectation des tâches.",
    },
    ["ammo-category-name"] = {
        ["nano-ammo"]="Nano-munitions",
    },
    ["ammo-category-description"] = {
        ["nano-ammo"]="Nano-munitions",
    },
    ["virtual-signal-name"] = {
        ["nano-signal-chop-trees"]="Interface Roboport\nMarquer les arbres pour l'abattage\nRégler sur une quantité négative pour ne couper que les arbres jusqu'à ce qu'il y ait autant de bois brut dans le réseau.",
        ["nano-signal-item-on-ground"]="Interface Roboport\nMarquer les objets au sol",
        ["nano-signal-closest-roboport"]="Interface Roboport\nUtiliser uniquement des signaux avec le roboport le plus proche de la zone à portée",
        ["nano-signal-deconstruct-finished-miners"]="Interface Roboport\nRécupérer les foreuses ayant terminé leur travail",
        ["nano-signal-ladfill-the-world"]="Interface Roboport\nRemplir l'eau avec du remblai\nRégler sur une quantité négative pour garder cette quantité de remblais dans le réseau",
        ["nano-signal-catch-fish"]="Interface Roboport\nTrouver tous les poissons\nLes poissons sont bons, les poissons sont géniaux",
        ["nano-signal-smarter-charging"]="Interface Roboport\nRecharge intelligente des robots\nOblige périodiquement certains robots à trouver de nouveaux points de chargement.",
        ["nano-signal-upgrade-modules"]="Interface Roboport\nMise à niveau des modules\nRemplace les modules de niveau inférieur par des versions de niveau supérieur.",
        ["nano-signal-refill-turrets"]="Interface Roboport\nRecharger les tourelles\nRéglez à une quantité positive pour remplir les tourelles de munitions.",
    },
    ["virtual-signal-description"] = {
        ["nano-signal-item-on-ground"]="Marquer des objets au sol",
    },
    ["fluid-name"] = {
    },
    ["fluid-description"] = {
    },
    ["equipment-name"] = {
        ["equipment-bot-chip-items"]="Récupérateur automatique d'objets",
        ["equipment-bot-chip-trees"]="Abatteur automatique d'arbres",
        ["equipment-bot-chip-launcher"]="Lanceur automatique d'unités",
        ["equipment-bot-chip-feeder"]="Système automatique de guérison",
        ["equipment-bot-chip-nanointerface"]="Interface logistique pour nanorobots",
    },
    ["equipment-description"] = {
        ["equipment-bot-chip-launcher"]="Configure les roboports personnels pour lancer automatiquement des unités de combat depuis l'inventaire lorsque les ennemis sont à portée. Nécessite un roboport personnel pour fonctionner.",
        ["equipment-bot-chip-nanointerface"]="Permet aux nanorobots de travailler à l'intérieur des cellules logistiques. Une seule puce est nécessaire. Fonctionnera sans roboport personnel ou robots.",
    },
    ["entity-name"] = {
        ["nano-proxy-health"]="Cible de remplacement pour nanorobots",
        ["roboport-interface-main"]="Interface de réseau logistique",
        ["roboport-interface-scanner"]="Analyseur d'interface",
        ["roboport-interface-cc"]="Programmeur d'interface",
    },
    ["entity-description"] = {
        ["roboport-interface-main"]="S'interface avec le réseau logistique le plus proche pour l'affectation des tâches.",
        ["roboport-interface-scanner"]="Analyse le réseau et fait des rapports sur les travaux disponibles.",
    },
    ["technology-name"] = {
        ["nanobots"]="Nanorobots",
        ["nanobots-cliff"]="Nano-explosifs",
        ["nano-range"]="Portée des nanorobots",
        ["nano-speed"]="Vitesse des nanorobots",
        ["roboport-interface"]="Interfaçage des réseaux logistiques",
    },
    ["technology-description"] = {
        ["nanobots"]="Libérez de puissants petits robots pour vous aider à vous mettre en route.",
        ["nanobots-cliff"]="Jetez suffisamment de nanorobots et d'explosifs sur une falaise et faites-la disparaître.",
        ["nano-range"]="Votre connaissance des technologies précédentes vous permet d'augmenter légèrement la portée de vos nanorobots.",
        ["nano-speed"]="Votre connaissance des technologies précédentes augmente légèrement la vitesse à laquelle vos nanorobots fonctionnent.",
        ["roboport-interface"]="Interfaces avec les réseaux logistiques pour l'affectation des tâches.",
    },
    ["shortcut"] = {
        ["toggle-equipment-bot-chip-items"]="Activer les nanorobots récupérateurs d'objets",
        ["toggle-equipment-bot-chip-trees"]="Activer les nanorobots abatteurs d'arbres",
        ["toggle-equipment-bot-chip-feeder"]="Activer les nanorobots de guérison",
        ["toggle-equipment-bot-chip-nanointerface"]="Activer l'interface logistique",
        ["toggle-equipment-bot-chip-launcher"]="Activer les nanorobots lanceurs d'unités",
    }
    -------------------------
}
