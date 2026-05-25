import { describe, it, expect, vi, beforeEach } from 'vitest'
import { getRecettes, addRecette } from './recetteService'

// Mock global fetch
global.fetch = vi.fn()

describe('RecetteService', () => {
  beforeEach(() => {
    vi.clearAllMocks()
  })

  describe('getRecettes', () => {
    it('should fetch recipes successfully', async () => {
      const mockRecettes = [
        { id: 1, nom: 'Test Recipe', categorie: 'Test' }
      ]
      
      fetch.mockResolvedValueOnce({
        ok: true,
        json: async () => mockRecettes
      })

      const result = await getRecettes()
      
      expect(fetch).toHaveBeenCalledWith('http://localhost:3001/recettes')
      expect(result).toEqual(mockRecettes)
    })

    it('should handle fetch errors', async () => {
      fetch.mockRejectedValueOnce(new Error('Network error'))

      await expect(getRecettes()).rejects.toThrow('Erreur lors du chargement des recettes')
    })

    it('should handle HTTP errors', async () => {
      fetch.mockResolvedValueOnce({
        ok: false,
        status: 404
      })

      await expect(getRecettes()).rejects.toThrow('Erreur lors du chargement des recettes')
    })
  })

  describe('addRecette', () => {
    it('should add recipe successfully', async () => {
      const newRecette = { nom: 'New Recipe', categorie: 'Test' }
      const addedRecette = { id: 1, ...newRecette }
      
      fetch.mockResolvedValueOnce({
        ok: true,
        json: async () => addedRecette
      })

      const result = await addRecette(newRecette)
      
      expect(fetch).toHaveBeenCalledWith('http://localhost:3001/recettes', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(newRecette)
      })
      expect(result).toEqual(addedRecette)
    })

    it('should handle add recipe errors', async () => {
      const newRecette = { nom: 'New Recipe', categorie: 'Test' }
      
      fetch.mockRejectedValueOnce(new Error('Network error'))

      await expect(addRecette(newRecette)).rejects.toThrow('Erreur lors de l\'ajout de la recette')
    })
  })
})