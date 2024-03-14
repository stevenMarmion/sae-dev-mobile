# SAE DEV MOBILE

## Membres

MARMION Steven  
SIMMON Gael

## - Principe de focntionnement

2.1 J’ai un compte (ou je m’en crée un) et je suis clairement authentifié sur la base principale commune à
tous les étudiants.

2.2 Deux cas de figure se proposent à moi :

- J’ai  besoin d’aide ! (demandeur) :
  - j’écris une annonce depuis l’application mobile en précisant la catégorie de l’objet recherché (outillage, info, etc.)
  - je la stocke localement sur mon smartphone
  - je la diffuse à tous les utilisateurs sur la base centrale => mon annonce est ouverte
  - je vérifie si mon annonce est pourvue sur la base centrale
  - je valide le prêt de l’objet et j’alimente ma page «Réservations»
  - à la fin du prêt, je clôture mon annonce sur la base centrale
  - je peux donner mon avis sur le prêteur et son bien

- Je peux venir en aide (prêteur) :
  - je sais ce que je possède
  - mes biens sont enregistrés sur mon smartphone, rangés par catégorie (outillage, info, etc.)
  - après consultation des annonces, je décide de répondre à une annonce pour venir en aide => l’annonce est pourvue
  - j’alimente ma page «Mes prêts»
  - mon bien est réservé et n’est plus disponible sur mon smartphone pendant la période
  - à la clôture de l’annonce  mon bien redevient disponible et disparaît de la page «Mes prêts»
  - je peux donner faire un retour sur le demandeur vis-à-vis de mon bien

2.3  Les rôles peuvent évidemment s’inverser : le demandeur peut parfois prêter un de ses biens et le
prêteur peut aussi avoir besoin d’aide.

2.4 En tant que demandeur, je dois disposer d’un écran qui me permet de voir mes réservations en cours
ou bien celles dont la date de fin est dépassée et non clôturée.

2.5 En tant que prêteur, je dois disposer d’un écran qui me permet de voir mes prêts en cours.

## Contraintes

- Utilisation  de supabase® pour la base principale, support à l’authentification et au stockage des annonces (demandes et ou offres, photos), des avis sur les acteurs du prêt et au stockage des photos :  
<https://supabase.com/>

- Utilisation des Shared Preferences et/ou sqflite (plugins Flutter® ) pour stocker de petites quantités d’information localement sur votre smartphone en lien avec mes annonces, les biens et les évènements de l’agenda :  
<https://pub.dev/packages/sqflite>  
<https://docs.flutter.dev/cookbook/persistence/sqlite>

- Gestion des états d’une annonce (ouverte, pourvue, clôturée, etc.)
- Gestion des états d’un bien (disponible, réservé, libéré, etc.)
- Gestion des états d’un prêt (en cours, en retard, à rendre, etc.)
- Mise en place d’une navigation cohérente et ergonomique via go_router si nécessaire :  
<https://docs.flutter.dev/ui/navigation>  
<https://fluttergems.dev/routing/>

## Documentation

- Modèle Conceptuel de Données pour les BDD (centrale et locale)
- Diagramme d’états de vos objets
- Diagramme des classes de ces objets
