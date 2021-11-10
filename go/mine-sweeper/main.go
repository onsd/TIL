package main

import "minesweeper/pkg/minesweeper"

func main() {
	m := minesweeper.NewMineSweeper(10)
	m.PrintField()
}