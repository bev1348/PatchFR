---
title: Dossier de passation — PatchFR
mod: PatchFR
profile: data-patcher + locale provider (passif runtime)
factorio_version: "2.0"
pinned_version: 2.0.20
audit_date: 2026-07-12
---

# Dossier de passation — PatchFR

Contexte structuré pour la **skill 2 (annotations LuaLS)** et la **skill 3 (documentation)**.
Ne ré-auditer pas : tout ce qui suit est vérifié dans le code à la version 2.0.20.

## A. Métadonnées & périmètre

- **Profil** : mod **data-stage pur**, autonome (auteur `bev`, dépôt `github.com/bev1348/PatchFR`),
  sans dépendance à RitnLib ni à aucun mod Ritn. Dépendance unique `base >= 2.0`.
- **Rôle** : traduction FR de 500+ mods par deux voies indépendantes :
  1. `locale/fr/*.cfg` (596 fichiers) — locale native moteur, **aucun code** ;
  2. code Lua data-stage — patchs de prototypes pour les cas que le `.cfg` ne couvre pas.
- **Arborescence explorée** :
  - `data-final-fixes.lua` — entrypoint (le seul stage exécuté).
  - `classes/CommuPrototype.lua` — cœur.
  - `core/class.lua`, `core/functions.lua`, `core/types_entity.lua`, `core/types_item.lua`,
    `core/types_equipment.lua`.
  - `prototypes/mods-list.lua`, `prototypes/prototypes-list.lua`.
  - `mods/*.lua` (×106) — tables de traduction (données).
  - `locale/fr/*.cfg` (×596) — **exclus** (données de traduction, hors annotation/doc code).
- **Renvoi** : [docs/architecture.md](../architecture.md).

### Décision de périmètre (confirmée avec Ritn)
- **Documenter uniquement** le cœur `CommuPrototype` + le flux. **Rien** sur les `.cfg` ni sur la
  correspondance `.cfg` ↔ `.lua` dans la doc de code.
- **Objectif de doc distinct** (skill 3, audience **traducteur**) : un guide expliquant le
  fonctionnement global des `.cfg` et de leurs équivalents `.lua`, comme support de traduction pour
  une personne ne connaissant pas le modding. Voir § C.7.

## B. Pour la skill 2 — surface d'API à annoter (LuaLS)

> Rien n'est publié dans `_G` : **aucun meta-file de globals** à tenir. Tout est module `require`-é.
> Annotations bilingues FR+EN en commentaires uniquement, jamais de modif de logique.

### B.1 Table des cibles

| Fichier | Symbole | Nature | Hérite de | Accès | Miroir meta-file ? | Statut |
|---|---|---|---|---|---|---|
| `classes/CommuPrototype.lua` | `CommuPrototype` | classe (factory `newclass`) | — | `require` | non | à annoter |
| `core/class.lua` | `class` = `{ newclass }` | module + factory générique | — | `require` | non | à annoter |
| `core/class.lua` | `newclass(super, init)` | fonction factory | — | — | non | à annoter (générateur de classe → `@generic`/`@return`) |
| `core/functions.lua` | module util | table de fonctions | — | `require` | non | à annoter (⚠ voir `tryCatch`, § C.6) |
| `core/types_entity.lua` | `entity_types` | `string[]` | — | `require` | non | à annoter (`@type string[]`) |
| `core/types_item.lua` | `item_types` | `string[]` | — | `require` | non | à annoter (`@type string[]`) |
| `core/types_equipment.lua` | `equip_types` | `string[]` | — | `require` | non | à annoter (`@type string[]`) |
| `prototypes/mods-list.lua` | `modsList` | `string[]` | — | `require` | non | à annoter (`@type string[]`) |
| `prototypes/prototypes-list.lua` | `prototypes_list` | `string[]` | — | `require` | non | à annoter (`@type string[]`) |
| `mods/*.lua` (×106) | tables de trad | données | — | `require` | non | **NE PAS annoter dans les fichiers** (décision 5a) — définir **un seul** type-alias central ailleurs, laisser les 106 fichiers intacts pour le traducteur (voir B.2) |

### B.2 Détail par classe/module

**`CommuPrototype`** (`classes/CommuPrototype.lua`)

