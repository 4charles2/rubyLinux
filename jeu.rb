class Personne
  attr_accessor :nom, :points_de_vie, :en_vie

  def initialize(nom)
    @nom = nom
    @points_de_vie = 100
    @en_vie = true
  end

  def info
    # A faire:
	  if en_vie == true
		return "#{nom} a #{points_de_vie} points de vie."
		# - Renvoie le nom et les points de vie si la personne est en vie
	else
		return "#{nom} vaincu"
    # - Renvoie le nom et "vaincu" si la personne a ete vaincue
	end
  end

  def attaque(personne)
    # A faire:
	  if personne.en_vie == true
		  puts "#{self.nom} Attaque #{personne.nom}"
		  personne.subit_attaque(self.degats)
	  else
		  puts "vous ne pouvez pas attaquer car #{personne.nom} est mort"
	  end
    # - Fait subir des degats à la personne passee en paramètre
    # - Affiche ce qu'il s'est passe
  end

  def subit_attaque(degats_recus)
    # A faire:
    # - Reduit les points de vie en fonction des degats reçus
	  self.points_de_vie -= degats_recus
    # - Affiche ce qu'il s'est passe
	  puts "#{self.nom} perd #{degats_recus} points de vie"
	  if self.points_de_vie > 1
		  self.en_vie = true
	  else
		self.en_vie = false
	  end	
		  # - Determine si la personne est toujours en_vie ou non
  end
end

class Joueur < Personne
  attr_accessor :degats_bonus

  def initialize(nom)
    # Par defaut le joueur n'a pas de degats bonus
    @degats_bonus = 0

    # Appelle le "initialize" de la classe mère (Personne)
    super(nom)
  end

  def degats
    # A faire:
	  force = degats_bonus + 80
      	  # - Calculer les degats
	  puts "#{self.nom} a une force de #{force}"
    # - Affiche ce qu'il s'est passe
	return force
  end

  def soin
    # A faire:
	  self.points_de_vie += 50
    # - Gagner de la vie
	puts "#{self.nom} recupere 50 points de vie"
    # - Affiche ce qu'il s'est passe
  end

  def ameliorer_degats
    # A faire:
	  self.degats_bonus += 10
    # - Augmenter les degats bonus
	  puts "#{self.nom} augmente sa force de 10 points"
    # - Affiche ce qu'il s'est passe
  end
end

class Ennemi < Personne
  def degats
    # A faire:
	 return 10
    # - Calculer les degats
  end
end

class Jeu
  def self.actions_possibles(monde)
    puts "ACTIONS POSSIBLES :"

    puts "0 - Se soigner"
    puts "1 - Ameliorer son attaque"

    # On commence à 2 car 0 et 1 sont reserves pour les actions
    # de soin et d'amelioration d'attaque
    i = 2
    monde.ennemis.each do |ennemi|
      puts "#{i} - Attaquer #{ennemi.info}"
      i = i + 1
    end
    puts "99 - Quitter"
  end

  def self.est_fini(joueur, monde)
    # A faire:
	  adversaire = 0
	  monde.ennemis.each do |ennemi|
		  adversaire += 1 if ennemi.en_vie
	  end
	if joueur.en_vie == false || adversaire == 0 
    # - Determiner la condition de fin du jeu
		return true
	else
		return false
  	end
  end
end

class Monde
	attr_accessor :ennemis 

	def ennemis_en_vie
		# creation d'un tableau vide où seront stockés les ennemis en vie
		ennemis_vivant = []
		# on boucle sur le tableau des ennemis
		ennemis.each do |ennemi|
			if ennemi.en_vie == true
			ennemis_vivant << ennemi
			end
		end
		#Je retourne le tableau avec les ennemis encore vivant
		return ennemis_vivant
	end
end

##############

# Initialisation du monde
monde = Monde.new

# Ajout des ennemis
monde.ennemis = [
  Ennemi.new("Balrog"),
  Ennemi.new("Goblin"),
  Ennemi.new("Squelette")
]

# Initialisation du joueur
joueur = Joueur.new("Jean-Michel Paladin")

# Message d'introduction. \n signifie "retour à la ligne"
puts "\n\nAinsi debutent les aventures de #{joueur.nom}\n\n"

# Boucle de jeu principale
100.times do |tour|
  puts "\n------------------ Tour numero #{tour} ------------------"

  # Affiche les differentes actions possibles
  Jeu.actions_possibles(monde)

  puts "\nQUELLE ACTION FAIRE ?"
  # On range dans la variable "choix" ce que l'utilisateur renseigne
  choix = gets.chomp.to_i

  # En fonction du choix on appelle differentes methodes sur le joueur
  if choix == 0
    joueur.soin
  elsif choix == 1
    joueur.ameliorer_degats
  elsif choix == 99
    # On quitte la boucle de jeu si on a choisi
    # 99 qui veut dire "quitter"
    break
  else
    # Choix - 2 car nous avons commence à compter à partir de 2
    # car les choix 0 et 1 etaient reserves pour le soin et
    # l'amelioration d'attaque
    ennemi_a_attaquer = monde.ennemis[choix - 2]
    joueur.attaque(ennemi_a_attaquer)
  end

  puts "\nLES ENNEMIS RIPOSTENT !"
  # Pour tous les ennemis en vie ...
  monde.ennemis_en_vie.each do |ennemi|
    # ... le hero subit une attaque.
    ennemi.attaque(joueur)
  end

  puts "\nEtat du hero: #{joueur.info}\n"

  # Si le jeu est fini, on interompt la boucle
  break if Jeu.est_fini(joueur, monde)
end

puts "\nGame Over!\n"

# A faire:
# - Afficher le resultat de la partie

if joueur.en_vie
  puts "Vous avez gagne !"
else
  puts "Vous avez perdu !"
end
