--------------------------------------------
-- get top tablespace
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
SQL = [[
		SELECT * FROM 
		(SELECT owner,
		segment_name AS TABLE_NAME,
		ROUND(bytes/1024/1024/1024, 1) AS GB 
		FROM dba_segments 
		WHERE segment_type = 'TABLE' 
		ORDER BY bytes/1024/1024 DESC) 
		WHERE ROWNUM <= 5
	]]

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

			local index = 1
			while row do
				print(string.format("%d) owner: %s, table: %s, size: %s %s", index, row.owner, row.table_name, row.gb, 'GB'))
				row = cur:fetch(row, "a")
				index = index+1
			end
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