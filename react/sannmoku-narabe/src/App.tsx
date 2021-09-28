import './App.css';
import * as React from 'react'

const Square: React.FC = () => {
  return <button className="square">{/* TODO */}</button>;
}

const renderSquare = (i : number) => {
  return <Square />;
}

const Board: React.FC = () => {
  const status = "Next player: X";
  return (
    <div>
      <div className="status">{status}</div>
        <div className="board-row">
          {renderSquare(0)}
          {renderSquare(1)}
          {renderSquare(2)}
        </div>
        <div className="board-row">
          {renderSquare(3)}
          {renderSquare(4)}
          {renderSquare(5)}
        </div>
        <div className="board-row">
          {renderSquare(6)}
          {renderSquare(7)}
          {renderSquare(8)}
        </div>
    </div>
  )
}

const Game :React.FC = () => {
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
}

function App() {
  return (
    <Game />
  );
}

export default App;
