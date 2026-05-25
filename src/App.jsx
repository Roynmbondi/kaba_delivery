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
    try {
      const recetteAjoutee = await addRecette(nouvelleRecette);
      setRecettes(prev => [...prev, recetteAjoutee]);
      setShowForm(false);
    } catch (err) {
      setErreur(err.message);
    }
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
          <h2 style={styles.titrePrincipal}>KABA-DELIVERY - Gestion des Livraisons</h2>
          <hr style={styles.separateur} />

          <input
            style={styles.recherche}
            type="text"
            placeholder="Chercher une livraison..."
            value={recherche}
            onChange={(e) => setRecherche(e.target.value)}
          />

          {loading && (
            <div style={styles.message}>
              <div style={styles.spinner}></div>
              <p>Chargement des données...</p>
            </div>
          )}

          {erreur && (
            <div style={styles.erreur}>
              <p>❌ {erreur}</p>
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
    backgroundColor: '#f5f7fa',
    fontFamily: 'Segoe UI, Tahoma, Geneva, Verdana, sans-serif',
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
    fontSize: '28px',
    fontWeight: 'bold',
    color: '#2c3e50',
    margin: '0 0 10px 0',
    textAlign: 'center',
  },
  separateur: {
    border: 'none',
    borderTop: '3px solid #3498db',
    margin: '0 0 25px 0',
  },
  recherche: {
    width: '400px',
    maxWidth: '100%',
    padding: '12px 16px',
    borderRadius: '25px',
    border: '2px solid #3498db',
    fontSize: '14px',
    outline: 'none',
    marginBottom: '25px',
    backgroundColor: 'white',
    display: 'block',
    margin: '0 auto 25px auto',
  },
  message: {
    textAlign: 'center',
    color: '#7f8c8d',
    padding: '40px',
  },
  spinner: {
    width: '40px',
    height: '40px',
    border: '4px solid #ecf0f1',
    borderTop: '4px solid #3498db',
    borderRadius: '50%',
    animation: 'spin 1s linear infinite',
    margin: '0 auto 10px',
  },
  erreur: {
    backgroundColor: '#fff5f5',
    border: '2px solid #e74c3c',
    borderRadius: '8px',
    padding: '20px',
    textAlign: 'center',
    color: '#c0392b',
    margin: '20px auto',
    maxWidth: '500px',
  },
  boutonReessayer: {
    marginTop: '10px',
    backgroundColor: '#e74c3c',
    color: 'white',
    border: 'none',
    borderRadius: '20px',
    padding: '10px 25px',
    cursor: 'pointer',
    fontSize: '14px',
    fontWeight: 'bold',
  }
};

export default App;