package minesweeper

import "testing"

func TestCreateField(t *testing.T) {
	testcases := []struct {
		name string
		size int
	}{
		{
			name: "create 5x5 field",
			size: 5,
		},
		{
			name: "create 10x10 field",
			size: 10,
		},
	}

	for _, tc := range testcases {
		t.Run(tc.name, func(t *testing.T) {
			field := createField(tc.size)
			rawSize := 0
			for _, f := range field {
				rawSize = rawSize + len(f)
			}
			idealSize := tc.size * tc.size
			if rawSize != idealSize {
				t.Errorf("size should be %d, got %d", idealSize, rawSize)
			}
		})
	}
}

func TestCountBomb(t *testing.T) {
	testcases := []struct {
		name string
		cells []Cell
		bombs int
	}{
		{
			name: "8 cells, 2 bombs",
			bombs: 2,
			cells: []Cell{
				{
					isBomb: true,
					isOpened: false,
					aroundBombNum: 0,
				},
				{
					isBomb: false,
					isOpened: false,
					aroundBombNum: 0,
				},
				{
					isBomb: false,
					isOpened: false,
					aroundBombNum: 0,
				},
				{
					isBomb: true,
					isOpened: false,
					aroundBombNum: 0,
				},
				{
					isBomb: false,
					isOpened: false,
					aroundBombNum: 0,
				},
				{
					isBomb: false,
					isOpened: false,
					aroundBombNum: 0,
				},
				{
					isBomb: false,
					isOpened: false,
					aroundBombNum: 0,
				},
				{
					isBomb: false,
					isOpened: false,
					aroundBombNum: 0,
				},
			},
		},
		{
			name: "5 cells, 5 bombs",
			bombs: 5,
			cells: []Cell{
				{
					isBomb: true,
					isOpened: false,
					aroundBombNum: 0,
				},
				{
					isBomb: true,
					isOpened: false,
					aroundBombNum: 0,
				},
				{
					isBomb: true,
					isOpened: false,
					aroundBombNum: 0,
				},
				{
					isBomb: true,
					isOpened: false,
					aroundBombNum: 0,
				},
				{
					isBomb: true,
					isOpened: false,
					aroundBombNum: 0,
				},
			},
		},
	}
	for _, tc := range testcases {
		t.Run(tc.name, func(t *testing.T) {
			calculatedBombs := countBomb(tc.cells...)

			if calculatedBombs != tc.bombs {
				t.Errorf("size should be %d, got %d", tc.bombs, calculatedBombs)
			}
		})
	}
}

func TestGetAroundCells(t *testing.T) {

	testcases := []struct {
		name string
		field [][]Cell
		position Position
		idealCellsNum int
	}{
		{
			name: "around 8 cells",
			field: createField(3),
			position: Position{
				x: 1,
				y: 1,
			},
			idealCellsNum: 8,
		},
		{
			name: "around 3 cells",
			field: createField(3),
			position: Position{
				x: 0,
				y: 0,
			},
			idealCellsNum: 3,
		},
	}

	for _, tc := range testcases {
		t.Run(tc.name, func(t *testing.T) {
			cells := getAroundCells(tc.position, tc.field)

			if len(cells) != tc.idealCellsNum {
				t.Errorf("cells should be %d, got %d", tc.idealCellsNum, len(cells))
			}
		})
	}
}