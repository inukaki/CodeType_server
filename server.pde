import http.requests.*;
import processing.net.*;

final int port = 8025;
Server server;
Room[] rooms = new Room[6];
String[] request;


final int MAX_ROOM_COUNT = 6;

void setup(){
    server = new Server(this, port);
    println("Launching server:" + server.ip() + ":" + port);

    for(int i = 0; i < MAX_ROOM_COUNT; i++){
        rooms[i] = new Room(i);
    }
    // rooms[0].addPlayer(new Player("inukaki", 0));
    // rooms[5].addPlayer(new Player("ryo", 5));
    // rooms[5].addPlayer(new Player("8128", 5));
}

void draw(){
    Client client = server.available();
    if (client != null) {
        if(client.available() > 0) {
            request = client.readString().split("\n");
            if(RequestCheck("GET","/rooms")) RoomHandler(client);
            else if(RequestCheck("POST","/enter")) EnterHandler(client);
            else if(RequestCheck("POST","/exit")) ExitHandler(client);
            else if(RequestCheck("POST","/isPlaying")) isPlayingHandler(client);
            else if(RequestCheck("POST","/score")) postScoreHandler(client);

            client.stop();
        }
    }
}

void postScoreHandler(Client client){
    String[] path = split(trim(split(request[0], ' '))[1], '/');
    int roomId = int(path[2]);
    String name = path[3];
    int score = int(path[4]);
    rooms[roomId].setScore(name, score);
    client.write("HTTP/1.1 200 OK\n");
    client.write("Content-Type: application/json\n");
    client.write("\n");
    client.write(rooms[roomId].toJson());
    println(name + " posted score " + score + " in room " + roomId);
}

void isPlayingHandler(Client client){
    String[] path = split(trim(split(request[0], ' '))[1], '/');
    int roomId = int(path[2]);
    if(path[3].equals("true")) rooms[roomId].isPlaying = true;
    else rooms[roomId].isPlaying = false;
    client.write("HTTP/1.1 200 OK\n");
    client.write("Content-Type: application/json\n");
    client.write("\n");
    client.write(rooms[roomId].toJson());
    println("Room " + roomId + " is playing: ");
}

void ExitHandler(Client client){
    // GET /exit/0/inukaki HTTP/1.1 というリクエストが来たとき
    // /enter/0/inukakiを取り出して、/で分割して、['', 'enter', '0', 'inukaki']にする
    String[] path = split(trim(split(request[0], ' '))[1], '/');
    int roomId = int(path[2]);
    String name = path[3];
    rooms[roomId].removePlayer(name);
    client.write("HTTP/1.1 200 OK\n");
    client.write("Content-Type: application/json\n");
    client.write("\n");
    client.write(rooms[roomId].toJson());
    println(name + " exited room " + roomId);
}

void EnterHandler(Client client){
    // println(request[0]);
    // GET /enter/0/inukaki HTTP/1.1 というリクエストが来たとき
    // /enter/0/inukakiを取り出して、/で分割して、['', 'enter', '0', 'inukaki']にする
    String[] path = split(trim(split(request[0], ' '))[1], '/');
    int roomId = int(path[2]);
    String name = path[3];
    println("roomId: " + roomId + " name: " + name);
    rooms[roomId].addPlayer(new Player(name, roomId));
    client.write("HTTP/1.1 200 OK\n");
    client.write("Content-Type: application/json\n");
    client.write("\n");
    client.write(rooms[roomId].toJson());
    println(name + " entered room " + roomId);
}


void RoomHandler(Client client){
    String json = "[";
    for(int i = 0; i < rooms.length; i++){
        json += rooms[i].toJson();
        if(i != rooms.length - 1) json += ",";
    }
    json += "]";
    client.write("HTTP/1.1 200 OK\n");
    client.write("Content-Type: application/json\n");
    client.write("\n");
    client.write(json);
}

boolean RequestCheck(String method, String path){
    // println(request[0]);
    String[] paths = split(trim(split(request[0], ' '))[1], '/');
    return (trim(split(request[0], ' '))[0].equals(method)
    && ("/" + paths[1]).equals(path));
}