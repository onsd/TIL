package tenniskata

type tennisGame1 struct {
	m_score1    int
	m_score2    int
	player1Name string
	player2Name string
}

func NewTennisGame1(player1Name string, player2Name string) *tennisGame1 {
	game := &tennisGame1{
		player1Name: player1Name,
		player2Name: player2Name}

	return game
}

func (game *tennisGame1) WonPoint(playerName string) {
	if playerName == "player1" {
		game.m_score1 += 1
	} else {
		game.m_score2 += 1
	}
}

func (game *tennisGame1) GetScore() string {
	isSameScore := game.m_score1 == game.m_score2
	if isSameScore {
		return game.GetScoreSamePoint()
	}

	isAdvantageOrWin := game.m_score1 >= 4 || game.m_score2 >= 4
	if isAdvantageOrWin {
		return game.GetScoreNameWhenAdvantageOrWin()
	}

	return game.GetScoreNormal()
}

func (game *tennisGame1) GetScoreNameWhenAdvantageOrWin() string {
	score := ""
	minusResult := game.m_score1 - game.m_score2
	if minusResult == 1 {
		score = "Advantage player1"
	} else if minusResult == -1 {
		score = "Advantage player2"
	} else if minusResult >= 2 {
		score = "Win for player1"
	} else {
		score = "Win for player2"
	}

	return score
}

func (game *tennisGame1) GetScoreSamePoint() string {
	score := ""
	switch game.m_score1 {
	case 0:
		score = "Love-All"
	case 1:
		score = "Fifteen-All"
	case 2:
		score = "Thirty-All"
	default:
		score = "Deuce"
	}

	return score
}

func (game *tennisGame1) GetScoreNormal() string {
	tempScore := 0
	score := ""
	for i := 1; i < 3; i++ {
		if i == 1 {
			tempScore = game.m_score1
		} else {
			score += "-"
			tempScore = game.m_score2
		}
		switch tempScore {
		case 0:
			score += "Love"
		case 1:
			score += "Fifteen"
		case 2:
			score += "Thirty"
		case 3:
			score += "Forty"
		}
	}
	return score
}
