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
      var username = (<HTMLInputElement>document.getElementById("username")).value;
      var game = (<HTMLInputElement>document.getElementById("game")).value;

      if (event.target.name === "joinButton") {
        if (username !== "" && game !== "") {
          let sceneParams = { action: "join", username: username, game: game };

          selfCanvas.style.display = "block";
          // @ts-ignore
          this.scene.start("gameScene", sceneParams);
        }
      } else if (event.target.name === "createButton") {
        if (username !== "" && game !== "") {
          let sceneParams = { action: "create", username: username, game: game };

          selfCanvas.style.display = "block";
          // @ts-ignore
          this.scene.start("gameScene", sceneParams);
        }

      }
    }, this);
  }
}
