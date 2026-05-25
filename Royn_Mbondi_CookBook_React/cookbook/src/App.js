import { useState, useEffect } from 'react';
import Header from './components/Header';
import Sidebar from './components/Sidebar';
import RecipeList from './components/RecipeList';
import RecipeDetail from './components/RecipeDetail';
import AddRecipeForm from './components/AddRecipeForm';
import { getRecettes, addRecette } from './services/recetteService';


function App() {
  const [recettes, setRecettes] = useState([]);          
  const [categorieActive, setCategorieActive] = useState('Toutes'); 
  const [recetteActive, setRecetteActive] = useState(null); 
  const [recherche, setRecherche] = useState('');           
  const [loading, setLoading] = useState(true);             
  const [erreur, setErreur] = useState(null);              
  const [showForm, setShowForm] = useState(false);          

  useEffect(() => {
    chargerRecettes();
  }, []);

  const chargerRecettes = async () => {
    setLoading(true);
    setErreur(null);
    try {
      const data = await getRecettes();
      setRecettes(data);
    } catch (err) {
      setErreur(err.message);
    } finally {
      setLoading(false);
    }
  };

  const categories = [...new Set(recettes.map(r => r.categorie))];

  const recettesFiltrees = recettes.filter(recette => {
    const matchCategorie = categorieActive === 'Toutes' || recette.categorie === categorieActive;
    const matchRecherche = recette.nom.toLowerCase().includes(recherche.toLowerCase());
    return matchCategorie && matchRecherche;
  });

  const handleAjout = async (nouvelleRecette) => {
    const recetteAjoutee = await addRecette(nouvelleRecette);
    setRecettes(prev => [...prev, recetteAjoutee]);
  };

  return (
    <div style={styles.app}>
      <Header onAjouterClick={() => setShowForm(true)} />

      <div style={styles.corps}>
        
        <Sidebar
          categories={categories}
          categorieActive={categorieActive}
          onCategorieSelect={setCategorieActive}
          recettes={recettes}
        />

        
        <main style={styles.principal}>
          <h2 style={styles.titrePrincipal}>Toutes les recettes</h2>
          <hr style={styles.separateur} />

          
          <input
            style={styles.recherche}
            type="text"
            placeholder="Chercher une recette..."
            value={recherche}
            onChange={(e) => setRecherche(e.target.value)}
          />

          
          {loading && (
            <div style={styles.message}>
              <div style={styles.spinner}></div>
              <p>Chargement des recettes...</p>
            </div>
          )}

          {erreur && (
            <div style={styles.erreur}>
              <p> {erreur}</p>
              <button style={styles.boutonReessayer} onClick={chargerRecettes}>
                Réessayer
              </button>
            </div>
          )}

          
          {!loading && !erreur && (
            <RecipeList
              recettes={recettesFiltrees}
              onVoirDetail={setRecetteActive}
            />
          )}
        </main>
      </div>

      
      {recetteActive && (
        <RecipeDetail
          recette={recetteActive}
          onFermer={() => setRecetteActive(null)}
        />
      )}

      
      {showForm && (
        <AddRecipeForm
          onAjout={handleAjout}
          onFermer={() => setShowForm(false)}
        />
      )}
    </div>
  );
}

const styles = {
  app: {
    minHeight: '100vh',
    backgroundColor: '#f9f5f0',
    fontFamily: 'Segoe UI, sans-serif',
  },
  corps: {
    display: 'flex',
    minHeight: 'calc(100vh - 60px)',
  },
  principal: {
    flex: 1,
    padding: '30px',
    overflowY: 'auto',
  },
  titrePrincipal: {
    fontSize: '26px',
    fontWeight: 'bold',
    color: '#222',
    margin: '0 0 10px 0',
  },
  separateur: {
    border: 'none',
    borderTop: '2px solid #222',
    margin: '0 0 25px 0',
  },
  recherche: {
    width: '350px',
    maxWidth: '100%',
    padding: '12px 16px',
    borderRadius: '25px',
    border: '1px solid #ddd',
    fontSize: '14px',
    outline: 'none',
    marginBottom: '25px',
    backgroundColor: 'white',
    display: 'block',
  },
  message: {
    textAlign: 'center',
    color: '#999',
    padding: '40px',
  },
  spinner: {
    width: '40px',
    height: '40px',
    border: '4px solid #f0e8d8',
    borderTop: '4px solid #f66c0a',
    borderRadius: '50%',
    animation: 'spin 1s linear infinite',
    margin: '0 auto 10px',
  },
  erreur: {
    backgroundColor: '#fff5f5',
    border: '1px solid #feb2b2',
    borderRadius: '8px',
    padding: '20px',
    textAlign: 'center',
    color: '#e53e3e',
  },
  boutonReessayer: {
    marginTop: '10px',
    backgroundColor: '#f57011',
    color: 'white',
    border: 'none',
    borderRadius: '20px',
    padding: '8px 20px',
    cursor: 'pointer',
  }
};

export default App;
