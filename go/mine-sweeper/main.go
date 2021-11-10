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
		fmt.Printf("enter x y\n")
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
	}

}
