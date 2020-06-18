export default class Cell {
  private _x: number;
  private _y: number;
  private _player: string | null;

  constructor(config: {x: number, y: number, player: string | null}) {
    this._x = config.x;
    this._y = config.y;
    this._player = config.player;
  }

  get player(): string | null {
    return this._player;
  }

  get x(): number {
    return this._x;
  }

  get y(): number {
    return this._y;
  }
}
