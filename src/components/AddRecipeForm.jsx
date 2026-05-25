import { useState } from 'react';

function AddRecipeForm({ onAjout, onFermer }) {
  const [formData, setFormData] = useState({
    nom: '',
    categorie: 'Express',
    ingredients: '',
    instructions: '',
    client: '',
    phone: '',
    address: '',
    priority: 'Normal'
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
    if (!formData.nom.trim()) nouvellesErreurs.nom = 'Le nom de la livraison est requis';
    if (!formData.client.trim()) nouvellesErreurs.client = 'Le nom du client est requis';
    if (!formData.phone.trim()) nouvellesErreurs.phone = 'Le numéro de téléphone est requis';
    if (!formData.address.trim()) nouvellesErreurs.address = 'L\'adresse de livraison est requise';
    if (!formData.ingredients.trim()) nouvellesErreurs.ingredients = 'Au moins un article est requis';
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
      const nouvelleLivraison = {
        nom: formData.nom,
        categorie: formData.categorie,
        ingredients: formData.ingredients.split('\n').filter(i => i.trim() !== ''),
        instructions: formData.instructions,
        client: formData.client,
        phone: formData.phone,
        address: formData.address,
        priority: formData.priority,
        status: 'En attente',
        estimatedTime: '30-45 min',
        cost: Math.floor(Math.random() * 5000) + 1500 + ' FCFA'
      };
      await onAjout(nouvelleLivraison);
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
        
        <div style={styles.header}>
          <h2 style={styles.titre}>🚚 Nouvelle Livraison KABA-DELIVERY</h2>
        </div>

        <div style={styles.contenu}>
          {erreurs.global && (
            <div style={styles.erreurGlobale}>❌ {erreurs.global}</div>
          )}

          <div style={styles.section}>
            <h3 style={styles.sousTitre}>📦 Informations de la Livraison</h3>
            
            <div style={styles.champGroupe}>
              <div style={styles.champ}>
                <label style={styles.label}>Nom de la livraison *</label>
                <input
                  style={{ ...styles.input, ...(erreurs.nom ? styles.inputErreur : {}) }}
                  type="text"
                  name="nom"
                  value={formData.nom}
                  onChange={handleChange}
                  placeholder="Ex: Livraison documents urgents"
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
                  <option value="Express">Express (< 1h)</option>
                  <option value="Standard">Standard (1-3h)</option>
                  <option value="Économique">Économique (3-6h)</option>
                  <option value="Programmée">Programmée</option>
                </select>
              </div>
            </div>

            <div style={styles.champ}>
              <label style={styles.label}>Articles à livrer * (un par ligne)</label>
              <textarea
                style={{ ...styles.textarea, ...(erreurs.ingredients ? styles.inputErreur : {}) }}
                name="ingredients"
                value={formData.ingredients}
                onChange={handleChange}
                placeholder="Ex:&#10;Documents contractuels&#10;Échantillons produits&#10;Colis fragile"
                rows={4}
              />
              {erreurs.ingredients && <p style={styles.erreur}>{erreurs.ingredients}</p>}
            </div>

            <div style={styles.champ}>
              <label style={styles.label}>Priorité</label>
              <select
                style={styles.input}
                name="priority"
                value={formData.priority}
                onChange={handleChange}
              >
                <option value="Normal">Normal</option>
                <option value="Urgent">Urgent</option>
                <option value="Très Urgent">Très Urgent</option>
              </select>
            </div>
          </div>

          <div style={styles.section}>
            <h3 style={styles.sousTitre}>👤 Informations Client</h3>
            
            <div style={styles.champGroupe}>
              <div style={styles.champ}>
                <label style={styles.label}>Nom du client *</label>
                <input
                  style={{ ...styles.input, ...(erreurs.client ? styles.inputErreur : {}) }}
                  type="text"
                  name="client"
                  value={formData.client}
                  onChange={handleChange}
                  placeholder="Nom complet du client"
                />
                {erreurs.client && <p style={styles.erreur}>{erreurs.client}</p>}
              </div>

              <div style={styles.champ}>
                <label style={styles.label}>Téléphone *</label>
                <input
                  style={{ ...styles.input, ...(erreurs.phone ? styles.inputErreur : {}) }}
                  type="tel"
                  name="phone"
                  value={formData.phone}
                  onChange={handleChange}
                  placeholder="+237 6XX XXX XXX"
                />
                {erreurs.phone && <p style={styles.erreur}>{erreurs.phone}</p>}
              </div>
            </div>

            <div style={styles.champ}>
              <label style={styles.label}>Adresse de livraison *</label>
              <textarea
                style={{ ...styles.textarea, ...(erreurs.address ? styles.inputErreur : {}) }}
                name="address"
                value={formData.address}
                onChange={handleChange}
                placeholder="Adresse complète avec points de repère"
                rows={3}
              />
              {erreurs.address && <p style={styles.erreur}>{erreurs.address}</p>}
            </div>
          </div>

          <div style={styles.section}>
            <h3 style={styles.sousTitre}>📝 Instructions Spéciales</h3>
            <div style={styles.champ}>
              <textarea
                style={styles.textarea}
                name="instructions"
                value={formData.instructions}
                onChange={handleChange}
                placeholder="Instructions particulières pour le livreur (optionnel)"
                rows={3}
              />
            </div>
          </div>

          <div style={styles.boutons}>
            <button style={styles.boutonAnnuler} onClick={onFermer}>
              ❌ Annuler
            </button>
            <button
              style={{ ...styles.boutonAjouter, opacity: loading ? 0.7 : 1 }}
              onClick={handleSubmit}
              disabled={loading}
            >
              {loading ? '⏳ Création en cours...' : '✅ Créer la Livraison'}
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}

const styles = {
  overlay: {
    position: 'fixed',
    top: 0, left: 0, right: 0, bottom: 0,
    backgroundColor: 'rgba(0,0,0,0.7)',
    display: 'flex',
    justifyContent: 'center',
    alignItems: 'center',
    zIndex: 1000,
    padding: '20px',
  },
  modale: {
    backgroundColor: 'white',
    borderRadius: '20px',
    width: '800px',
    maxWidth: '95vw',
    maxHeight: '90vh',
    overflowY: 'auto',
    position: 'relative',
    boxShadow: '0 10px 30px rgba(0,0,0,0.3)',
  },
  boutonFermer: {
    position: 'absolute',
    top: '15px',
    right: '15px',
    background: 'rgba(255,255,255,0.2)',
    color: 'white',
    border: 'none',
    borderRadius: '50%',
    width: '35px',
    height: '35px',
    cursor: 'pointer',
    fontSize: '16px',
    zIndex: 10,
    fontWeight: 'bold',
  },
  header: {
    background: 'linear-gradient(135deg, #3498db, #2980b9)',
    padding: '25px',
    color: 'white',
    borderRadius: '20px 20px 0 0',
  },
  titre: {
    fontSize: '24px',
    fontWeight: 'bold',
    margin: 0,
  },
  contenu: {
    padding: '30px',
  },
  section: {
    marginBottom: '25px',
    padding: '20px',
    backgroundColor: '#f8f9fa',
    borderRadius: '10px',
  },
  sousTitre: {
    fontSize: '18px',
    fontWeight: 'bold',
    color: '#2c3e50',
    margin: '0 0 20px 0',
  },
  champGroupe: {
    display: 'grid',
    gridTemplateColumns: '1fr 1fr',
    gap: '20px',
    marginBottom: '20px',
  },
  champ: {
    marginBottom: '20px',
  },
  label: {
    display: 'block',
    fontSize: '14px',
    fontWeight: '600',
    color: '#2c3e50',
    marginBottom: '8px',
  },
  input: {
    width: '100%',
    padding: '12px 15px',
    borderRadius: '10px',
    border: '2px solid #ecf0f1',
    fontSize: '14px',
    boxSizing: 'border-box',
    outline: 'none',
    transition: 'border-color 0.3s ease',
  },
  textarea: {
    width: '100%',
    padding: '12px 15px',
    borderRadius: '10px',
    border: '2px solid #ecf0f1',
    fontSize: '14px',
    boxSizing: 'border-box',
    resize: 'vertical',
    outline: 'none',
    fontFamily: 'inherit',
    transition: 'border-color 0.3s ease',
  },
  inputErreur: {
    borderColor: '#e74c3c',
  },
  erreur: {
    color: '#e74c3c',
    fontSize: '12px',
    margin: '5px 0 0 0',
    fontWeight: '500',
  },
  erreurGlobale: {
    backgroundColor: '#fff5f5',
    color: '#e74c3c',
    padding: '15px',
    borderRadius: '10px',
    marginBottom: '20px',
    fontSize: '14px',
    fontWeight: '500',
    border: '1px solid #e74c3c',
  },
  boutons: {
    display: 'flex',
    justifyContent: 'flex-end',
    gap: '15px',
    marginTop: '30px',
    paddingTop: '20px',
    borderTop: '2px solid #ecf0f1',
  },
  boutonAnnuler: {
    backgroundColor: '#95a5a6',
    color: 'white',
    border: 'none',
    borderRadius: '25px',
    padding: '12px 25px',
    cursor: 'pointer',
    fontSize: '14px',
    fontWeight: 'bold',
  },
  boutonAjouter: {
    backgroundColor: '#3498db',
    color: 'white',
    border: 'none',
    borderRadius: '25px',
    padding: '12px 30px',
    cursor: 'pointer',
    fontWeight: 'bold',
    fontSize: '14px',
  }
};

export default AddRecipeForm;