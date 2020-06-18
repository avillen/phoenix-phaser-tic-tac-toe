import Cell from "./cell"

export default class BoardInfo {
  private _size: number;
  private _board: Cell[][];

  constructor(config: {size: number}) {
    this._size = config.size;
    this._board = [];

    for(let i: number = 0; i < this._size; i++) {
      this._board[i] = []

      for(let j: number = 0; j < this._size; j++) {
        this._board[i][j] = new Cell({x: i, y: j, player: null});
      }
    }
  }

  loadBoardInfo(raw_board: []) {
    let cont: number = 0;

    for(let i: number = 0; i < this._size; i++) {
      for(let j: number = 0; j < this._size; j++) {
        this._board[i][j] = new Cell({x: i, y: j, player: raw_board[cont]});

        cont++;
      }
    }

    return this;
  }

  get size(): number {
    return this._size;
  }

  get board(): Cell[][] {
    return this._board;
  }

  getCell(x: number, y: number): Cell {
    return this._board[x][y];
  }
}
