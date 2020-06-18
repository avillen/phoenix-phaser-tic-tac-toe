// @ts-ignore
import Phaser from "phaser";
import socket from "../socket";

// @ts-ignore
export default class BootScene extends Phaser.Scene {
  constructor() {
    super("bootScene");
  }

  // specify images, audio, or other assets before starting the scene
  preload(): void {
    // @ts-ignore
    this.load.image('blankSquare', 'images/emptytile.png');
    // @ts-ignore
    this.load.spritesheet('thePlayers', 'images/ttt_ox.png', {frameWidth: 200, frameHeight: 173});
    // @ts-ignore
    this.load.html("loginform", "htmls/loginform.html");
  }

  create() {
    // @ts-ignore
    this.scene.start("menuScene");
  }
}
