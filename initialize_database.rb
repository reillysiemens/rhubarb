require('trollop')

opts = Trollop::options do
    opt :db_location,   "Databse server location",  :short=> 'l', :default=> 'localhost'
    opt :db_user,       "Database User",            :short=> 'u', :default=> 'root'
    opt :db_password,   "Database Password",        :short=> 'p', :defualt=> '', :type=> String
    opt :db_database,   "Database Name",            :short=> 'n', :default=> 'rhubarb'
    opt :db_prefix,     "Database Prefix",          :short=> 'r', :default=> '', :type=> String
end

p "Will create tables in database '" + opts[:db_database] +"' at server '" + opts[:db_location] + "' as user '" + opts[:db_user] + "'"

File.open('db_connection.rb','w') { |file| file.write("$hostname = \"" + opts[:db_location].to_s + "\"\n$database = \"" + opts[:db_database].to_s + "\"\n$username = \"" + opts[:db_user].to_s + "\"\n$password = \"" + opts[:db_password].to_s + "\"")} 
