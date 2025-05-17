return {
    ---------------
    --RailLogisticsDispatcher.cfg
    ["controls"] = {
        ["viirld-pause-key"]="Pause/reprise du dispatcheur",
    },
    ["entity-description"] = {
    },
    ["entity-name"] = {
        ["viirld-dispatcher"]="Dispatcheur de logistique ferroviaire",
    },
    ["technology-description"] = {
        ["viirld-dispatcher"]="Automatise la logistique ferroviaire en combinant des gares fournisseuses, des gares demandeuses et des trains en un seul réseau automatisé.",
    },
    ["technology-name"] = {
        ["viirld-dispatcher"]="Dispatcheur de logistique ferroviaire",
    },
    ["virtual-signal-description"] = {
        ["viirld-delivery"]="Rail Logistics Dispatcher détermine la livraison qui est arrivée à la gare.\nIl s'agit d'un signal technique qui ne doit pas être modifié manuellement.",
        ["viirld-delivery-pause"]="Rail Logistics Dispatcher cesse d'effectuer des livraisons lorsqu'il reçoit ce signal en entrée.",
    },
    ["virtual-signal-name"] = {
        ["viirld-delivery"]="Identifiant de livraison",
        ["viirld-delivery-pause"]="Ne pas effectuer de livraisons",
    }
    -------------------------
}
