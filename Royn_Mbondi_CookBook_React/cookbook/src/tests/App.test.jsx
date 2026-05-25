import { render, screen } from '@testing-library/react'
import App from '../App'

describe('App Component', () => {
  test('renders application', () => {
    render(<App />)
    expect(screen.getByText(/cookbook/i)).toBeInTheDocument()
  })
})