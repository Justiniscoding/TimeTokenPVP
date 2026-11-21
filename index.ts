import { randomUUID } from "crypto";

function messageToText(event: string, ...args: any[]): string {
	let text = event;

	for (let i = 0; i < args.length; i++) {
		text += "\n" + args[i];
	}

	return text;
}

interface SocketData {
	id: string;
}

function emit(
	socket: Bun.ServerWebSocket<SocketData>,
	event: string,
	...args: any[]
) {
	socket.send(messageToText(event, ...args));
}

function publish(
	socket: Bun.ServerWebSocket<SocketData>,
	group: string,
	event: string,
	...args: any[]
) {
	socket.publish(group, messageToText(event, ...args));
}

// const rooms = {};

interface PlayerPositions {
	[key: string]: {
		x: number;
		y: number;
	};
}

const players: PlayerPositions = {};

const clients = new Map<string, Bun.ServerWebSocket<SocketData>>();

const server = Bun.serve({
	fetch(req, server) {
		server.upgrade(req, {
			data: {
				id: randomUUID(),
			},
		});
	},
	port: 8080,
	hostname: "0.0.0.0",
	tls: {
		cert: Bun.file("cert.pem"),
		key: Bun.file("key.pem")
	},
	websocket: {
		data: {} as SocketData,
		open(ws) {
			console.log("connection received from websocket");
			// ws.subscribe("findRooms");

			const playerX = Math.floor(Math.random() * 250);
			const playerY = -50;

			clients.set(ws.data.id, ws);

			emit(ws, "inGame", playerX, playerY);

			for (let playerId in players) {
				emit(ws, "newPlayer", playerId, players[playerId]?.x, players[playerId]?.y,);
			}

			players[ws.data.id] = { x: playerX, y: playerY };

			ws.subscribe("game");
			publish(ws, "game", "newPlayer", ws.data.id, playerX, playerY);
		},
		message(ws, message) {
			if (typeof message !== "string") {
				return;
			}

			const messageParts = message.split("\n");
			const type = messageParts[0];
			const args = messageParts.slice(1);

			// if(type == "createRoom"){
			// 	publish(ws, "findRooms", "createRoom", args[0]);
			// 	ws.subscribe(args[0] as string)
			// 	rooms.push();
			// }else if(type == "joinRoom"){
			// 	ws.subscribe(args[0] as string);
			// 	ws.unsubscribe("findRooms");
			// 	publish(ws, args[0] as string, "gameStart");
			// }else if(type == "move"){
			// 	publish(ws, ws.subscriptions[0] ?? "", "move", ...args);
			// }

			if (type == "playerMove") {
				publish(ws, "game", "playerMove", ws.data.id, ...args);
			} else if (type == "hitPlayer") {
				const hitClient = clients.get(args[0] as string);

				if (hitClient) {
					emit(hitClient, "hit", ...args.slice(1));
				}
			}
		},
		close(ws) {
			publish(ws, "game", "playerQuit", ws.data.id);
			delete players[ws.data.id];
			clients.delete(ws.data.id);
		},
	},
});
