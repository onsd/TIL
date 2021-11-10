package minesweeper

import "testing"

func TestNewMineSweeper(t *testing.T) {
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
			m := NewMineSweeper(tc.size)
			rawSize := 0
			for _, f := range m.Field {
				rawSize = rawSize + len(f)
			}
			idealSize := m.Size * m.Size
			if rawSize != idealSize {
				t.Errorf("size should be %d, got %d", idealSize, rawSize)
			}
		})
	}
}
