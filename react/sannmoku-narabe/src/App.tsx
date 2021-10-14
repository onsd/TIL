import "./App.css";
import * as React from "react";

type SquareProps = {
  board: BoardValue[];
  location: number;
  onclick: (i: number) => void;
};

const Square: React.FC<SquareProps> = (props: SquareProps) => {
  return (
    <button className="square" onClick={() => props.onclick(props.location)}>
      {props.board[props.location]}
    </button>
  );
};

const renderSquare = (
  board: BoardValue[],
  location: number,
  clickHandler: (i: number) => void
) => {
  return <Square board={board} location={location} onclick={clickHandler} />;
};

type BoardValue = "X" | "O" | null
const Board: React.FC = () => {
  const status = "Next player: X";
  const [board, setBoard] = React.useState<BoardValue[]>(Array(9).fill(null));
  const [history, setHistory] = React.useState<void[]>()
  
  const clickHandler = (i: number) => {
    console.log(board);
    const state = board;
    state[i] = "X";
    setBoard([...state]);
  };

  return (
    <div>
      <div className="status">{status}</div>
      <div className="board-row">
        {renderSquare(board, 0, clickHandler)}
        {renderSquare(board, 1, clickHandler)}
        {renderSquare(board, 2, clickHandler)}
      </div>
      <div className="board-row">
        {renderSquare(board, 3, clickHandler)}
        {renderSquare(board, 4, clickHandler)}
        {renderSquare(board, 5, clickHandler)}
      </div>
      <div className="board-row">
        {renderSquare(board, 6, clickHandler)}
        {renderSquare(board, 7, clickHandler)}
        {renderSquare(board, 8, clickHandler)}
      </div>
    </div>
  );
};

const Game: React.FC = () => {
  return (
    <div className="game">
      <div className="game-board">
        <Board />
      </div>
      <div className="game-info">
        <div>{/* status */}</div>
        <ol>{/* TODO */}</ol>
      </div>
    </div>
  );
};

function App() {
  return <Game />;
}

export default App;
