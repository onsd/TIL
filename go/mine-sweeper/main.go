package main

import (
	"errors"
	"fmt"
	"minesweeper/pkg/minesweeper"
)

func main() {
	m := minesweeper.NewMineSweeper(10)

	var x, y int
	for {
		m.PrintField()
		fmt.Printf("enter \ny x >")
		fmt.Scan(&x, &y)
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
