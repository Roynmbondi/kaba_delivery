import RecipeCard from './RecipeCard';

function RecipeList({ recettes, onVoirDetail }) {
  if (recettes.length === 0) {
    return (
      <div style={styles.vide}>
        <div style={styles.iconeVide}>📦</div>
        <h3 style={styles.titreVide}>Aucune livraison trouvée</h3>
        <p style={styles.messageVide}>
          Aucune livraison ne correspond à vos critères de recherche.
        </p>
      </div>
    );
  }

  return (
    <div style={styles.container}>
      <div style={styles.header}>
        <h3 style={styles.titre}>
          📋 {recettes.length} livraison{recettes.length > 1 ? 's' : ''} trouvée{recettes.length > 1 ? 's' : ''}
        </h3>
      </div>
      <div style={styles.grille}>
        {recettes.map((recette) => (
          <RecipeCard
            key={recette.id}
            recette={recette}
            onVoirDetail={onVoirDetail}
          />
        ))}
      </div>
    </div>
  );
}

const styles = {
  container: {
    width: '100%',
  },
  header: {
    marginBottom: '20px',
    paddingBottom: '10px',
    borderBottom: '2px solid #ecf0f1',
  },
  titre: {
    color: '#2c3e50',
    fontSize: '18px',
    fontWeight: '600',
    margin: 0,
  },
  grille: {
    display: 'grid',
    gridTemplateColumns: 'repeat(auto-fill, minmax(280px, 1fr))',
    gap: '25px',
    padding: '10px 0',
  },
  vide: {
    textAlign: 'center',
    padding: '60px 20px',
    color: '#7f8c8d',
  },
  iconeVide: {
    fontSize: '64px',
    marginBottom: '20px',
    opacity: 0.5,
  },
  titreVide: {
    fontSize: '24px',
    fontWeight: '600',
    margin: '0 0 10px 0',
    color: '#2c3e50',
  },
  messageVide: {
    fontSize: '16px',
    margin: 0,
    maxWidth: '400px',
    marginLeft: 'auto',
    marginRight: 'auto',
    lineHeight: '1.5',
  }
};

export default RecipeList;