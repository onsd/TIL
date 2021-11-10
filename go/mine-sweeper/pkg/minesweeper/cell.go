package minesweeper

import (
	"math/rand"
)

type Cell struct {
	isBomb        bool
	isOpened      bool
	aroundBombNum int
}

type Position struct {
	x int
	y int
}

func createField(size int) [][]Cell {
	Field := make([][]Cell, size)
	for y := 0; y < size; y++ {
		Field[y] = make([]Cell, size)
		bombLocation := rand.Intn(size)
		for x := 0; x < size; x++ {
			c := Cell{
				isBomb:   false,
				isOpened: false,
			}
			if x == bombLocation {
				c.isBomb = true
			}
			Field[y][x] = c
		}
	}

	// 周りにいくつ爆弾があるか数える
	for y := 0; y < size; y++ {
		for x := 0; x < size; x++ {
			cells := getAroundCells(pos(x, y), Field)
			count := countBomb(cells...)
			Field[y][x].aroundBombNum = count
		}
	}

	return Field
}

// countAroundBombs counts the number of bomb around each cell and updates the aroundBombNum
//[y][x]Cell{
//	NW  N  NE
//	 W  C  E
//	SW  S  SE
//	[0][0]  [0][1]  [0][2]  [0][3]  [0][4]
//	[1][0]  [1][1]  [1][2]  [1][3]  [1][4]
//  [2][0]  [2][1]  [2][2]  [2][3]  [2][4]
//  [3][0]  [3][1]  [3][2]  [3][3]  [3][4]
//  [4][0]  [4][1]  [4][2]  [4][3]  [4][4]

func getAroundCells(pos Position, field [][]Cell) []Cell {
	size := len(field)
	var cells []Cell

	for _, y := range []int{-1, 0, 1} {
		for _, x := range []int{-1, 0, 1} {
			if x == 0 && y == 0 {
				continue
			}
			if 0 <= pos.y-y && pos.y-y < size && 0 <= pos.x-x && pos.x-x < size {
				cells = append(cells, field[pos.y-y][pos.x-x])
			}
		}
	}
	return cells
}

func countBomb(cells ...Cell) int {
	count := 0
	for _, c := range cells {
		if c.isBomb {
			count++
		}
	}

	return count
}

// util
func pos(x, y int) Position {
	return Position{
		x: x,
		y: y,
	}
}
