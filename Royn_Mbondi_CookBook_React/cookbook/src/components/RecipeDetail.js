

function RecipeDetail({ recette, onFermer }) {
  if (!recette) return null;

  return (
    <div style={styles.overlay} onClick={onFermer}>
      <div style={styles.modale} onClick={(e) => e.stopPropagation()}>
        
        <button style={styles.boutonFermer} onClick={onFermer}>✕</button>
        <img
          src={recette.image || './images/OIP.jpg'}
          alt={recette.nom}
          style={styles.image}
        />

        <div style={styles.contenu}>
          <p style={styles.categorie}>{recette.categorie.toUpperCase()}</p>
          <h2 style={styles.titre}>{recette.nom}</h2>

          <h3 style={styles.sousTitre}> Ingrédients</h3>
          <ul style={styles.liste}>
            {recette.ingredients.map((ingredient, index) => (
              <li key={index} style={styles.item}>{ingredient}</li>
            ))}
          </ul>

          <h3 style={styles.sousTitre}> Instructions</h3>
          <div style={styles.instructions}>
            {recette.instructions.split('\n').map((ligne, index) => (
              <p key={index} style={styles.lignInstruction}>{ligne}</p>
            ))}
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
    backgroundColor: 'rgba(0,0,0,0.6)',
    display: 'flex',
    justifyContent: 'center',
    alignItems: 'center',
    zIndex: 1000,
  },
  modale: {
    backgroundColor: 'white',
    borderRadius: '16px',
    width: '600px',
    maxWidth: '90vw',
    maxHeight: '85vh',
    overflowY: 'auto',
    position: 'relative',
  },
  boutonFermer: {
    position: 'absolute',
    top: '12px',
    right: '15px',
    background: 'rgba(0,0,0,0.5)',
    color: 'white',
    border: 'none',
    borderRadius: '50%',
    width: '32px',
    height: '32px',
    cursor: 'pointer',
    fontSize: '14px',
    zIndex: 10,
  },
  image: {
    width: '100%',
    height: '250px',
    objectFit: 'cover',
    borderRadius: '16px 16px 0 0',
    display: 'block',
  },
  contenu: {
    padding: '25px',
  },
  categorie: {
    fontSize: '11px',
    color: '#fb6507',
    fontWeight: 'bold',
    letterSpacing: '1px',
    margin: '0 0 5px 0',
  },
  titre: {
    fontSize: '24px',
    fontWeight: 'bold',
    color: '#222',
    margin: '0 0 20px 0',
  },
  sousTitre: {
    fontSize: '16px',
    fontWeight: 'bold',
    color: '#333',
    margin: '20px 0 10px 0',
    borderBottom: '2px solid #f0e8d8',
    paddingBottom: '5px',
  },
  liste: {
    paddingLeft: '20px',
    margin: 0,
  },
  item: {
    marginBottom: '5px',
    color: '#555',
    fontSize: '14px',
  },
  instructions: {
    backgroundColor: '#faf7f2',
    padding: '15px',
    borderRadius: '8px',
  },
  lignInstruction: {
    margin: '0 0 8px 0',
    color: '#555',
    fontSize: '14px',
    lineHeight: '1.6',
  }
};

export default RecipeDetail;
