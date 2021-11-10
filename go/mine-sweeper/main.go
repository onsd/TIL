package main

import (
	"minesweeper/pkg/minesweeper"
)

func main() {
	m := minesweeper.NewMineSweeper(5)
	m.PrintField()
}