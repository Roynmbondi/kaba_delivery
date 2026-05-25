
function RecipeCard({ recette, onVoirDetail }) {
  return (
    <div style={styles.carte}>
      
      <img
        src={recette.image || './images/OIP.jpg'}
        alt={recette.nom}
        style={styles.image}
        onError={(e) => { e.target.src = './images/OIP.jpg'; }}
      />

      <div style={styles.contenu}>
        <p style={styles.categorie}>{recette.categorie.toUpperCase()}</p>
        <h3 style={styles.nom}>{recette.nom}</h3>
        <p style={styles.ingredients}>
          {recette.ingredients.slice(0, 3).join(', ')}
          {recette.ingredients.length > 3 ? '...' : ''}
        </p>

        <button
          style={styles.bouton}
          onClick={() => onVoirDetail(recette)}
        >
          Voir détails
        </button>
      </div>
    </div>
  );
}

const styles = {
  carte: {
    backgroundColor: 'white',
    borderRadius: '12px',
    overflow: 'hidden',
    boxShadow: '0 2px 8px rgba(0,0,0,0.08)',
    width: '260px',
    minWidth: '260px',
  },
  image: {
    width: '100%',
    height: '160px',
    objectFit: 'cover',
    display: 'block',
  },
  contenu: {
    padding: '15px',
  },
  categorie: {
    fontSize: '11px',
    color: '#999',
    fontWeight: 'bold',
    letterSpacing: '1px',
    margin: '0 0 5px 0',
  },
  nom: {
    fontSize: '17px',
    fontWeight: 'bold',
    color: '#222',
    margin: '0 0 8px 0',
  },
  ingredients: {
    fontSize: '13px',
    color: '#777',
    margin: '0 0 15px 0',
    lineHeight: '1.4',
  },
  bouton: {
    backgroundColor: 'white',
    color: '#333',
    border: '1px solid #ccc',
    borderRadius: '25px',
    padding: '7px 20px',
    cursor: 'pointer',
    fontSize: '13px',
  }
};

export default RecipeCard;
