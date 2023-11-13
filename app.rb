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

after do
  if defined?(db) && db
    db.close
  end
end

get '/' do
  '<h1> Enter your name paduwan</h1>
  <form method="GET" action="/hel">
    <input type="text" name="fname">
    <input type="submit" value="Submit">
  </form>'
end

get '/hel' do
  na = params['fname']
  db = get_db
  db.execute('insert into profile(pname) values(?)', [na])
  db.commit

  "<h1>Hello #{na}.</h1>
  <h2>Search other ID's<h2>
  <form method='GET' action='/serc'>
    <input type='text' name='idd'>
    <input type='submit' value='See database'>
  </form>
  <form method='GET' action='/'>
    <input type='submit' value='Enter name again'>
  </form>"
end

get '/serc' do
  idd = params['idd']
  db = get_db
  abc = "select * from profile where id=#{idd}"
  entr = db.execute(abc).first
  "<h1>Hello #{entr['pname']}</h1>"
end

get '/json' do
  content_type :json
  { key3: 'value', key2: [1, 2, 3] }.to_json
end

get '/theform' do
  "<h1> Enter details to enter into the database.</h1>
  <form method='GET' action='/wel'>
    <input type='text' name='uname'>
    <input type='password' name='password'>
    <input type='submit' value='Submit'>
  </form>
  <form method='GET' action='/viewresults'>
    <input type='submit' value='See database'>
  </form>"
end

get '/wel' do
  name = params['uname']
  password = params['password']
  db = get_db
  db.execute('insert into users(name, password) values(?, ?)', [name, password])
  db.commit

  "<h1>Hello, insert into the database successful</h1>
  <form method='GET' action='/viewresults'>
    <input type='submit' value='See database'>
  </form>
  <form method='GET' action='/theform'>
    <input type='submit' value='Insert Another ID'>
  </form>"
end

get '/viewresults' do
  "<h1> Enter ID to view results.</h1>
  <form method='GET' action='/result'>
    <input type='text' name='ids'>
    <input type='submit' value='View Results'>
  </form>"
end

get '/result' do
  id = params['ids']
  db = get_db
  abc = "select id, name, password from users where id=#{id}"
  entry = db.execute(abc)
  erb :display, locals: { results: entry }
end

get '/result2' do
  id = params['ids']
  result = `#{id}`
  erb :display, locals: { results: result }
end

__END__

@@display
<h1> Results </h1>
<% results.each do |row| %>
  <h1> ID: <%= row['id'] %>, Name: <%= row['name'] %>, Password: <%= row['password'] %></h1>
<% end %>
