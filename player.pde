class Player{
    private String name;
    private int score;
    private int roomId;

    Player(String name, int roomId){
        this.name = name;
        this.roomId = roomId;
        this.score = 0;
    }

    public void setScore(int score){
        this.score = score;
    }

    public void addScore(int score){
        this.score += score;
    }

    public void setroomId(int roomId){
        this.roomId = roomId;
    }

    public int getScore(){
        return score;
    }

    public int getroomId(){
        return roomId;
    }

    public String getName(){
        return name;
    }

    public String toJson(){
        return "{\"name\":\"" + name + "\",\"score\":" + score + ",\"roomId\":" + roomId + "}";
    }
}