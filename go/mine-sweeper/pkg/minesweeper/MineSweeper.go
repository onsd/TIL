package minesweeper

import "fmt"

type MineSweeper struct {
	Field [][]Cell
	Size  int
}

type Cell struct {
	isBomb   bool
	isOpened bool
}

func NewMineSweeper(size int) MineSweeper {
	f := createField(size)
	return MineSweeper{
		Field: f,
		Size:  size,
	}
}

func (m *MineSweeper) PrintField() {
	for y := 0; y < m.Size; y++ {
		for x := 0; x < m.Size; x++ {
			var cell string
			if m.Field[y][x].isBomb {
				cell = "B"
			} else if m.Field[y][x].isOpened {
				cell = "O"
			} else {
				cell = "?"
			}
			fmt.Printf("%s ", cell)
		}
		fmt.Println()
	}
}

func createField(size int) [][]Cell {
	Field := make([][]Cell, size)
	for y := 0; y < size; y++ {
		Field[y] = make([]Cell, size)
		for x := 0; x < size; x++ {
			c := Cell {
				isBomb:   false,
				isOpened: false,
			}
			Field[y][x] = c
		}
	}

	return Field
}
