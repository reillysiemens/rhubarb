#!/usr/bin/env ruby

require('trollop')
require('mysql')

opts = Trollop::options do
    opt :db_location,   "Databse server location",  :short=> 'l', :default=> 'localhost'
    opt :db_user,       "Database User",            :short=> 'u', :default=> 'root'
    opt :db_password,   "Database Password",        :short=> 'p', :defualt=> '', :type=> String
    opt :db_database,   "Database Name",            :short=> 'n', :default=> 'rhubarb'
    #opt :db_prefix,     "Database Prefix",          :short=> 'r', :default=> '', :type=> String
end

p "Attempting to create tables in database '" + opts[:db_database] +"' at host '" + opts[:db_location] + "' as user '" + opts[:db_user] + "...'"

File.open('db_connection.rb','w') { |file| file.write("$hostname = \"" + opts[:db_location].to_s + "\"\n$database = \"" + opts[:db_database].to_s + "\"\n$username = \"" + opts[:db_user].to_s + "\"\n$password = \"" + opts[:db_password].to_s + "\"")} 

#THIS
create_rhubarb_games = "CREATE  TABLE `rhubarb_games` (`id` INT NOT NULL AUTO_INCREMENT ,`winner` INT NOT NULL ,`loser` INT NOT NULL ,`winner_score` INT NOT NULL ,`loser_score` INT NOT NULL ,`sender_id` INT NOT NULL ,`recipient_id` INT NOT NULL ,`timestamp` INT NOT NULL ,`state` INT NOT NULL ,PRIMARY KEY (`id`) )ENGINE = InnoDB;"
#UGLY
create_rhubarb_players = "CREATE  TABLE `rhubarb_players` (`id` INT NOT NULL AUTO_INCREMENT ,`name` VARCHAR(70) NOT NULL ,`username` VARCHAR(20) NOT NULL ,`password` VARCHAR(64) NOT NULL ,`rating_package` VARCHAR(64) NOT NULL ,`current_rating` INT NOT NULL ,`status` INT NOT NULL ,PRIMARY KEY (`id`) )ENGINE = InnoDB;"

create_rhubarb_ratings = "CREATE  TABLE `rhubarb_ratings` (`id` INT NOT NULL AUTO_INCREMENT ,`player_id` INT NOT NULL ,`game_id` INT NOT NULL ,`rating_delta` INT NOT NULL ,`rating` INT NOT NULL ,PRIMARY KEY (`id`) )ENGINE = InnoDB;"

#Create a connection to the database with the supplied information
con = Mysql.new(opts[:db_location], opts[:db_user], opts[:db_password], opts[:db_database])

#Create tables in database
con.query(create_rhubarb_games)
p "Successfully created table rhubarb_games in database '" + opts[:db_database] + "'."
con.query(create_rhubarb_players)
p "Successfully created table rhubarb_players in database '" + opts[:db_database] + "'."
con.query(create_rhubarb_ratings)
p "Successfully created table rhubarb_ratings in database '" + opts[:db_database] + "'."
