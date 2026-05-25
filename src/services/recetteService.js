// Service de gestion des livraisons KABA-DELIVERY
const DB_KEY = 'kaba_delivery_livraisons';

const initData = () => {
  if (!localStorage.getItem(DB_KEY)) {
    const defaultLivraisons = [
      {
        id: 1,
        nom: "Livraison Documents Urgents",
        categorie: "Express",
        ingredients: ["Contrats commerciaux", "Factures", "Documents légaux"],
        instructions: "Livraison en main propre uniquement. Demander une pièce d'identité.",
        client: "SARL DOUALA BUSINESS",
        phone: "+237 677 123 456",
        address: "Akwa, Rue Joss, Immeuble CCEI Bank, 3ème étage",
        status: "En cours",
        priority: "Urgent",
        estimatedTime: "15 min",
        cost: "3,500 FCFA",
        driver: "Jean-Paul MBONDI",
        vehicle: "Moto - DLA 234"
      },
      {
        id: 2,
        nom: "Colis E-commerce",
        categorie: "Standard",
        ingredients: ["Smartphone Samsung", "Accessoires", "Chargeur"],
        instructions: "Vérifier l'état du colis avant remise",
        client: "Marie NGONO",
        phone: "+237 698 765 432",
        address: "Bonapriso, Carrefour Elf, Résidence Les Palmiers",
        status: "En attente",
        priority: "Normal",
        estimatedTime: "45 min",
        cost: "2,000 FCFA",
        driver: "Paul ETAME",
        vehicle: "Scooter - DLA 567"
      },
      {
        id: 3,
        nom: "Médicaments Urgents",
        categorie: "Express",
        ingredients: ["Antibiotiques", "Antalgiques", "Ordonnance"],
        instructions: "Livraison prioritaire - Patient en attente",
        client: "Hôpital Général de Douala",
        phone: "+237 233 42 34 56",
        address: "Deido, Avenue de la Liberté, Service Urgences",
        status: "Livré",
        priority: "Très Urgent",
        estimatedTime: "10 min",
        cost: "5,000 FCFA",
        driver: "Alice FOUDA",
        vehicle: "Moto - DLA 890"
      },
      {
        id: 4,
        nom: "Échantillons Produits",
        categorie: "Économique",
        ingredients: ["Échantillons cosmétiques", "Catalogue", "Carte de visite"],
        instructions: "Remise possible au gardien si absent",
        client: "Beauty Store Cameroun",
        phone: "+237 655 987 321",
        address: "Bonanjo, Rue Franqueville, Centre Commercial",
        status: "En cours",
        priority: "Normal",
        estimatedTime: "1h 30min",
        cost: "1,500 FCFA",
        driver: "Michel BIYA",
        vehicle: "Vélo - Eco 123"
      },
      {
        id: 5,
        nom: "Repas Livraison",
        categorie: "Express",
        ingredients: ["Poulet DG", "Riz sauté", "Boisson", "Dessert"],
        instructions: "Maintenir au chaud - Client au bureau",
        client: "Cabinet d'Avocat NKOMO",
        phone: "+237 677 456 789",
        address: "Akwa, Immeuble Administratif, Bureau 205",
        status: "En cours",
        priority: "Normal",
        estimatedTime: "25 min",
        cost: "2,500 FCFA",
        driver: "Sophie MANGA",
        vehicle: "Moto - DLA 345"
      },
      {
        id: 6,
        nom: "Pièces Auto",
        categorie: "Programmée",
        ingredients: ["Plaquettes de frein", "Huile moteur", "Filtre à air"],
        instructions: "Livraison prévue pour 14h - Garage TOTAL",
        client: "Garage Moderne Douala",
        phone: "+237 699 123 456",
        address: "Bassa, Route de l'Aéroport, Zone Industrielle",
        status: "En attente",
        priority: "Normal",
        estimatedTime: "2h",
        cost: "3,000 FCFA",
        driver: "En attente d'assignation",
        vehicle: "Camionnette - DLA 678"
      }
    ];
    localStorage.setItem(DB_KEY, JSON.stringify(defaultLivraisons));
  }
};

