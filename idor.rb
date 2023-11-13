require 'sinatra'
require 'sqlite3'

def connect_db
  sql = SQLite3::Database.new('/Users/gauravjain/Documents/Flask_App/data.db')
  sql.results_as_hash = true
  sql
end

def get_db
  db = connect_db
  db
end

get '/' do
  '<h1>Hello</h1>'
end

get '/view/:id' do
  db = get_db
  id = params['id']
  entry = db.execute("SELECT id, name, password FROM users WHERE id=#{id}")
  return "<h1> ID|Name|Password </h1>
          <h1>#{entry[0]['id']} | #{entry[0]['name']} | #{entry[0]['password']}</h1>"
end
