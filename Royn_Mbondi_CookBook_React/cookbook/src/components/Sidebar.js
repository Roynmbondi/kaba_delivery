
function Sidebar({ categories, categorieActive, onCategorieSelect, recettes }) {

  const compterRecettes = (categorie) => {
    if (categorie === 'Toutes') return recettes.length;
    return recettes.filter(r => r.categorie === categorie).length;
  };

  return (
    <aside style={styles.sidebar}>
      <p style={styles.label}>CATÉGORIES</p>
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
            <span>{categorie}</span>
            <span style={{
              ...styles.badge,
              ...(categorieActive === categorie ? styles.badgeActif : {})
            }}>
              {compterRecettes(categorie)}
            </span>
          </li>
        ))}
      </ul>
    </aside>
  );
}

const styles = {
  sidebar: {
    width: '180px',
    minWidth: '180px',
    borderRight: '1px solid #ddd',
    padding: '20px 15px',
    backgroundColor: '#f9f5f0',
  },
  label: {
    fontSize: '11px',
    color: '#999',
    fontWeight: 'bold',
    letterSpacing: '1px',
    margin: '0 0 15px 0',
  },
  liste: {
    listStyle: 'none',
    padding: 0,
    margin: 0,
  },
  item: {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: '10px 12px',
    borderRadius: '8px',
    cursor: 'pointer',
    marginBottom: '4px',
    color: '#333',
    fontSize: '15px',
  },
  itemActif: {
    backgroundColor: '#f65d0c',
    color: 'white',
    fontWeight: 'bold',
  },
  badge: {
    backgroundColor: '#ddd',
    borderRadius: '12px',
    padding: '2px 8px',
    fontSize: '12px',
    color: '#666',
  },
  badgeActif: {
    backgroundColor: 'rgba(255,255,255,0.3)',
    color: 'white',
  }
};

export default Sidebar;