Attributs (candidats `@field`), posés au constructeur :
- `object_name :: string` — toujours `"CommuPrototype"`.
- `prototype_name :: string`, `name :: string` — nom de prototype ciblé (identiques).
- `type_select :: string` — type générique reçu (`item`/`entity`/`equipment`/`controls`/…).
- `type :: string?` — type concret résolu dans `data.raw` (nil si non résolu → l'objet est inerte).
- `variant_level :: uint` — niveau courant (démarre à 1) pour technos/variantes.
- `proto_variant_name :: string` — `name.."-1"`.
- `prototype_with_level :: boolean` — vrai si le prototype existe sous forme numérotée `-N`.
- `prototype :: table?` — copie de travail (`table.deepcopy`) du prototype ciblé.
- `start :: table<string,string>`, `pattern :: table<string,string>` — ⚠ **utilisés uniquement par
  le cluster inachevé `localisedBuilder*`** (§ C.6, conservé exprès). À annoter avec avertissement
  « fonctionnalité inachevée, non câblée » (🚧), pas « mort à retirer ».

Méthodes (signatures observées) :
- `CommuPrototype(prototype_name, prototype_type)` → instance (constructeur via `__call`).
- `:getName()` → `string` — renvoie `name` ou `name-<variant_level>` selon `prototype_with_level`.
- `:getData()` → `table?` — `data.raw[type][getName()]`.
- `:setData(pData)` — écrit dans `data.raw[type][getName()]`.
- `:changePrototype()` → `self` — incrémente le niveau et recharge la variante suivante. Chaînable.
- `:techLevelUp()` — `variant_level++`.
- `:setLocalisedName(value)` → `self` — pose le nom ; gère technos à niveaux (`"valeur N"`) et
  recherche infinie (dernier palier sans numéro). Chaînable.
- `:localisedName(value)` — pose `prototype.localised_name` + `update()`.
- `:setLocalisedDescription(value)` → `self` — pose la description ; ⚠ boucle à niveaux divergente
  (§ C.6). Chaînable.
- `:isInfinite()` → `boolean` — vrai si `prototype.max_level == "infinite"`.
- `:update()` → `self` — écrit `self.prototype` dans `data.raw` si cohérent.
- `:localisedBuilderStartWith(value, typeBuilder)` → `boolean` — ⚠ **cluster inachevé 🚧** (conservé).
- `:localisedBuilderMatched(value, typeBuilder)` → `boolean, string, string` — ⚠ **cluster inachevé 🚧**.
- `:matchLocalisedBuilder(value)` → `boolean, string, string` — ⚠ **cluster inachevé 🚧** (non câblé, gardé exprès).

`value` des setters : type `LocalisedString` Factorio (string simple **ou** table `{key, ...}`).

**`core/class.lua`** — `newclass(super, init)` : factory générique. `super` optionnel (table ou
fonction init). Retourne une classe appelable (`Class(...)` construit une instance), exposant
`is_a(klass) → boolean`, `_super`, `init`. Bon candidat `@generic`.

**`core/functions.lua`** — `ifElse(cond, Then, Else)` (ternaire ; ⚠ branche `tryCatch` cassée, § C.6),
`isBoolean/isString/isNumber/isNil(value) → boolean`, `isTrue(value) → boolean`.

**Type-alias mods/** (décision 5a — **un seul, central, non-intrusif**) :
`table<string, table<string, LocalisedString>>` — clés de 1er niveau = `"<type>"` /
`"<type>-name"` / `"<type>-description"` ; clés de 2e niveau = nom de prototype ; valeur = trad.
→ Le définir **une fois** dans un fichier meta/types dédié (ex. `types/patchfr-mods.lua` ou en tête de
`data-final-fixes.lua`), et **ne rien écrire dans les 106 `mods/*.lua`** : ces fichiers restent la zone
de travail du traducteur, aucune annotation ne doit s'y ajouter.

## C. Pour la skill 3 — matière de documentation

### C.1 Carte des classes

| Classe | Fichier | Wrappe / rôle | Accès | Hérite de | Description courte |
|---|---|---|---|---|---|
| `CommuPrototype` | `classes/CommuPrototype.lua` | un prototype `data.raw` | `require` | — | Résout le type concret d'un prototype et y pose `localised_name`/`localised_description`, en gérant les variantes numérotées et la recherche infinie |

### C.2 Détail par classe publique — `CommuPrototype`

- **Constructeur** `CommuPrototype(prototype_name, prototype_type)` :
  - résout le type concret (`getType`) ; si non résolu, log une erreur et l'objet reste **inerte**
    (`self.type == nil`, tous les setters font `return self` sans effet) ;
  - détecte les variantes `-N` (`prototype_with_level`) ;
  - `deepcopy` du prototype ciblé dans `self.prototype`. Si nil, l'objet est inerte.
  - Entrée invalide (type/nom inconnu) : **jamais d'erreur levée** — dégradation silencieuse + log.
- **Attributs** : voir B.2 (tous Read ; snapshot au constructeur, la copie de travail est
  ré-hydratée par `changePrototype`).
- **Méthodes publiques** : `setLocalisedName`, `setLocalisedDescription` (chaînables) ; le reste est
  interne au flux.
- **Exemples d'usage réels** (sourcés, vérifiés) :
  - `data-final-fixes.lua:14` — `CommuPrototype(name, prototype_type):setLocalisedName(locale)`.
  - `data-final-fixes.lua:37` — `CommuPrototype(name, prototype_type):setLocalisedDescription(locale)`.
  - Données d'entrée type : `mods/Accumulator-V2.lua:7-9` (`["entity-name"] = { ["accumulator-v2"]="Accumulateur V2" }`).
  - Techno : `mods/bobinserters.lua:4-6` (`["technology-description"] = { ["long-inserters"]="…" }`).
- **Remarques / pièges** :
  - `CommuPrototype` est un **wrapper temporaire** : jamais stocké, ses effets vivent dans `data.raw`.
  - Un même nom peut exister sous plusieurs types ; `getType` prend le **premier** trouvé dans l'ordre
    des listes `types_*` — l'ordre des listes est significatif.
  - Pour les technos à niveaux, `setLocalisedName` produit `"Valeur 1"`, `"Valeur 2"`, … et le
    dernier palier infini sans numéro.

### C.3 Interface remote
**Sans objet** — aucune interface remote exposée ni consommée.

### C.4 Event Map
**Sans objet** — aucun `script.on_event`, `on_nth_tick`, custom event ni remote. Mod data-stage passif.

### C.5 Persistence Map
**Sans objet** — aucun `storage`/`global`, aucun `register_metatable`. Seule « persistance » : les
mutations écrites dans `data.raw` au chargement (état de définition, pas état de partie).

### C.6 Classification des défauts

> Statuts arbitrés par Ritn le 2026-07-12 (voir §D). Aucun **défaut latent** retenu.

**Défauts latents confirmés**
- **Aucun.** Les deux points suspectés à l'audit ont été tranchés comme **choix assumés** (voir plus bas).

**Effets de bord mineurs / à nettoyer**
- Toggle de test commenté `data-final-fixes.lua:49-50` (`--if true then …`) — résidu de scaffolding.
- `getType` : balayage linéaire + `pcall` par type pour chaque nom, et `deepcopy` complet du
  prototype pour ne changer qu'un libellé → coût de chargement (pas UPS), acceptable mais lourd.

**Code beta / inachevé — CONSERVÉ volontairement** (→ pages stub 🚧, décision 3a)
- Cluster `localisedBuilderStartWith` / `localisedBuilderMatched` / `matchLocalisedBuilder` +
  `self.start` / `self.pattern` (`classes/CommuPrototype.lua:346-388`) — parseur de tokens
  `__ITEM__…__` / `__ENTITY__…__`, tentative de fonctionnalité **inachevée**, non câblée au flux.
  **Gardé exprès** par Ritn. À annoter/documenter comme inachevé (🚧), **ne pas retirer**.

**Résidus API 1.x**
- Aucun repéré. (`data.raw`, `table.deepcopy`, `localised_name/description`, `max_level` sont valides
  en 2.0.)

**Ce qui n'est PAS un bug (à dire explicitement)**
- **`ifElse` → `tryCatch`** (`core/functions.lua:5,11`) — utilitaire **recopié de RitnLib, conservé
  volontairement** (décision 2a). La branche « fonction » qui appelle `tryCatch` est **dormante** (seul
  appelant `isNil`, qui passe des booléens). `tryCatch` reste non défini tant que la branche n'est pas
  utilisée : **dépendance dormante assumée**, à noter factuellement, **rien à corriger**.
- **`setLocalisedDescription` à niveaux** (`classes/CommuPrototype.lua:304-317`) — arrêt anticipé
  **voulu** (décision 4a) : la description est censée **rester identique quel que soit le niveau**.
  Comportement intentionnel, pas un défaut.
- Suffixe `-N` de `getVariantName` (`constants.COMMA = '-'`) : **convention intentionnelle** pour
  cibler les variantes/paliers numérotés.
- Sondage `pcall` de `data.raw[type][name]` : **défensif intentionnel** (tous les types n'existent pas
  selon les mods chargés).
- `localizationPrototype` enveloppe chaque pose dans `pcall` : **tolérance intentionnelle** aux
  prototypes absents (un mod peut renommer/retirer une entrée).

### C.7 Plan de documentation recommandé

**Tier 0 — stratégique / vue d'ensemble**
1. Vue d'ensemble du flux data-stage (les deux voies `.cfg` vs `.lua`, quand chacune s'applique).
2. `CommuPrototype` : rôle, cycle de vie du wrapper, résolution de type, gestion variantes/niveaux.

**Tier 1 — référence**
3. Référence `CommuPrototype` (constructeur, `setLocalisedName`, `setLocalisedDescription`).
4. Utilitaires `core/functions.lua` + factory `core/class.lua`.
5. Pages stub 🚧 : cluster `localisedBuilder*` (marqué inachevé).

**Doc séparée — audience TRADUCTEUR** (objectif explicite de Ritn, à produire par la skill 3) :
un guide non-technique expliquant **comment traduire** — le fonctionnement des `.cfg` (format
`[type-name]` / `[type-description]`, nommage par mod) et de leurs **équivalents `.lua`** (quand et
pourquoi passer par un patch `mods/<mod>.lua`, forme de la table). But : donner à la personne qui
traduit (sans connaissance du modding) un support fiable pour ses mises à jour mensuelles. **Ne
documente pas le code interne** — c'est un mode d'emploi de traduction.

**Zones difficiles / notes de rédaction** (arbitrages faits, plus de refactor bloquant)
- `setLocalisedDescription` à niveaux : documenter le comportement **tel quel** — description identique
  à tous les niveaux, arrêt anticipé **voulu** (décision 4a).
- Cluster `localisedBuilder*` : **conservé** (décision 3a) → page stub 🚧 « fonctionnalité inachevée »,
  sans laisser croire que c'est actif.
- `ifElse`/`tryCatch` : documenter comme utilitaire vendoré de RitnLib, branche `tryCatch` **dormante**
  (décision 2a) — factuel, sans alerte « bug ».

## D. Décisions tranchées par Ritn (2026-07-12)

1. **Registre écosystème → NE PAS inscrire au canonique.** L'`ecosystem-map.md` reste **interne au mod**
   (`PatchFR/docs/audit/ecosystem-map.md`, entrée `hors-stack`) et sert de matière aux skills 2/3. Ne pas
   le fusionner dans `W:\git\Factorio\ecosystem-map.md`.
2. **`tryCatch` / `ifElse` → CONSERVER tel quel.** C'est un utilitaire **recopié de RitnLib**, gardé
   volontairement au cas où il servirait plus tard. La branche « fonction » de `ifElse` (qui appelle
   `tryCatch`) est **dormante** — ce n'est **pas un défaut**. Ne pas la retirer. La fonction `tryCatch`
   reste non définie tant que la branche n'est pas utilisée : à documenter/annoter factuellement comme
   dépendance dormante, sans rien corriger.
3. **Cluster `localisedBuilder*` → CONSERVER.** Tentative de fonctionnalité (insertion d'icônes
   `__ITEM__…__` dans les libellés) **non terminée, gardée exprès**. Statut = **beta / inachevé** (page
   stub 🚧), à annoter avec avertissement « non câblé / inachevé », pas à retirer.
4. **`setLocalisedDescription` à niveaux → COMPORTEMENT VOULU.** L'arrêt anticipé est intentionnel : la
   **description reste identique quel que soit le niveau** de la techno/variante. Ce **n'est pas un
   défaut** ; ne pas aligner sur `setLocalisedName`.
5. **Type-alias `mods/` → OUI, mais NON-INTRUSIF.** Créer **un seul** type-alias LuaLS partagé, défini à
   **un endroit central** (fichier meta/types dédié). **Ne PAS toucher les 106 fichiers `mods/*.lua`** :
   ils doivent rester propres pour le traducteur. Contrainte cardinale : l'annotation ne doit **jamais
   empiéter sur le travail de traduction** (pas de lignes ajoutées dans les tables de trad).
