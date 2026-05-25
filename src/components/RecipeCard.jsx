function RecipeCard({ recette, onVoirDetail }) {
  const getStatusColor = (status) => {
    switch (status?.toLowerCase()) {
      case 'livré': return '#27ae60';
      case 'en cours': return '#f39c12';
      case 'en attente': return '#e74c3c';
      default: return '#3498db';
    }
  };

  const getStatusIcon = (status) => {
    switch (status?.toLowerCase()) {
      case 'livré': return '✅';
      case 'en cours': return '🚚';
      case 'en attente': return '⏳';
      default: return '📦';
    }
  };

  // Simulation de données de livraison basées sur les recettes
  const deliveryData = {
    status: recette.status || 'En cours',
    destination: recette.destination || 'Douala, Cameroun',
    estimatedTime: recette.estimatedTime || '30 min',
    priority: recette.priority || 'Normal'
  };

  return (
    <div style={styles.carte}>
      <div style={styles.header}>
        <div style={styles.statusBadge}>
          <span style={{...styles.statusIcon, color: getStatusColor(deliveryData.status)}}>
            {getStatusIcon(deliveryData.status)}
          </span>
          <span style={{...styles.statusText, color: getStatusColor(deliveryData.status)}}>
            {deliveryData.status}
          </span>
        </div>
        <div style={styles.priority}>
          {deliveryData.priority === 'Urgent' ? '🔥' : '📋'} {deliveryData.priority}
        </div>
      </div>

      <div style={styles.contenu}>
        <p style={styles.categorie}>{recette.categorie?.toUpperCase() || 'LIVRAISON'}</p>
        <h3 style={styles.nom}>{recette.nom}</h3>
        
        <div style={styles.details}>
          <div style={styles.detailItem}>
            <span style={styles.detailIcon}>📍</span>
            <span style={styles.detailText}>{deliveryData.destination}</span>
          </div>
          <div style={styles.detailItem}>
            <span style={styles.detailIcon}>⏱️</span>
            <span style={styles.detailText}>{deliveryData.estimatedTime}</span>
          </div>
        </div>

        <div style={styles.ingredients}>
          <strong>Articles:</strong> {recette.ingredients?.slice(0, 2).join(', ') || 'Produits divers'}
          {recette.ingredients?.length > 2 ? '...' : ''}
        </div>

        <button
          style={styles.bouton}
          onClick={() => onVoirDetail(recette)}
        >
          📋 Voir détails
        </button>
      </div>
    </div>
  );
}

const styles = {
  carte: {
    backgroundColor: 'white',
    borderRadius: '15px',
    overflow: 'hidden',
    boxShadow: '0 4px 15px rgba(0,0,0,0.1)',
    transition: 'all 0.3s ease',
    border: '1px solid #ecf0f1',
    cursor: 'pointer',
  },
  header: {
    background: 'linear-gradient(135deg, #3498db, #2980b9)',
    padding: '15px',
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  statusBadge: {
    display: 'flex',
    alignItems: 'center',
    backgroundColor: 'rgba(255,255,255,0.2)',
    padding: '5px 10px',
    borderRadius: '20px',
  },
  statusIcon: {
    fontSize: '16px',
    marginRight: '5px',
  },
  statusText: {
    color: 'white',
    fontSize: '12px',
    fontWeight: 'bold',
  },
  priority: {
    color: 'white',
    fontSize: '11px',
    fontWeight: '500',
  },
  contenu: {
    padding: '20px',
  },
  categorie: {
    fontSize: '11px',
    color: '#3498db',
    fontWeight: 'bold',
    letterSpacing: '1px',
    margin: '0 0 8px 0',
  },
  nom: {
    fontSize: '18px',
    fontWeight: 'bold',
    color: '#2c3e50',
    margin: '0 0 15px 0',
    lineHeight: '1.3',
  },
  details: {
    marginBottom: '15px',
  },
  detailItem: {
    display: 'flex',
    alignItems: 'center',
    marginBottom: '8px',
  },
  detailIcon: {
    fontSize: '14px',
    marginRight: '8px',
    width: '20px',
  },
  detailText: {
    fontSize: '13px',
    color: '#7f8c8d',
  },
  ingredients: {
    fontSize: '13px',
    color: '#7f8c8d',
    margin: '0 0 20px 0',
    lineHeight: '1.4',
    backgroundColor: '#f8f9fa',
    padding: '10px',
    borderRadius: '8px',
  },
  bouton: {
    backgroundColor: '#3498db',
    color: 'white',
    border: 'none',
    borderRadius: '25px',
    padding: '10px 20px',
    cursor: 'pointer',
    fontSize: '13px',
    fontWeight: 'bold',
    width: '100%',
    transition: 'all 0.3s ease',
  }
};

export default RecipeCard;