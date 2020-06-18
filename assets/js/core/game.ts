import BoardInfo from "./boardInfo"
import socket from "../socket"

export default class Game {
  boardInfo: BoardInfo | null;
  channel: any;
  name: string | null;
  player: string | null;
  player_2: string | null;
  status: string | null;
  turn: string | null;
  errorMessage: string | null;

  constructor() {
    this.boardInfo = null;
    this.channel = null;
    this.name = null;
    this.player = null;
    this.player_2 = null;
    this.status = null;
    this.turn = null;
    this.errorMessage = null;
  }

  createGame(gameName: string, playerName: string, boardSize: number) {
    let createParams = {username: playerName, game_name: gameName}

    this.boardInfo = new BoardInfo({size: boardSize});

    this.channel = socket.channel("game:" + gameName, {});
    this.channel.join();
    this.channel.push("create", createParams)
      .receive("error", (resp: any) => { this.errorMessage = resp.response });

    this.channel.on("create", (resp: any) => {
        this.name = resp.response.name;
        this.player = resp.response.player_1.nick;
        this.status = resp.response.status;
    });

    this.channel.on("join", (resp: any) => {
        this.player_2 = resp.response.player_2.nick;
        this.status = resp.response.status;
        this.turn = resp.response.turn.nick;
    });

    this.channel.on("move", (resp: any) => {
      let size = resp.response.board_info.ancho;
      let raw_board = resp.response.board_info.board;

      this.boardInfo = new BoardInfo({size: size}).loadBoardInfo(raw_board);
      this.status = resp.response.status;
      this.turn = resp.response.turn.nick;
    });
  }

  joinGame(gameName: string, playerName: string) {
    this.channel = socket.channel("game:" + gameName, {});

    this.channel.join();

    this.channel.push("join", {username: playerName, game_name: gameName})
      .receive("error", (resp: any) => { this.errorMessage = resp.response });

    this.channel.on("join", (resp: any) => {
        let ancho = resp.response.board_info.ancho;
        let raw_board = resp.response.board_info.board;

        this.boardInfo = new BoardInfo({size: ancho}).loadBoardInfo(raw_board);
        this.name = resp.response.name;
        this.player = resp.response.player_2.nick;
        this.player_2 = resp.response.player_1.nick;
        this.status = resp.response.status;
        this.turn = resp.response.turn.nick;
    });

    this.channel.on("move", (resp: any) => {
      let size = resp.response.board_info.ancho;
      let raw_board = resp.response.board_info.board;

      this.boardInfo = new BoardInfo({size: size}).loadBoardInfo(raw_board);
      this.status = resp.response.status;
      this.turn = resp.response.turn.nick;
    });
  }

  move(index: number) {
    let moveParams = {username: this.player, game_name: this.name, index: index};

    this.channel.push("move", moveParams);
  }
}
