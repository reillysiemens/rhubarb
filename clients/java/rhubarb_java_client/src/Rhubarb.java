import java.net.*;
import java.io.*;

import org.json.simple.*;
import org.json.simple.parser.*;

public class Rhubarb {          
    public final static String baseURL = "cf416-01.cs.wwu.edu";

    public static void main(String[] args) throws Exception{
        System.out.println("Rhubarb started");
        getGames();
    }

    public static void getGames()  throws Exception{
        URL gamesURL = new URL("http" , baseURL, 10081,  "/getGames");
        URLConnection gamesConnection = gamesURL.openConnection();
        //gamesConnection.setDoOutput(true);

        //OutputStreamWriter wr = new OutputStreamWriter(gamesConnection.getOutputStream());
        //wr.write("test=test");
        //wr.close();
        
        BufferedReader br = new BufferedReader(new InputStreamReader(gamesConnection.getInputStream()));
        String line = br.readLine();
        br.close();

        //System.out.println(line);

        JSONParser jp = new JSONParser();
        JSONArray games = (JSONArray) jp.parse(line);

        for(int i = 0; i < games.size(); i++){
            //System.out.println(games.get(i));    
            JSONObject game = (JSONObject)games.get(i);
            System.out.println(game);
        }
    }                     

    //this is not implemented and just returns games, lol.
    public void getPlayers()  throws Exception{
        URL gamesURL = new URL(baseURL + "/getGames");
        URLConnection gamesConnection = gamesURL.openConnection();
        gamesConnection.setDoOutput(true);

        OutputStreamWriter wr = new OutputStreamWriter(gamesConnection.getOutputStream());
        //wr.write("test=test");
        wr.close();
        
        BufferedReader br = new BufferedReader(new InputStreamReader(gamesConnection.getInputStream()));
        String line = br.readLine();
        br.close();

        System.out.println(line);

        JSONParser jp = new JSONParser();
        JSONArray games = (JSONArray) jp.parse(line);

        for(int i = 0; i < games.size(); i++){
            System.out.println(games.get(i));
        }
    }
}
