// @ts-ignore
import Phaser from "phaser";
import { gameOptions, fontConfig } from "../app"

// @ts-ignore
export default class MenuScene extends Phaser.Scene {
  constructor() {
    super("menuScene");
  }

  create() {
    let selfCanvas = document.querySelector("canvas");
    selfCanvas.style.display = "none";

    let tileSize: number = gameOptions.tileSize;
    let offset: number = gameOptions.tileOffset;
    let topMargin: number = gameOptions.tileTopMargin;
    let position_x = offset;
    let position_y = tileSize * 2;

    // @ts-ignore
    let element = this.add.dom(position_x, position_y).createFromCache("loginform");

    element.addListener("click");
    element.parent.style.overflow = null;

    element.on("click", event => {
      var player_name = (<HTMLInputElement>document.getElementById("player_name")).value;
      var game_name = (<HTMLInputElement>document.getElementById("game_name")).value;

      if (event.target.name === "joinButton") {
        if (player_name !== "" && game_name !== "") {
          let sceneParams = { action: "join", player_name: player_name, game_name: game_name };

          selfCanvas.style.display = "block";
          // @ts-ignore
          this.scene.start("gameScene", sceneParams);
        }
      } else if (event.target.name === "createButton") {
        if (player_name !== "" && game_name !== "") {
          let sceneParams = { action: "create", player_name: player_name, game_name: game_name };

          selfCanvas.style.display = "block";
          // @ts-ignore
          this.scene.start("gameScene", sceneParams);
        }

      }
    }, this);
  }
}
