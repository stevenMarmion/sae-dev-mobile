class Utilisateur {
  int? identifiantUtilisateur;
  String? nom;
  String? prenom;
  int? age;
  String? adresseMail;
  String? mdp;
  String? pseudo;
  int? token;

  Utilisateur(
    this.identifiantUtilisateur,
    this.nom,
    this.prenom,
    this.age,
    this.adresseMail,
    this.mdp,
    this.pseudo,
    this.token,
  );

  int? get getIdentifiantUtilisateur => identifiantUtilisateur;
  set setIdentifiantUtilisateur(int? id) => identifiantUtilisateur = id;

  String? get getNom => nom;
  set setNom(String? name) => nom = name;

  String? get getPrenom => prenom;
  set setPrenom(String? name) => prenom = name;

  int? get getAge => age;
  set setAge(int? userAge) => age = userAge;

  String? get getAdresseMail => adresseMail;
  set setAdresseMail(String? email) => adresseMail = email;

  String? get getMdp => mdp;
  set setMdp(String? password) => mdp = password;

  String? get getPseudo => pseudo;
  set setPseudo(String? username) => pseudo = username;

  int? get getToken => token;
  set setToken(int? userToken) => token = userToken;

  Utilisateur.fromJson(Map<String, dynamic> json) {
    identifiantUtilisateur = json['identifiantutilisateur'];
    nom = json['nomu'];
    prenom = json['prenomu'];
    age = json['ageu'];
    adresseMail = json['adressemailu'];
    mdp = json['mdpu'];
    pseudo = json['pseudou'];
    token = int.parse(json['token']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['identifiantutilisateur'] = identifiantUtilisateur;
    data['nomu'] = nom;
    data['prenomu'] = prenom;
    data['ageu'] = age;
    data['adressemail'] = adresseMail;
    data['mdpu'] = mdp;
    data['pseudou'] = pseudo;
    data['token'] = token;
    return data;
  }
}
