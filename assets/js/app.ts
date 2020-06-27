// @ts-ignore
import Phaser from "phaser";
import GameScene from "./scenes/gameScene";
import BootScene from "./scenes/bootScene";
import MenuScene from "./scenes/menuScene";

const _css = require("../css/app.scss");

export const gameOptions = {
  boardSize: 3,
  tileSize: 200,
  tileOffset: 20,
  tileTopMargin: 60,
  aspectRatio: 16/9
};

export const fontConfig = {
  fontSize: "32px",
  fill: "#000"
};

// @ts-ignore
export class HytaGame extends Phaser.Game {
  constructor(config) {
    super(config);
  }
}

window.onload = () => {
  let width = gameOptions.boardSize * (gameOptions.tileSize + gameOptions.tileOffset) + gameOptions.tileOffset;
  let height = width + gameOptions.tileTopMargin;

  let config = {
    type: Phaser.AUTO,
    backgroundColor: 0xecf0f1,
    dom: { createContainer: true },
    scale: {
      parent: "phaser-game",
      autoCenter: Phaser.Scale.CENTER_BOTH,
      width: width,
      height: height
    },
    scene: [BootScene, GameScene, MenuScene]
  };

  let game = new HytaGame(config);

  window.focus();
  resizeGame(game);
  window.addEventListener("resize", function() { resizeGame(game) });
};

function resizeGame(game) {
  let canvas = document.querySelector("canvas");
  let windowWidth = window.innerWidth;
  let windowHeight = window.innerHeight;
  let windowRatio = windowWidth / windowHeight;
  let gameRatio = game.config.width / game.config.height;

  if(windowRatio < gameRatio){
    canvas.style.width = windowWidth + "px";
    canvas.style.height = (windowWidth / gameRatio) + "px";
  } else {
    canvas.style.width = (windowHeight * gameRatio) + "px";
    canvas.style.height = windowHeight + "px";
  }
}
