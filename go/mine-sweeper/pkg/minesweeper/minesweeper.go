package minesweeper

import "fmt"

type MineSweeper struct {
	Field [][]Cell
	Size  int
}

func NewMineSweeper(size int) MineSweeper {
	f := createField(size)
	aroundcells := getAroundCells(Position{
		x: 1,
		y: 1,
	}, f)

	fmt.Println(aroundcells)
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
				cell = fmt.Sprintf("%d", m.Field[y][x].aroundBombNum)
			}
			fmt.Printf("%s ", cell)
		}
		fmt.Println()
	}
}
