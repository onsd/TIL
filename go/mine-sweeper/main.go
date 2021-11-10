package main

import (
	"errors"
	"fmt"
	"minesweeper/pkg/minesweeper"
)

func main() {
	m := minesweeper.NewMineSweeper(10)

	for {
		m.PrintField()
		x, y := inputPosition(m.Size)
		if err := m.Open(x, y); err != nil {
			if !errors.Is(err, minesweeper.ErrBomb) {
				fmt.Println(err)
				continue
			}
			fmt.Println("!!!YOU OPENED THE BOMB!!!!")
			m.PrintField()
			break
		}

		if m.CheckWin() {
			fmt.Println("You win :)")
			fmt.Println("You Opened All Cells!")

			m.PrintField()
			break
		}
	}

}

func inputPosition(size int) (x, y int) {
	for {
		fmt.Printf("enter\n> ")
		fmt.Scan(&x, &y)
		if size <= x || size <= y {
			fmt.Printf("you must enter number between 0 to %d\n", size)
			continue
		}
		break
	}
	return x, y
}
