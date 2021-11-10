package minesweeper

import (
	"errors"
	"fmt"
)

var (
	ErrBomb = errors.New("BOMB")
)

type MineSweeper struct {
	Field [][]Cell
	Size  int
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
			if m.Field[y][x].isOpened {
				cell = fmt.Sprintf("%d", m.Field[y][x].aroundBombNum)
				if m.Field[y][x].isBomb {
					cell = "B"
				}
			} else {
				cell = "?"
			}
			fmt.Printf("%s ", cell)
		}
		fmt.Println()
	}
}

func (m *MineSweeper) Open(x, y int) error {
	if m.Field[y][x].isOpened {
		return errors.New(fmt.Sprintf("(x, y) == (%d, %d) is already opened", x, y))
	}
	m.Field[y][x].isOpened = true

	if m.Field[y][x].isBomb {
		return ErrBomb
	}

	// 周りに爆弾がないとき、周りのマスもあける
	if m.Field[y][x].aroundBombNum == 0 {
		for _, ey := range []int{-1, 0, 1} {
			for _, ex := range []int{-1, 0, 1} {
				if ex == 0 && ey == 0 {
					continue
				}
				if 0 <= y-ey && y-ey < m.Size && 0 <= x-ex && x-ex < m.Size {
					m.Open(x-ex, y-ey)
				}
			}
		}
	}
	return nil
}

func (m *MineSweeper) CheckWin() bool {
	win := true
	// 全部のマスをみる
	for y := 0; y < m.Size; y++ {
		for x := 0; x < m.Size; x++ {
			c := &m.Field[y][x]
			// 爆弾のマスを開けている場合勝ちではない
			if c.isBomb && c.isOpened {
				win = win && false
				continue
			}

			// 爆弾では無いマスを開けていない場合、勝ちではない
			if !c.isOpened && !c.isBomb {
				win = win && false
				continue
			}
			// マスを開けていて、爆弾でない
			win = win && true
		}
	}
	return win
}
