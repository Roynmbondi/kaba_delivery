import { describe, it, expect, vi, beforeEach } from 'vitest'
import { render, screen, waitFor } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import App from './App'
import * as recetteService from './services/recetteService'

// Mock du service
vi.mock('./services/recetteService')

const mockRecettes = [
  {
    id: 1,
    nom: 'Poulet DG',
    categorie: 'Plat principal',
    ingredients: ['Poulet', 'Plantain', 'Légumes'],
    instructions: 'Cuire le poulet...',
    tempsPreparation: 45,
    difficulte: 'Moyen'
  },
  {
    id: 2,
    nom: 'Ndolé',
    categorie: 'Plat traditionnel',
    ingredients: ['Feuilles de ndolé', 'Poisson', 'Viande'],
    instructions: 'Préparer les feuilles...',
    tempsPreparation: 90,
    difficulte: 'Difficile'
  }
]

describe('App Component', () => {
  beforeEach(() => {
    vi.clearAllMocks()
  })

  it('should render header and main content', async () => {
    recetteService.getRecettes.mockResolvedValue(mockRecettes)
    
    render(<App />)
    
    expect(screen.getByText('Toutes les recettes')).toBeInTheDocument()
    expect(screen.getByPlaceholderText('Chercher une recette...')).toBeInTheDocument()
  })

  it('should display loading state initially', () => {
    recetteService.getRecettes.mockImplementation(() => new Promise(() => {}))
    
    render(<App />)
    
    expect(screen.getByText('Chargement des recettes...')).toBeInTheDocument()
  })

  it('should display recipes after loading', async () => {
    recetteService.getRecettes.mockResolvedValue(mockRecettes)
    
    render(<App />)
    
    await waitFor(() => {
      expect(screen.getByText('Poulet DG')).toBeInTheDocument()
      expect(screen.getByText('Ndolé')).toBeInTheDocument()
    })
  })

  it('should filter recipes by search term', async () => {
    recetteService.getRecettes.mockResolvedValue(mockRecettes)
    const user = userEvent.setup()
    
    render(<App />)
    
    await waitFor(() => {
      expect(screen.getByText('Poulet DG')).toBeInTheDocument()
    })

    const searchInput = screen.getByPlaceholderText('Chercher une recette...')
    await user.type(searchInput, 'Poulet')
    
    expect(screen.getByText('Poulet DG')).toBeInTheDocument()
    expect(screen.queryByText('Ndolé')).not.toBeInTheDocument()
  })

  it('should handle service errors gracefully', async () => {
    recetteService.getRecettes.mockRejectedValue(new Error('Erreur réseau'))
    
    render(<App />)
    
    await waitFor(() => {
      expect(screen.getByText('Erreur réseau')).toBeInTheDocument()
      expect(screen.getByText('Réessayer')).toBeInTheDocument()
    })
  })

  it('should retry loading recipes when retry button is clicked', async () => {
    recetteService.getRecettes
      .mockRejectedValueOnce(new Error('Erreur réseau'))
      .mockResolvedValueOnce(mockRecettes)
    
    const user = userEvent.setup()
    render(<App />)
    
    await waitFor(() => {
      expect(screen.getByText('Réessayer')).toBeInTheDocument()
    })

    await user.click(screen.getByText('Réessayer'))
    
    await waitFor(() => {
      expect(screen.getByText('Poulet DG')).toBeInTheDocument()
    })
  })
})