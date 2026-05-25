

const DB_KEY = 'cookbook_recettes';

const initData = () => {
  if (!localStorage.getItem(DB_KEY)) {
    const defaultRecettes = [
      {
      id: 1,
      nom: "salade rouge",
      categorie: "Entrées",
      ingredients: [" choux rouge","Carottes","4 tomates"],
      instructions: "pas necessaire de faire cuire",
      image: "./image/OIP.jpg"
    },
       {
      id: 2,
      nom: "crudité",
      categorie: "Entrées",
      ingredients: ["choux ","tomate","Carottes","oignons"],
      instructions: "pas necessaire de faire cuire",
      image: "./image/OIP.jpg"
    },
    {
      id: 3,
      nom: "pommes sauter",
      categorie: "Plats",
      ingredients: ["pommes de terre","huille","viande","condiment"],
      instructions: "faire cuire pendant 45min",
      image: "./image/OIP.jpg"
    },
    {
      id: 4,
      nom: "eru",
      categorie: "Plats",
      ingredients: ["feuille de eru","viande","huile rouge"],
      instructions: "faire cuire pendant 45min",
      image: "./image/OIP.jpg"
    },
    {
      id: 5,
      nom: "gateau",
      categorie: "Desserts",
      ingredients: ["farine","sucre","lait"],
      instructions: "faire cuire au foure",
      image: "./image/OIP.jpg"
    },
    {
      id: 6,
      nom: "fuits",
      categorie: "Desserts",
      ingredients: ["pasteque","ananas","raisin"],
      instructions: "pas necessaire de faire cuire",
      image: "./image/OIP.jpg"
    }
  ]
}

  
    localStorage.setItem(DB_KEY, JSON.stringify(defaultRecettes));
  }

export const getRecettes = () => {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      try {
        initData();
        const recettes = JSON.parse(localStorage.getItem(DB_KEY));
        resolve(recettes);
      } catch (error) {
        reject(new Error("Erreur lors du chargement des recettes"));
      }
    }, 600); 
  });
};


export const getRecetteById = (id) => {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      try {
        const recettes = JSON.parse(localStorage.getItem(DB_KEY));
        const recette = recettes.find(r => r.id === id);
        if (recette) {
          resolve(recette);
        } else {
          reject(new Error("Recette non trouvée"));
        }
      } catch (error) {
        reject(new Error("Erreur lors du chargement de la recette"));
      }
    }, 300);
  });
};


export const addRecette = (nouvelleRecette) => {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      try {
        const recettes = JSON.parse(localStorage.getItem(DB_KEY));
        const newId = recettes.length > 0 ? Math.max(...recettes.map(r => r.id)) + 1 : 1;
        const recetteAvecId = { ...nouvelleRecette, id: newId };
        recettes.push(recetteAvecId);
        localStorage.setItem(DB_KEY, JSON.stringify(recettes));
        resolve(recetteAvecId);
      } catch (error) {
        reject(new Error("Erreur lors de l'ajout de la recette"));
      }
    }, 400);
  });
};
