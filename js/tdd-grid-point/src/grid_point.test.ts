import { assert, describe, expect, it } from 'vitest'
import { GridPoint } from './grid_point'

describe('GridPoint', () => {
    it('generates gridpoint', () => {
        const gridPoint = new GridPoint(1, 2)
        expect(gridPoint.x).toBe(1)
        expect(gridPoint.y).toBe(2)
    })

    it('returns notation', () => {
        const gridPoint = new GridPoint(1, 2)
        expect(gridPoint.getNotation()).toBe('(1, 2)')
    })
})