// Simulation d'API avec délais réalistes
export const getRecettes = () => {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      try {
        initData();
        const livraisons = JSON.parse(localStorage.getItem(DB_KEY));
        resolve(livraisons);
      } catch (error) {
        reject(new Error("Erreur lors du chargement des livraisons"));
      }
    }, 800); // Simulation latence réseau
  });
};

export const getRecetteById = (id) => {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      try {
        const livraisons = JSON.parse(localStorage.getItem(DB_KEY));
        const livraison = livraisons.find(l => l.id === id);
        if (livraison) {
          resolve(livraison);
        } else {
          reject(new Error("Livraison non trouvée"));
        }
      } catch (error) {
        reject(new Error("Erreur lors du chargement de la livraison"));
      }
    }, 300);
  });
};

export const addRecette = (nouvelleLivraison) => {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      try {
        const livraisons = JSON.parse(localStorage.getItem(DB_KEY));
        const newId = livraisons.length > 0 ? Math.max(...livraisons.map(l => l.id)) + 1 : 1;
        
        // Génération automatique d'un ID de livraison
        const deliveryId = 'KD-' + Math.random().toString(36).substr(2, 9).toUpperCase();
        
        const livraisonAvecId = { 
          ...nouvelleLivraison, 
          id: newId,
          deliveryId: deliveryId,
          createdAt: new Date().toISOString(),
          updatedAt: new Date().toISOString()
        };
        
        livraisons.push(livraisonAvecId);
        localStorage.setItem(DB_KEY, JSON.stringify(livraisons));
        resolve(livraisonAvecId);
      } catch (error) {
        reject(new Error("Erreur lors de l'ajout de la livraison"));
      }
    }, 600);
  });
};

export const updateRecette = (id, updatedData) => {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      try {
        const livraisons = JSON.parse(localStorage.getItem(DB_KEY));
        const index = livraisons.findIndex(l => l.id === id);
        
        if (index !== -1) {
          livraisons[index] = { 
            ...livraisons[index], 
            ...updatedData, 
            updatedAt: new Date().toISOString() 
          };
          localStorage.setItem(DB_KEY, JSON.stringify(livraisons));
          resolve(livraisons[index]);
        } else {
          reject(new Error("Livraison non trouvée"));
        }
      } catch (error) {
        reject(new Error("Erreur lors de la mise à jour de la livraison"));
      }
    }, 400);
  });
};

export const deleteRecette = (id) => {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      try {
        const livraisons = JSON.parse(localStorage.getItem(DB_KEY));
        const filteredLivraisons = livraisons.filter(l => l.id !== id);
        
        if (filteredLivraisons.length < livraisons.length) {
          localStorage.setItem(DB_KEY, JSON.stringify(filteredLivraisons));
          resolve({ message: "Livraison supprimée avec succès" });
        } else {
          reject(new Error("Livraison non trouvée"));
        }
      } catch (error) {
        reject(new Error("Erreur lors de la suppression de la livraison"));
      }
    }, 300);
  });
};

// Fonction utilitaire pour les statistiques
export const getDeliveryStats = () => {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      try {
        const livraisons = JSON.parse(localStorage.getItem(DB_KEY)) || [];
        const stats = {
          total: livraisons.length,
          enCours: livraisons.filter(l => l.status === 'En cours').length,
          enAttente: livraisons.filter(l => l.status === 'En attente').length,
          livrees: livraisons.filter(l => l.status === 'Livré').length,
          urgent: livraisons.filter(l => l.priority === 'Urgent' || l.priority === 'Très Urgent').length
        };
        resolve(stats);
      } catch (error) {
        reject(new Error("Erreur lors du calcul des statistiques"));
      }
    }, 200);
  });
};