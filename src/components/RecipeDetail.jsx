function RecipeDetail({ recette, onFermer }) {
  if (!recette) return null;

  // Simulation de données de livraison détaillées
  const deliveryDetails = {
    id: recette.id || 'KD-' + Math.random().toString(36).substr(2, 9).toUpperCase(),
    status: recette.status || 'En cours',
    client: recette.client || 'Client AFRIQ-LOGISTIX',
    phone: recette.phone || '+237 6XX XXX XXX',
    address: recette.address || 'Douala, Akwa, Cameroun',
    driver: recette.driver || 'Jean-Paul MBONDI',
    vehicle: recette.vehicle || 'Moto - ABC 123',
    estimatedTime: recette.estimatedTime || '25-30 min',
    distance: recette.distance || '5.2 km',
    cost: recette.cost || '2,500 FCFA'
  };

  const getStatusColor = (status) => {
    switch (status?.toLowerCase()) {
      case 'livré': return '#27ae60';
      case 'en cours': return '#f39c12';
      case 'en attente': return '#e74c3c';
      default: return '#3498db';
    }
  };

  return (
    <div style={styles.overlay} onClick={onFermer}>
      <div style={styles.modale} onClick={(e) => e.stopPropagation()}>
        <button style={styles.boutonFermer} onClick={onFermer}>✕</button>
        
        <div style={styles.header}>
          <h2 style={styles.titre}>📦 Détails de la Livraison</h2>
          <div style={{...styles.statusBadge, backgroundColor: getStatusColor(deliveryDetails.status)}}>
            {deliveryDetails.status.toUpperCase()}
          </div>
        </div>

        <div style={styles.contenu}>
          <div style={styles.section}>
            <h3 style={styles.sousTitre}>🆔 Informations Générales</h3>
            <div style={styles.infoGrid}>
              <div style={styles.infoItem}>
                <strong>ID Livraison:</strong> {deliveryDetails.id}
              </div>
              <div style={styles.infoItem}>
                <strong>Commande:</strong> {recette.nom}
              </div>
              <div style={styles.infoItem}>
                <strong>Catégorie:</strong> {recette.categorie || 'Standard'}
              </div>
              <div style={styles.infoItem}>
                <strong>Coût:</strong> {deliveryDetails.cost}
              </div>
            </div>
          </div>

          <div style={styles.section}>
            <h3 style={styles.sousTitre}>👤 Informations Client</h3>
            <div style={styles.infoGrid}>
              <div style={styles.infoItem}>
                <strong>Nom:</strong> {deliveryDetails.client}
              </div>
              <div style={styles.infoItem}>
                <strong>Téléphone:</strong> {deliveryDetails.phone}
              </div>
              <div style={styles.infoItem}>
                <strong>Adresse:</strong> {deliveryDetails.address}
              </div>
            </div>
          </div>

          <div style={styles.section}>
            <h3 style={styles.sousTitre}>🚚 Informations Livraison</h3>
            <div style={styles.infoGrid}>
              <div style={styles.infoItem}>
                <strong>Livreur:</strong> {deliveryDetails.driver}
              </div>
              <div style={styles.infoItem}>
                <strong>Véhicule:</strong> {deliveryDetails.vehicle}
              </div>
              <div style={styles.infoItem}>
                <strong>Distance:</strong> {deliveryDetails.distance}
              </div>
              <div style={styles.infoItem}>
                <strong>Temps estimé:</strong> {deliveryDetails.estimatedTime}
              </div>
            </div>
          </div>

          <div style={styles.section}>
            <h3 style={styles.sousTitre}>📋 Articles à Livrer</h3>
            <ul style={styles.liste}>
              {(recette.ingredients || ['Article 1', 'Article 2']).map((ingredient, index) => (
                <li key={index} style={styles.item}>
                  <span style={styles.itemIcon}>📦</span>
                  {ingredient}
                </li>
              ))}
            </ul>
          </div>

          {recette.instructions && (
            <div style={styles.section}>
              <h3 style={styles.sousTitre}>📝 Instructions Spéciales</h3>
              <div style={styles.instructions}>
                {recette.instructions.split('\n').map((ligne, index) => (
                  <p key={index} style={styles.lignInstruction}>{ligne}</p>
                ))}
              </div>
            </div>
          )}

          <div style={styles.actions}>
            <button style={styles.boutonAction}>
              📍 Suivre en Temps Réel
            </button>
            <button style={styles.boutonSecondaire}>
              📞 Contacter le Livreur
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
    width: '700px',
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
    background: 'rgba(0,0,0,0.1)',
    color: '#2c3e50',
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
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    borderRadius: '20px 20px 0 0',
  },
  titre: {
    fontSize: '24px',
    fontWeight: 'bold',
    margin: 0,
  },
  statusBadge: {
    padding: '8px 15px',
    borderRadius: '20px',
    fontSize: '12px',
    fontWeight: 'bold',
    color: 'white',
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
    margin: '0 0 15px 0',
    display: 'flex',
    alignItems: 'center',
  },
  infoGrid: {
    display: 'grid',
    gridTemplateColumns: 'repeat(auto-fit, minmax(250px, 1fr))',
    gap: '15px',
  },
  infoItem: {
    fontSize: '14px',
    color: '#2c3e50',
    padding: '10px',
    backgroundColor: 'white',
    borderRadius: '8px',
    border: '1px solid #ecf0f1',
  },
  liste: {
    paddingLeft: '0',
    margin: 0,
    listStyle: 'none',
  },
  item: {
    marginBottom: '10px',
    color: '#2c3e50',
    fontSize: '14px',
    display: 'flex',
    alignItems: 'center',
    padding: '10px',
    backgroundColor: 'white',
    borderRadius: '8px',
    border: '1px solid #ecf0f1',
  },
  itemIcon: {
    marginRight: '10px',
    fontSize: '16px',
  },
  instructions: {
    backgroundColor: 'white',
    padding: '15px',
    borderRadius: '8px',
    border: '1px solid #ecf0f1',
  },
  lignInstruction: {
    margin: '0 0 8px 0',
    color: '#2c3e50',
    fontSize: '14px',
    lineHeight: '1.6',
  },
  actions: {
    display: 'flex',
    gap: '15px',
    marginTop: '30px',
    flexWrap: 'wrap',
  },
  boutonAction: {
    backgroundColor: '#3498db',
    color: 'white',
    border: 'none',
    borderRadius: '25px',
    padding: '12px 25px',
    cursor: 'pointer',
    fontSize: '14px',
    fontWeight: 'bold',
    flex: 1,
    minWidth: '200px',
  },
  boutonSecondaire: {
    backgroundColor: '#95a5a6',
    color: 'white',
    border: 'none',
    borderRadius: '25px',
    padding: '12px 25px',
    cursor: 'pointer',
    fontSize: '14px',
    fontWeight: 'bold',
    flex: 1,
    minWidth: '200px',
  }
};

export default RecipeDetail;