let Game = {

	start: function() {

		let points = 0;
		let start = new Date();
		let width = 800;
		let height = 400;
		let tilesize = 16;
		let sprite = "assets/images/sprite.png";
		let map = {
			ground1: [0,0],
			ground2: [1,0],
			ground3: [2,0],
			ground4: [3,0],
			item: 	 [0,1],
			wall1:   [0,2],
			wall2:   [1,2],
			player:  [0,3]
		};
		let assetsObj = {
		    "sprites": {
		        sprite: {
		            "tile": tilesize,
		            "tileh": tilesize,
		            "map": map,
		            "paddingX": 5,
		            "paddingY": 5,
		            "paddingAroundBorder": 0
		        }
		    }
		};
		let player = null;
		let pointsText = null;
		let startText = null;
		let endText = null;
		let stopText = null;

		Crafty.sprite(tilesize, sprite, map);


		/** Para o jogo */
		let parar = function (){
			Crafty.stop();
			points = 0;
		}

		let gravar = function (){
			$.ajax({
                  url: jsRoutes.controllers.GameController.gravar().url,
                    headers: {'Csrf-Token': tkn},
                    type: "POST",
                    data: { pontos: points },
                  success: function(data, status, jqXHR){},
                  error: function(jqXHR, status, errorThrown){}
            });
		}


		/** Cria as paredes do ambiente */
		let generateWalls = function (){
		
			for(let i=1; i<20; i++){
				for(let j=10; j<50; j+=10){
					Crafty.e("2D, DOM, wall, wall2, Solid")
					.attr({x: j * tilesize, y: i * tilesize, z: 2});
				}
			}
			for(let i=10; i<24; i++){
				for(let j=5; j<50; j+=10){
					Crafty.e("2D, DOM, wall, wall2, Solid")
					.attr({x: j * tilesize, y: i * tilesize, z: 2});
				}
			}
			
			for(var i = 0; i < 50; i++) {
				Crafty.e("2D, Canvas, wall_top, wall1, Solid")
					.attr({x: i * tilesize, y: 0, z: 2});
				Crafty.e("2D, DOM, wall_bottom, wall1, Solid")
					.attr({x: i * tilesize, y: 384, z: 2});
			}
			for(var i = 1; i < 24; i++) {
				Crafty.e("2D, DOM, wall_left, wall1, Solid")
					.attr({x: 0, y: i * tilesize, z: 2});
				Crafty.e("2D, Canvas, wall_right, wall1, Solid")
					.attr({x: 784, y: i * tilesize, z: 2});
			}
			
		}
		
		/** Cria os items para serem coletados pelo player */
		let generateItems = function (){
			for(var i = 0; i < 50; i++) {
				for(var j = 0; j < 25; j++) {
					if(i > 0 && i < 49 && i% 5 > 0 && j > 0 && j < 24 && Crafty.math.randomInt(0,100) > 99) {
						Crafty.e("2D, DOM, item, Animate, SpriteAnimation, Solid")
							.attr({x: i * tilesize, y: j * tilesize})
							.reel('ObjItem', 1000, 0, 1, 3)
							.animate('ObjItem', -1);
					}
				}
			}
		}
		
		/** Cria o chão */
		let generateGround = function (){
			for(var i = 0; i < 50; i++) {
				for(var j = 0; j < 25; j++) {
					groundType = Crafty.math.randomInt(1,3);
					Crafty.e("2D, Canvas, ground"+groundType)
						.attr({x: i * tilesize, y: j * tilesize});
				}
			}
		}
		
		/** Cria o jogador */
		let createPlayer = function (){
			player = Crafty.e("2D, Canvas, player, Fourway, Animate, Collision, Mouse, Keyboard, SpriteAnimation")
				.attr({x: 100, y: 144, z: 1})
				.fourway(100)
				.collision()
				.reel('PlayerGoDown', 1000, 0, 3, 3)
				.reel('PlayerGoUp', 1000, 0, 4, 3)
				.reel('PlayerGoLeft', 1000, 0, 5, 3)
				.reel('PlayerGoRight', 1000, 0, 6, 3)
				.onHit("wall_left", function() {
					this.x += 2;
				})
				.onHit("wall_right", function() {
					this.x -= 2;
				})
				.onHit("wall_bottom", function() {
					this.y -= 2;
				})
				.onHit("wall_top", function() {
					this.y += 2;
				})
				.onHit('wall', function(obj,firstTime) {
					let wx = obj[0].obj.x;
					let wy = obj[0].obj.y;

					if(this._direction.x == -1 && this.x > wx){
						this.x = wx + tilesize; //Direction: Left
					} else if(this._direction.x == 1 && this.x < wx) {
						this.x = wx - tilesize; //Direction: Right
					}

					if(this._direction.y == -1 && this.y > wy){
						this.y = wy + tilesize; //Direction: Up
					} else if(this._direction.y == 1 && this.y < wy) {
						this.y = wy - tilesize; //Direction: Down
					}
				})
				.onHit("item", function(obj,firstTime) {
					obj[0].obj.destroy();
					points += 10;
					if(Crafty("item").get().length == 0){
						endText = Crafty.e("2D, Canvas, endText, Text, Mouse")
								.attr({x: 250, y: 200, z: 1})
								.text(function () { return "Fim do jogo. Pontos: " + points })
								.textColor('rgba(255, 255, 255, 1)')
								.textFont({ size: '24px', weight: 'bold' });
						gravar();
						parar();
					}
					
				})
				.bind('KeyDown', function(e) {
					if (e.key == Crafty.keys.LEFT_ARROW) {
						this.animate('PlayerGoLeft', -1)
					} else if (e.key == Crafty.keys.RIGHT_ARROW) {
						this.animate('PlayerGoRight', -1)
					} else if (e.key == Crafty.keys.UP_ARROW) {
						this.animate('PlayerGoUp', -1)
					} else if (e.key == Crafty.keys.DOWN_ARROW) {
						this.animate('PlayerGoDown', -1)
					}
				 })
				 .bind('KeyUp', function() {
				 	this.pauseAnimation();
				 });
		}
		
		Crafty.scene("main", function() {
		
			generateGround();
			generateWalls();
			
			startText = Crafty.e("2D, Canvas, pointsText, Text, Mouse")
						.attr({x: 350, y: 200, z: 1})
						.text("Iniciar")
						.textColor('rgba(255, 255, 255, 1)')
						.textFont({ size: '20px', weight: 'bold' })
						.bind('Click', function(MouseEvent){
							this.destroy();
					  		generateItems();
							createPlayer();
							
							pointsText = Crafty.e("2D, Canvas, pointsText, Text, Mouse")
										.attr({x: 20, y: 20, z: 1})
										.text(function () { return "Pontos: " + points })
										.dynamicTextGeneration(true)
										.textColor('rgba(255, 255, 255, 0.8)')
										.textFont({ size: '14px', weight: 'bold' });
							stopText = Crafty.e("2D, Canvas, stopText, Text, Mouse")
										.attr({x: 735, y: 20, z: 1})
										.text("parar")
										.textColor('rgba(255, 255, 255, 0.8)')
										.textFont({ size: '14px', weight: 'bold' })
										.bind('Click', function(MouseEvent){
											parar();
										});
						});

			
		});


		/** Carrega */
		Crafty.scene("loading", function() {

			//Mostra a mensagem "carregando..." enquanto carrega o jogo
			Crafty.background("#000000");
			let loadingText = Crafty.e("2D, DOM, loadingText, Text").attr({w: 100, h: 20, x: 400, y: 200})
				.text("Carregando...")
				.css({"text-align": "center"});

			//Quando estiver tudo carregado
			Crafty.load(assetsObj, function() {
				Crafty.scene("main");
				loadingText.destroy();
			});
		});


		//Inicio o jogo
		Crafty.init(width, height);
		Crafty.scene("loading");

	}
};

$( document ).ready(function() {
	Game.start();
});