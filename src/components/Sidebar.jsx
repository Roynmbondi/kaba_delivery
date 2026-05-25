function Sidebar({ categories, categorieActive, onCategorieSelect, recettes }) {
  const compterRecettes = (categorie) => {
    if (categorie === 'Toutes') return recettes.length;
    return recettes.filter(r => r.categorie === categorie).length;
  };

  return (
    <aside style={styles.sidebar}>
      <p style={styles.label}>📊 CATÉGORIES</p>
      <ul style={styles.liste}>
        {['Toutes', ...categories].map((categorie) => (
          <li
            key={categorie}
            style={{
              ...styles.item,
              ...(categorieActive === categorie ? styles.itemActif : {})
            }}
            onClick={() => onCategorieSelect(categorie)}
          >
            <span style={styles.categorieText}>
              {categorie === 'Toutes' ? '📦 Toutes' : `🚚 ${categorie}`}
            </span>
            <span style={{
              ...styles.badge,
              ...(categorieActive === categorie ? styles.badgeActif : {})
            }}>
              {compterRecettes(categorie)}
            </span>
          </li>
        ))}
      </ul>
      
      <div style={styles.stats}>
        <p style={styles.label}>📈 STATISTIQUES</p>
        <div style={styles.statItem}>
          <span>Total livraisons:</span>
          <strong>{recettes.length}</strong>
        </div>
        <div style={styles.statItem}>
          <span>Catégories:</span>
          <strong>{categories.length}</strong>
        </div>
      </div>
    </aside>
  );
}

const styles = {
  sidebar: {
    width: '220px',
    minWidth: '220px',
    borderRight: '2px solid #ecf0f1',
    padding: '25px 20px',
    backgroundColor: '#ffffff',
    boxShadow: '2px 0 10px rgba(0,0,0,0.05)',
  },
  label: {
    fontSize: '12px',
    color: '#7f8c8d',
    fontWeight: 'bold',
    letterSpacing: '1px',
    margin: '0 0 15px 0',
    textTransform: 'uppercase',
  },
  liste: {
    listStyle: 'none',
    padding: 0,
    margin: '0 0 30px 0',
  },
  item: {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: '12px 15px',
    borderRadius: '10px',
    cursor: 'pointer',
    marginBottom: '6px',
    color: '#2c3e50',
    fontSize: '14px',
    transition: 'all 0.3s ease',
    border: '2px solid transparent',
  },
  itemActif: {
    backgroundColor: '#3498db',
    color: 'white',
    fontWeight: 'bold',
    border: '2px solid #2980b9',
    transform: 'translateX(5px)',
  },
  categorieText: {
    display: 'flex',
    alignItems: 'center',
  },
  badge: {
    backgroundColor: '#ecf0f1',
    borderRadius: '15px',
    padding: '4px 10px',
    fontSize: '11px',
    color: '#7f8c8d',
    fontWeight: 'bold',
    minWidth: '25px',
    textAlign: 'center',
  },
  badgeActif: {
    backgroundColor: 'rgba(255,255,255,0.3)',
    color: 'white',
  },
  stats: {
    borderTop: '2px solid #ecf0f1',
    paddingTop: '20px',
  },
  statItem: {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: '8px 0',
    fontSize: '13px',
    color: '#2c3e50',
  }
};

export default Sidebar;