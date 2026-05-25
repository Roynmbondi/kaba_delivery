import RecipeCard from './RecipeCard';


function RecipeList({ recettes, onVoirDetail }) {
  if (recettes.length === 0) {
    return (
      <div style={styles.vide}>
        <p>Aucune recette trouvée.</p>
      </div>
    );
  }

  return (
    <div style={styles.grille}>
      {recettes.map((recette) => (
        <RecipeCard
          key={recette.id}
          recette={recette}
          onVoirDetail={onVoirDetail}
        />
      ))}
    </div>
  );
}

const styles = {
  grille: {
    display: 'flex',
    flexWrap: 'wrap',
    gap: '20px',
  },
  vide: {
    color: '#999',
    fontSize: '16px',
    textAlign: 'center',
    padding: '40px',
  }
};

export default RecipeList;
