

function Header({ onAjouterClick }) {
  return (
    <header style={styles.header}>
      <h1 style={styles.titre}>CookBook</h1>
      <button style={styles.bouton} onClick={onAjouterClick}>
         Ajoutez une recette
      </button>
    </header>
  );
}

const styles = {
  header: {
    backgroundColor: '#1a1a1a',
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: '0 30px',
    height: '60px',
  },
  titre: {
    color: 'white',
    fontSize: '20px',
    fontStyle: 'italic',
    fontWeight: 'bold',
    margin: 0,
  },
  bouton: {
    backgroundColor: '#fa5305',
    color: 'white',
    border: 'none',
    borderRadius: '25px',
    padding: '10px 20px',
    cursor: 'pointer',
    fontWeight: 'bold',
    fontSize: '14px',
  }
};

export default Header;
