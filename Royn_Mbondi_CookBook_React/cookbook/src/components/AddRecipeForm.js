import { useState } from 'react';



function AddRecipeForm({ onAjout, onFermer }) {

  const [formData, setFormData] = useState({
    nom: '',
    categorie: '',
    ingredients: '',
    instructions: '',
    image: ''
  });
  const [erreurs, setErreurs] = useState({});
  const [loading, setLoading] = useState(false);
  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData(prev => ({ ...prev, [name]: value }));
    if (erreurs[name]) {
      setErreurs(prev => ({ ...prev, [name]: '' }));
    }
  };
  const valider = () => {
    const nouvellesErreurs = {};
    if (!formData.nom.trim()) nouvellesErreurs.nom = 'veiller inserer le nom';
    if (!formData.ingredients.trim()) nouvellesErreurs.ingredients = 'au moins un ingredient';
    if (!formData.instructions.trim()) nouvellesErreurs.instructions = 'au moins une instruction';
    return nouvellesErreurs;
  };
  const handleSubmit = async () => {
    const nouvellesErreurs = valider();
    if (Object.keys(nouvellesErreurs).length > 0) {
      setErreurs(nouvellesErreurs);
      return;
    }

    setLoading(true);
    try {
      const nouvelleRecette = {
        nom: formData.nom,
        categorie: formData.categorie,
        ingredients: formData.ingredients.split('\n').filter(i => i.trim() !== ''),
        instructions: formData.instructions,
        
      };
      await onAjout(nouvelleRecette);
      onFermer();
    } catch (error) {
      setErreurs({ global: error.message });
    } finally {
      setLoading(false);
    }
  };

  return (
    <div style={styles.overlay} onClick={onFermer}>
      <div style={styles.modale} onClick={(e) => e.stopPropagation()}>
        <button style={styles.boutonFermer} onClick={onFermer}>✕</button>
        <h2 style={styles.titre}>Ajouter une recette</h2>

        {erreurs.global && (
          <div style={styles.erreurGlobale}>{erreurs.global}</div>
        )}

        <div style={styles.champ}>
          <label style={styles.label}>Nom de la recette *</label>
          <input
            style={{ ...styles.input, ...(erreurs.nom ? styles.inputErreur : {}) }}
            type="text"
            name="nom"
            value={formData.nom}
            onChange={handleChange}
            placeholder="entrer le nom"
          />
          {erreurs.nom && <p style={styles.erreur}>{erreurs.nom}</p>}
        </div>

        <div style={styles.champ}>
          <label style={styles.label}>Catégorie *</label>
          <select
            style={styles.input}
            name="categorie"
            value={formData.categorie}
            onChange={handleChange}
          >
            <option value="Entrées">Entrées</option>
            <option value="Plats">Plats</option>
            <option value="Desserts">Desserts</option>
          </select>
        </div>

        <div style={styles.champ}>
          <label style={styles.label}>Ingrédients * (un par ligne)</label>
          <textarea
            style={{ ...styles.textarea, ...(erreurs.ingredients ? styles.inputErreur : {}) }}
            name="ingredients"
            value={formData.ingredients}
            onChange={handleChange}
            placeholder={""}
            rows={4}
          />
          {erreurs.ingredients && <p style={styles.erreur}>{erreurs.ingredients}</p>}
        </div>
        <div style={styles.champ}>
          <label style={styles.label}>Instructions *</label>
          <textarea
            style={{ ...styles.textarea, ...(erreurs.instructions ? styles.inputErreur : {}) }}
            name="instructions"
            value={formData.instructions}
            onChange={handleChange}
            placeholder=""
            rows={5}
          />
          {erreurs.instructions && <p style={styles.erreur}>{erreurs.instructions}</p>}
        </div>

        
        
        <div style={styles.boutons}>
          <button style={styles.boutonAnnuler} onClick={onFermer}>
            Annuler
          </button>
          <button
            style={{ ...styles.boutonAjouter, opacity: loading ? 0.7 : 1 }}
            onClick={handleSubmit}
            disabled={loading}
          >
            {loading ? 'Ajout en cours...' : 'Ajouter la recette'}
          </button>
        </div>
      </div>
    </div>
  );
}

const styles = {
  overlay: {
    position: 'fixed',
    top: 0, left: 0, right: 0, bottom: 0,
    backgroundColor: 'rgba(0,0,0,0.6)',
    display: 'flex',
    justifyContent: 'center',
    alignItems: 'center',
    zIndex: 1000,
  },
  modale: {
    backgroundColor: 'white',
    borderRadius: '16px',
    width: '550px',
    maxWidth: '90vw',
    maxHeight: '90vh',
    overflowY: 'auto',
    padding: '30px',
    position: 'relative',
  },
  boutonFermer: {
    position: 'absolute',
    top: '15px',
    right: '15px',
    background: '#eee',
    border: 'none',
    borderRadius: '50%',
    width: '32px',
    height: '32px',
    cursor: 'pointer',
    fontSize: '14px',
  },
  titre: {
    fontSize: '22px',
    fontWeight: 'bold',
    color: '#222',
    margin: '0 0 25px 0',
  },
  champ: {
    marginBottom: '18px',
  },
  label: {
    display: 'block',
    fontSize: '14px',
    fontWeight: '600',
    color: '#444',
    marginBottom: '6px',
  },
  input: {
    width: '100%',
    padding: '10px 12px',
    borderRadius: '8px',
    border: '1px solid #ddd',
    fontSize: '14px',
    boxSizing: 'border-box',
    outline: 'none',
  },
  textarea: {
    width: '100%',
    padding: '10px 12px',
    borderRadius: '8px',
    border: '1px solid #ddd',
    fontSize: '14px',
    boxSizing: 'border-box',
    resize: 'vertical',
    outline: 'none',
    fontFamily: 'inherit',
  },
  inputErreur: {
    borderColor: '#e53e3e',
  },
  erreur: {
    color: '#e53e3e',
    fontSize: '12px',
    margin: '4px 0 0 0',
  },
  erreurGlobale: {
    backgroundColor: '#fff5f5',
    color: '#e53e3e',
    padding: '10px',
    borderRadius: '8px',
    marginBottom: '15px',
    fontSize: '14px',
  },
  boutons: {
    display: 'flex',
    justifyContent: 'flex-end',
    gap: '10px',
    marginTop: '10px',
  },
  boutonAnnuler: {
    backgroundColor: 'white',
    color: '#666',
    border: '1px solid #ddd',
    borderRadius: '25px',
    padding: '10px 20px',
    cursor: 'pointer',
    fontSize: '14px',
  },
  boutonAjouter: {
    backgroundColor: '#f97509',
    color: 'white',
    border: 'none',
    borderRadius: '25px',
    padding: '10px 25px',
    cursor: 'pointer',
    fontWeight: 'bold',
    fontSize: '14px',
  }
};

export default AddRecipeForm;
