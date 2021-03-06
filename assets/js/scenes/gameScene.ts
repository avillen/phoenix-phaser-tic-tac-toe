// @ts-ignore
import Phaser from "phaser";
import Game from "../core/game";
import BoardInfo from "../core/boardInfo";
import { gameOptions, fontConfig } from "../app"

// @ts-ignore
export default class GameScene extends Phaser.Scene {
  gameState: Game;
  statusText: any;

  constructor() {
    super("gameScene");

    this.gameState = new Game();
  }

  create(config: {action: string, game_name: string, player_name: string}) {
    // @ts-ignore
    this.statusText = this.add.text(16, 16, "", fontConfig);

    if (config.action == "create") {
      this.gameState.createGame(config.game_name, config.player_name, gameOptions.boardSize);

    } else {
      this.gameState.joinGame(config.game_name, config.player_name);
    }
  }

  update() {
    if (this.gameState.boardInfo) {
      let boardInfo = this.gameState.boardInfo;

      if (this.gameState.errorMessage) {
        this.statusText.setText(this.gameState.errorMessage);
        this.gameState = new Game();
        // @ts-ignore
        this.scene.start("menuScene");

      } else if (this.gameState.status === "winner") {
        this.statusText.setText("Ha ganado " + this.gameState.turn);
        this.gameState = new Game();
        // @ts-ignore
        this.scene.start("menuScene");

      } else if (this.gameState.status === "empate") {
        this.statusText.setText("Empate");
        this.gameState = new Game();
        // @ts-ignore
        this.scene.start("menuScene");

      } else if (this.gameState.status === "waiting_for_player") {
        this.statusText.setText("Esperando jugador");

      } else if (this.gameState.turn) {
        this.statusText.setText("Le toca a " + this.gameState.turn);
      }

      this.printBoard(boardInfo);
    } else if (this.gameState.errorMessage) {
      this.statusText.setText(this.gameState.errorMessage);
      this.gameState = new Game();
      // @ts-ignore
      this.scene.start("menuScene");
    }
  }

  printBoard(boardInfo: BoardInfo) {
    let size: number = boardInfo.size;
    let tileSize: number = gameOptions.tileSize;
    let offset: number = gameOptions.tileOffset;
    let topMargin: number = gameOptions.tileTopMargin;

    let cont:number = 0;

    for (let i = 0; i < size; i++) {
      for (let j = 0; j < size; j++) {
        let position_x = (tileSize / 2) + offset + (i * (tileSize + offset));
        let position_y = (tileSize / 2) + offset + (j * (tileSize + offset)) + topMargin;

        // @ts-ignore
        let cellSprite = this.add.sprite(position_x, position_y, "blankSquare");

        cellSprite.index = cont++;
        cellSprite.setInteractive();
        cellSprite.on("pointerdown", this.handleClick);

        let cell = boardInfo.getCell(i, j);

        if (cell.player == "X") {
          // @ts-ignore
          this.add.sprite(position_x, position_y, 'thePlayers', 1);
        } else if (cell.player == "O") {
          // @ts-ignore
          this.add.sprite(position_x, position_y, 'thePlayers', 0);
        }
      }
    }
  }

  handleClick(event) {
    // @ts-ignore
    let owner = this.scene;
    // @ts-ignore
    owner.gameState.move(this.index);
  }
}
