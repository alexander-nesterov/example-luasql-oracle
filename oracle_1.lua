--------------------------------------------
-- get number of session
--------------------------------------------

-- load library if path is specific
package.cpath = "/luasql/oci8.so"

-- load driver
local luasql = require "luasql.oci8"

--------------------------------------------
-- database connection settings
--------------------------------------------

DBHOST = 'ip'
DBSID = 'sid'
DBUSER = 'user'
DBPASS = 'password'
DBPORT = 1555
CONNECTION_STRING = string.format('(DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = %s)(PORT = %s)) (CONNECT_DATA = (SID = %s)))', DBHOST, DBPORT, DBSID)
SQL = 'SELECT count(*) AS count FROM V$SESSION'

--------------------------------------------
-- start
--------------------------------------------

local env = assert(luasql.oci8())

local dbcon, err_con = env:connect(CONNECTION_STRING, DBUSER, DBPASS)

if not err_con then

	local cur, err_cur = dbcon:execute(SQL)

	if not err_cur then

		local row, err_fetch = cur:fetch({}, "a")

		if not err_fetch then

				print(string.format("Number of session: %d", row.count))

		else
			print(string.format("Error fetch: %s", err_fetch))
		end

		-- close cursor
		cur:close()
	else
		print(string.format("Error execute: %s", err_cur))
	end
	
	-- close connection
	dbcon:close()
else
	print(string.format("Error connection: %s", err_con))
end

env:close()