function Header({ onAjouterClick }) {
  return (
    <header style={styles.header}>
      <div style={styles.logo}>
        <h1 style={styles.titre}>KABA-DELIVERY</h1>
        <span style={styles.subtitle}>AFRIQ-LOGISTIX</span>
      </div>
      <button style={styles.bouton} onClick={onAjouterClick}>
        ➕ Nouvelle Livraison
      </button>
    </header>
  );
}

const styles = {
  header: {
    backgroundColor: '#2c3e50',
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: '0 30px',
    height: '70px',
    boxShadow: '0 2px 10px rgba(0,0,0,0.1)',
  },
  logo: {
    display: 'flex',
    flexDirection: 'column',
  },
  titre: {
    color: '#3498db',
    fontSize: '24px',
    fontWeight: 'bold',
    margin: 0,
    letterSpacing: '1px',
  },
  subtitle: {
    color: '#ecf0f1',
    fontSize: '12px',
    fontWeight: '300',
    marginTop: '-5px',
  },
  bouton: {
    backgroundColor: '#3498db',
    color: 'white',
    border: 'none',
    borderRadius: '25px',
    padding: '12px 24px',
    cursor: 'pointer',
    fontWeight: 'bold',
    fontSize: '14px',
    transition: 'all 0.3s ease',
    boxShadow: '0 2px 5px rgba(0,0,0,0.2)',
  }
};

// Ajout de l'effet hover via JavaScript
if (typeof window !== 'undefined') {
  const addHoverEffect = () => {
    const buttons = document.querySelectorAll('button');
    buttons.forEach(button => {
      button.addEventListener('mouseenter', () => {
        if (button.style.backgroundColor === 'rgb(52, 152, 219)') {
          button.style.backgroundColor = '#2980b9';
          button.style.transform = 'translateY(-2px)';
        }
      });
      button.addEventListener('mouseleave', () => {
        if (button.style.backgroundColor === 'rgb(41, 128, 185)') {
          button.style.backgroundColor = '#3498db';
          button.style.transform = 'translateY(0)';
        }
      });
    });
  };
  
  setTimeout(addHoverEffect, 100);
}

export default Header;