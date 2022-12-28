package tenniskata

import (
	"testing"
)

type testDataSample struct {
	player1Score  int
	player2Score  int
	expectedScore string
}

// 挙動が変わっていないことを確認するテスト
func TestTennisGame1(t *testing.T) {
	var testData = []testDataSample{
		{0, 0, "Love-All"},
		{1, 1, "Fifteen-All"},
		{2, 2, "Thirty-All"},
		{3, 3, "Deuce"},
		{4, 4, "Deuce"},

		{1, 0, "Fifteen-Love"},
		{0, 1, "Love-Fifteen"},
		{2, 0, "Thirty-Love"},
		{0, 2, "Love-Thirty"},
		{3, 0, "Forty-Love"},
		{0, 3, "Love-Forty"},
		{4, 0, "Win for player1"},
		{0, 4, "Win for player2"},

		{2, 1, "Thirty-Fifteen"},
		{1, 2, "Fifteen-Thirty"},
		{3, 1, "Forty-Fifteen"},
		{1, 3, "Fifteen-Forty"},
		{4, 1, "Win for player1"},
		{1, 4, "Win for player2"},

		{3, 2, "Forty-Thirty"},
		{2, 3, "Thirty-Forty"},
		{4, 2, "Win for player1"},
		{2, 4, "Win for player2"},

		{4, 3, "Advantage player1"},
		{3, 4, "Advantage player2"},
		{5, 4, "Advantage player1"},
		{4, 5, "Advantage player2"},
		{15, 14, "Advantage player1"},
		{14, 15, "Advantage player2"},

		{6, 4, "Win for player1"},
		{4, 6, "Win for player2"},
		{16, 14, "Win for player1"},
		{14, 16, "Win for player2"},
	}

	for _, sample := range testData {
		sample := sample
		t.Run(sample.expectedScore, func(t *testing.T) {
			t.Parallel()

			game := NewTennisGame1("player1", "player2")
			for i := 0; i < sample.player1Score; i++ {
				game.WonPoint("player1")
			}
			for i := 0; i < sample.player2Score; i++ {
				game.WonPoint("player2")
			}
			score := game.GetScore()
			if score != sample.expectedScore {
				t.Errorf("Expected score %s, got %s", sample.expectedScore, score)
			}
		})
	}
}

// 切り出した個別の関数が正しく動いているか確認するテスト
func TestGetScoreNameWhenAdvantageOrWin(t *testing.T) {
	testData := []testDataSample{
		{4, 3, "Advantage player1"},
		{3, 4, "Advantage player2"},
		{5, 4, "Advantage player1"},
		{4, 5, "Advantage player2"},
		{15, 14, "Advantage player1"},
		{14, 15, "Advantage player2"},

		{6, 4, "Win for player1"},
		{4, 6, "Win for player2"},
		{16, 14, "Win for player1"},
		{14, 16, "Win for player2"},
	}

	for _, sample := range testData {
		sample := sample
		t.Run(sample.expectedScore, func(t *testing.T) {
			t.Parallel()

			game := tennisGame1{
				m_score1:    sample.player1Score,
				m_score2:    sample.player2Score,
				player1Name: "player1",
				player2Name: "player2",
			}
			score := game.getScoreNameWhenAdvantageOrWin()
			if score != sample.expectedScore {
				t.Errorf("Expected score %s, got %s", sample.expectedScore, score)
			}
		})
	}
}

func TestGetScoreSamePoint(t *testing.T) {
	testData := []testDataSample{
		{0, 0, "Love-All"},
		{1, 1, "Fifteen-All"},
		{2, 2, "Thirty-All"},
		{3, 3, "Deuce"},
		{4, 4, "Deuce"},
	}

	for _, sample := range testData {
		sample := sample
		t.Run(sample.expectedScore, func(t *testing.T) {
			t.Parallel()

			game := tennisGame1{
				m_score1:    sample.player1Score,
				m_score2:    sample.player2Score,
				player1Name: "player1",
				player2Name: "player2",
			}
			score := game.getScoreSamePoint()
			if score != sample.expectedScore {
				t.Errorf("Expected score %s, got %s", sample.expectedScore, score)
			}
		})
	}
}

func TestGetScoreNormal(t *testing.T) {
	testData := []testDataSample{
		{1, 0, "Fifteen-Love"},
		{0, 1, "Love-Fifteen"},
		{2, 0, "Thirty-Love"},
		{0, 2, "Love-Thirty"},
		{3, 0, "Forty-Love"},
		{0, 3, "Love-Forty"},

		{2, 1, "Thirty-Fifteen"},
		{1, 2, "Fifteen-Thirty"},
		{3, 1, "Forty-Fifteen"},
		{1, 3, "Fifteen-Forty"},

		{3, 2, "Forty-Thirty"},
		{2, 3, "Thirty-Forty"},
	}

	for _, sample := range testData {
		sample := sample
		t.Run(sample.expectedScore, func(t *testing.T) {
			t.Parallel()

			game := tennisGame1{
				m_score1:    sample.player1Score,
				m_score2:    sample.player2Score,
				player1Name: "player1",
				player2Name: "player2",
			}
			score := game.getScoreNormal()
			if score != sample.expectedScore {
				t.Errorf("Expected score %s, got %s", sample.expectedScore, score)
			}
		})
	}
}
