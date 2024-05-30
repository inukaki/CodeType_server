class Room {
    private int roomId;
    private int playerCount;
    private boolean isPlaying;
    private final int maxPlayerCount = 2;
    private ArrayList<Player> playerlist = new ArrayList<Player>();

    Room(int roomId) {
        this.roomId = roomId;
        this.playerCount = 0;
        this.isPlaying = false;
    }

    void isPlaying() {
        isPlaying = true;
    }
    void isNotPlaying() {
        isPlaying = false;
    }
    boolean getIsPlaying() {
        return isPlaying;
    }

    void addPlayer(Player player) {
        if (playerCount < maxPlayerCount) {
            playerCount++;
            playerlist.add(player);
        }
    }

    void removePlayer(String name) {
        for (int i = 0; i < playerlist.size(); i++) {
            if (playerlist.get(i).getName().equals(name)) {
                playerlist.remove(i);
                playerCount--;
                break;
            }
        }
    }

    ArrayList<Player> getPlayerList() {
        return playerlist;
    }

    int getroomId() {
        return roomId;
    }

    int getPlayerCount() {
        return playerCount;
    }

    void setScore(String name, int score) {
        for (int i = 0; i < playerlist.size(); i++) {
            if (playerlist.get(i).getName().equals(name)) {
                playerlist.get(i).setScore(score);
                break;
            }
        }
    }

    String toJson() {
        String json = "{";
        json += "\"roomId\":" + roomId + ",";
        json += "\"playerCount\":" + playerCount + ",";
        json += "\"isPlaying\":" + isPlaying + ",";
        json += "\"maxPlayerCount\":" + maxPlayerCount + ",";
        json += "\"playerList\":[";
        for (int i = 0; i < playerlist.size(); i++) {
            json += playerlist.get(i).toJson();
            if (i != playerlist.size() - 1) {
                json += ",";
            }
        }
        json += "]";
        json += "}";
        return json;
    }
}