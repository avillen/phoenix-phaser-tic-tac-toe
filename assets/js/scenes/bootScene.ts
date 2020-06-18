import Phaser from "phaser";
import socket from "../socket";

export default class BootScene extends Phaser.Scene {
  constructor() {
    super("bootScene");
  }

  // specify images, audio, or other assets before starting the scene
  preload(): void {
    this.load.image('blankSquare', 'images/emptytile.png');
    this.load.spritesheet('thePlayers', 'images/ttt_ox.png', {frameWidth: 200, frameHeight: 173});
    this.load.html("loginform", "htmls/loginform.html");
  }

  create() {
    this.scene.start("menuScene");
  }
}
